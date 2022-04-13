from array import array
import json

class MailMessageQueue:

    assunto : str
    mensagem : str
    sistema : str
    remetente : str
    template : str
    cc : array
    cco : array
    destinatarios : array
    parametros : array

    def to_json(self):
        return json.dumps(self.to_dictionary())
    
    def to_dictionary(self):
        return self.__dict__
