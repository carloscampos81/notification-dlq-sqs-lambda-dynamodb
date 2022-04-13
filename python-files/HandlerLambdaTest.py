from importlib_metadata import files
import notification_dlq_lambda as notification_dlq_lambda

def handler_test():

    event = {'Records': [{'messageId': '11111111111', 'receiptHandle': 'AQEBrq9d1N/HX+QBTfb2TPzt9l0NBW214gmlTV1cwZ16IpOAj+oSMujrRYYhFqffCr71gpG9DzUPNq4PQP5NIR7EuFR5tCG7slmKrj35MyjMTTDTHQ/t/VIGXyuQXcwtcaXjoWulKNPTcDBSQDPk1zcMg3bQ4RNbNMASmFyTcsJ1ItxmmhbRszIOkL55A93KQp5o2hJwszGzTtcG33CbeGNB1p+HCWuNwNggqyl0ee1g9mAk7PTzjlWC6Bo2FG6GQJMt8znbTVowB6xpQH6OSjdnisjzLP7kWMYXB06dAcpDu5L1DKe4ikNOsUXge38yK19X4p7VXK1DtD9LiAmQ9/FPCuFwKUrs7bPrFcE/vt1wYKMdcmIDxwxp9n0fHV1Me8yc0tu+krND9diaNO+hQnA5zg==', 'body': '<CORPO DA MENSAGEM>', 'attributes': {'ApproximateReceiveCount': '1', 'SentTimestamp': '1644505693489', 'SenderId': '703760120003', 'ApproximateFirstReceiveTimestamp': '1644505693496'}, 'messageAttributes': {}, 'md5OfBody': '4c86b6841d2837c0a7a88df5005ce92c', 'eventSource': 'aws:sqs', 'eventSourceARN': 'arn:aws:sqs:us-east-1:703760120003:carteira_dlq_lambda', 'awsRegion': 'us-east-1'}]}

    result = notification_dlq_lambda.handler(event, None)

handler_test()