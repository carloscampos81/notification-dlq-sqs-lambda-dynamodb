import boto3
from utils import Envs


DYNAMODB_RESOURCE_NAME = Envs.get_env('DYNAMODB_RESOURCE_NAME')
DYNAMODB_TABLE_NAME = Envs.get_env('DYNAMODB_TABLE_NAME')
DYNAMODB_ENDPOINT_URL = Envs.get_env('DYNAMODB_ENDPOINT_URL')
DYNAMODB_REGION_NAME = Envs.get_env('DYNAMODB_REGION_NAME')


class DynamoDbService:

    def send_object_to_dynamodb(object_to_record : dict):
        
        try:
            client_dynamo = boto3.resource(DYNAMODB_RESOURCE_NAME, region_name = DYNAMODB_REGION_NAME, endpoint_url = DYNAMODB_ENDPOINT_URL)

            table = client_dynamo.Table(DYNAMODB_TABLE_NAME)
            
            response = table.put_item(Item=object_to_record)

            if(response['ResponseMetadata']['HTTPStatusCode'] == 200):
                print('Objeto salvo na tabela do DynamoDb')

            return response

        except Exception as e:
            print('Problema ao salvar na tabela do DynamoDb: ', e)
