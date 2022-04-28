locals {
  queue_name = "${var.name}-${var.environment}"
  dlq_name   = "${var.name}-dlq-${var.environment}"
}

# Criação da DLQ Standard
resource "aws_sqs_queue" "dlq_std" {
  name                        = "${local.dlq_name}"
  fifo_queue                  = false
  content_based_deduplication = false
  delay_seconds               = 5
  max_message_size            = 2048
  message_retention_seconds   = 1209600
  receive_wait_time_seconds   = 10
  tags = {
    Name        = local.dlq_name
    Environment = var.environment
  }
}

# Adicionando Permissão à DLQ Standard
resource "aws_sqs_queue_policy" "dlq_std_policy" {
  queue_url = aws_sqs_queue.dlq_std.id
  policy    = jsonencode({
    "Version": "2008-10-17",
    "Id": "__default_policy_ID",
    "Statement": [
      {
        "Sid": "__sender_statement",
        "Effect": "Allow",
        "Principal": {
          "AWS": "*"
        },
        "Action": "SQS:SendMessage",
        "Resource": aws_sqs_queue.dlq_std.arn
      },
      {
        "Sid": "__receiver_statement",
        "Effect": "Allow",
        "Principal": {
          "AWS": "*"
        },
        "Action": [
          "SQS:ChangeMessageVisibility",
          "SQS:DeleteMessage",
          "SQS:ReceiveMessage",
          "SQS:GetQueueUrl",
          "SQS:GetQueueAttributes"
        ],
        "Resource": aws_sqs_queue.dlq_std.arn
      }
    ]
  })
}

 #Adicionando o recurso para criação da trigger da function para todas as filas DLQ 
resource "aws_lambda_event_source_mapping" "event_source_mapping" {
  event_source_arn  = aws_sqs_queue.dlq_std.arn
  function_name     = var.function_arn
}