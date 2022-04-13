from pprint import pprint
import unittest
import boto3
from botocore.exceptions import ClientError
from moto import mock_dynamodb2
from model.NotificationDlq import NotificationDlq
from service.DynamoDbService import DynamoDbService
from utils import Envs

DYNAMODB_RESOURCE_NAME = Envs.get_env('DYNAMODB_RESOURCE_NAME')
DYNAMODB_TABLE_NAME = Envs.get_env('DYNAMODB_TABLE_NAME')
DYNAMODB_ENDPOINT_URL = Envs.get_env('DYNAMODB_ENDPOINT_URL')
DYNAMODB_REGION_NAME = Envs.get_env('DYNAMODB_REGION_NAME')

@mock_dynamodb2
class TestDatabaseFunctions(unittest.TestCase):

    def setUp(self):
        """Create the mock database and table"""
        self.dynamodb = boto3.resource('dynamodb', region_name='us-east-1')

        table = self.dynamodb.create_table(
            TableName=DYNAMODB_TABLE_NAME
            ,
            KeySchema=[
                {
                    'AttributeName': 'id_mensagem',
                    'KeyType': 'HASH'
                },
                {
                    'AttributeName': 'nome_fila',
                    'KeyType': 'RANGE'
                }
            ],
            AttributeDefinitions=[
                {
                    'AttributeName': 'id_mensagem',
                    'AttributeType': 'S'
                },
                {
                    'AttributeName': 'nome_fila',
                    'AttributeType': 'S'
                }
            ],
            ProvisionedThroughput={
                'ReadCapacityUnits': 1,
                'WriteCapacityUnits': 1
            }
        )
        
        # Wait until the table exists.
        table.meta.client.get_waiter('table_exists').wait(TableName=DYNAMODB_TABLE_NAME)
        assert table.table_status == 'ACTIVE'

    def test_put_carteira_dlq(self):
        
        notification_dlq = NotificationDlq.empty()
        notification_dlq.id_mensagem = "ID_MENSAGEM"
        notification_dlq.nome_fila = "arn:aws:sqs:us-east-1:703760120003:carteira_dlq_lambda"

        result = DynamoDbService.send_object_to_dynamodb(notification_dlq.to_dictionary())

        self.assertEqual(200, result['ResponseMetadata']['HTTPStatusCode'])
    

if __name__ == '__main__':
    unittest.main()