import datetime
import json
import time

from boto3 import Session

from moto.core.exceptions import InvalidNextTokenException
from moto.core.models import ConfigQueryModel
from moto.s3control import s3control_backends
from moto.s3.models import get_moto_s3_account_id


class S3AccountPublicAccessBlockConfigQuery(ConfigQueryModel):
    def list_config_service_resources(
        self,
        resource_ids,
        resource_name,
        limit,
        next_token,
        backend_region=None,
        resource_region=None,
        aggregator=None,
    ):
        # For the Account Public Access Block, they are the same for all regions. The resource ID is the AWS account ID
        # There is no resource name -- it should be a blank string "" if provided.

        # The resource name can only ever be None or an empty string:
        if resource_name is not None and resource_name != "":
            return [], None

        pab = None
        account_id = get_moto_s3_account_id()
        regions = [region for region in Session().get_available_regions("config")]

        # If a resource ID was passed in, then filter accordingly:
        if resource_ids:
            for resource_id in resource_ids:
                if account_id == resource_id:
                    pab = self.backends["global"].public_access_block
                    break

        # Otherwise, just grab the one from the backend:
        if not resource_ids:
            pab = self.backends["global"].public_access_block

        # If it's not present, then return nothing
        if not pab:
            return [], None

        # Filter on regions (and paginate on them as well):
        if backend_region:
            pab_list = [backend_region]
        elif resource_region:
            # Invalid region?
            if resource_region not in regions:
                return [], None

            pab_list = [resource_region]

        # Aggregated query where no regions were supplied so return them all:
        else:
            pab_list = regions

        # Pagination logic:
        sorted_regions = sorted(pab_list)
        new_token = None

        # Get the start:
        if not next_token:
            start = 0
        else:
            # Tokens for this moto feature is just the region-name:
            # For OTHER non-global resource types, it's the region concatenated with the resource ID.
            if next_token not in sorted_regions:
                raise InvalidNextTokenException()

            start = sorted_regions.index(next_token)

        # Get the list of items to collect:
        pab_list = sorted_regions[start : (start + limit)]

        if len(sorted_regions) > (start + limit):
            new_token = sorted_regions[start + limit]

        return (
            [
                {
                    "type": "AWS::S3::AccountPublicAccessBlock",
                    "id": account_id,
                    "region": region,
                }
                for region in pab_list
            ],
            new_token,
        )

    def get_config_resource(
        self, resource_id, resource_name=None, backend_region=None, resource_region=None
    ):
        # Do we even have this defined?
        if not self.backends["global"].public_access_block:
            return None

        # Resource name can only ever be "" if it's supplied:
        if resource_name is not None and resource_name != "":
            return None

        # Are we filtering based on region?
        account_id = get_moto_s3_account_id()
        regions = [region for region in Session().get_available_regions("config")]

        # Is the resource ID correct?:
        if account_id == resource_id:
            if backend_region:
                pab_region = backend_region

            # Invalid region?
            elif resource_region not in regions:
                return None

            else:
                pab_region = resource_region

        else:
            return None

        # Format the PAB to the AWS Config format:
        creation_time = datetime.datetime.utcnow()
        config_data = {
            "version": "1.3",
            "accountId": account_id,
            "configurationItemCaptureTime": str(creation_time),
            "configurationItemStatus": "OK",
            "configurationStateId": str(
                int(time.mktime(creation_time.timetuple()))
            ),  # PY2 and 3 compatible
            "resourceType": "AWS::S3::AccountPublicAccessBlock",
            "resourceId": account_id,
            "awsRegion": pab_region,
            "availabilityZone": "Not Applicable",
            "configuration": self.backends[
                "global"
            ].public_access_block.to_config_dict(),
            "supplementaryConfiguration": {},
        }

        # The 'configuration' field is also a JSON string:
        config_data["configuration"] = json.dumps(config_data["configuration"])

        return config_data


s3_account_public_access_block_query = S3AccountPublicAccessBlockConfigQuery(
    s3control_backends
)
