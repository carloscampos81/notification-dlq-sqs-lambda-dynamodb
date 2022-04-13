import json, boto3
from datetime import datetime
from model.NotificationDlq import NotificationDlq
from service.DynamoDbService import DynamoDbService as dynamodb_service
from service.MailService import MailService as mail_service
from service.SlackService import SlackService as slack_service


def handler(event : dict, context):

    try:
        total_records = len(event['Records'])
    except KeyError:
        total_records = 0
        pass

    if(total_records > 0):
            
        for record in event['Records']:
            
            try:
                notification_dlq = NotificationDlq.empty()
                NotificationDlq.from_record(notification_dlq, record)

                dynamodb_service.send_object_to_dynamodb(notification_dlq.to_dictionary())
                
                slack_service.send_message_to_slack(notification_dlq)

                mail_service.send_message_to_email_queue(notification_dlq)

            except Exception as e:
                print("Erro ao processar record ({}) - Exception: {} ".format(record, e))
                pass

    print('Processado(s) {} record(s) do evento enviado'.format(str(total_records)))

    return "Executado"

