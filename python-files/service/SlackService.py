import requests
import json
from model.NotificationDlq import NotificationDlq
from utils import Envs

SLACK_WEBHOOK_URL = Envs.get_env('SLACK_WEBHOOK_URL')

class SlackService:

	def send_message_to_slack(notification_dlq : NotificationDlq):

		slack_data = json.dumps({'text': notification_dlq.to_message()})
		headers = {'Content-Type': "application/json"}

		try:
			response = requests.request("POST", SLACK_WEBHOOK_URL, data=slack_data, headers=headers)
			
			if(response.status_code == 200):
				print("Mensagem enviada para o Slack.")

			return response
			
		except Exception as e:
			print('Erro ao enviar messagem para o Slack: ', e)

