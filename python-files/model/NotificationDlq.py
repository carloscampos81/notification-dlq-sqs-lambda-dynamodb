from datetime import datetime
from utils import DictUtil as dict_util
import json

class NotificationDlq:
	
    id_mensagem: str
    nome_fila: str
    status : str
    body : str
    data_criacao : str

    def __init__(self, id_mensagem: str, nome_fila: str, status: str, body: str, data_criacao: str):
        self.id_mensagem = id_mensagem
        self.nome_fila = nome_fila
        self.status = status
        self.body = body
        self.data_criacao = data_criacao

    def from_record(self, record):
        self.id_mensagem = record['messageId']
        self.nome_fila = record['eventSourceARN']
        self.status = 'NAO_PROCESSADA'
        self.body = record['body']
        self.data_criacao = str(datetime.now())

    def to_message(self, newline_char : str = "\n"):
        return '{}{}{}{}{}{}{}{}'.format(
            "Mensagem na fila de DLQ: ", self.nome_fila, newline_char,
            "ID_MENSAGEM: ", self.id_mensagem, newline_char,
            "Corpo da mensagem: ", self.body)

    def to_dictionary(self):
        return self.__dict__

    def empty():
        return NotificationDlq(None, None, None, None, None)
