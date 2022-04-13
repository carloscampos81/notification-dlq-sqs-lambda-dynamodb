import boto3
from model.NotificationDlq import NotificationDlq
from model.MailMessageQueue import MailMessageQueue
from utils import Envs

SISTEMA = Envs.get_env('SISTEMA')
EMAIL_TEMPLATE = Envs.get_env('EMAIL_TEMPLATE')
EMAIL_REMETENTE = Envs.get_env('EMAIL_REMETENTE')
EMAIL_DESTINATARIOS = Envs.get_env('EMAIL_DESTINATARIOS', True)
EMAIL_DESTINATARIOS_CC = Envs.get_env('EMAIL_DESTINATARIOS_CC', True)
EMAIL_DESTINATARIOS_CCO = Envs.get_env('EMAIL_DESTINATARIOS_CCO', True)
EMAIL_PARAMETROS = Envs.get_env('EMAIL_PARAMETROS', True)
SQS_RESOURCE_NAME = Envs.get_env('SQS_RESOURCE_NAME')
CLOUD_AWS_SQS_QUEUE_NAME_EMAIL = Envs.get_env('CLOUD_AWS_SQS_QUEUE_NAME_EMAIL')
CLOUD_AWS_SQS_QUEUE_MESSAGE_GROUP_ID = Envs.get_env('CLOUD_AWS_SQS_QUEUE_MESSAGE_GROUP_ID')
CLOUD_AWS_REGION_NAME = Envs.get_env('CLOUD_AWS_REGION_NAME')
CLOUD_AWS_CREDENTIALS_ACCESS_KEY = Envs.get_env('CLOUD_AWS_CREDENTIALS_ACCESS_KEY')
CLOUD_AWS_CREDENTIALS_SECRET_KEY = Envs.get_env('CLOUD_AWS_CREDENTIALS_SECRET_KEY')

class MailService:

    def send_message_to_email_queue(notification_dlq : NotificationDlq):

        mail_request = MailMessageQueue()
        mail_request.remetente = EMAIL_REMETENTE
        mail_request.assunto = "Nova mensagem na fila de DLQ"
        mail_request.mensagem = notification_dlq.to_message("<br>")
        mail_request.sistema = SISTEMA
        mail_request.template = EMAIL_TEMPLATE
        mail_request.destinatarios = EMAIL_DESTINATARIOS
        mail_request.cc = EMAIL_DESTINATARIOS_CC
        mail_request.cco = EMAIL_DESTINATARIOS_CCO
        mail_request.parametros = EMAIL_PARAMETROS

        body = mail_request.to_json()
        
        try:
            client_sqs = boto3.client(SQS_RESOURCE_NAME, 
                      aws_access_key_id=CLOUD_AWS_CREDENTIALS_ACCESS_KEY, 
                      aws_secret_access_key=CLOUD_AWS_CREDENTIALS_SECRET_KEY, 
                      region_name=CLOUD_AWS_REGION_NAME)

            response = client_sqs.send_message(
                QueueUrl=CLOUD_AWS_SQS_QUEUE_NAME_EMAIL,
                DelaySeconds=0,
                MessageGroupId=CLOUD_AWS_SQS_QUEUE_MESSAGE_GROUP_ID,
                MessageDeduplicationId='messageDeduplication1', #depende da config da sqs
                MessageBody=(
                    body
                )
            )

            if(response['ResponseMetadata']['HTTPStatusCode'] == 200):
                print('Mensagem enviada para fila de email')

            return response

        except Exception as e:
            print('Erro ao enviar mensagem para fila: ', e)
