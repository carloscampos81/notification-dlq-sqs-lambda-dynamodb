# Declaração de variáveis

## Variáveis globais
variable "aws_region" {
  type        = string
  default     = "us-east-1"
  description = "Região AWS padrão."
}

variable "s3_bucket_names" {
  type = list(any)
  default = [
    { name = "my-lambda-packages", bucket_cleanup = false }
  ]
  description = "Nome dos buckets S3."
}

variable "bucket_cleanup" {
  type        = bool
  default     = false
  description = "Se valor for True, é criado a politica de limpeza para os buckets"
}


variable "autoscaling_min_read_capacity" {
  type        = number
  default     = 5
  description = "Capacidade minima de unidade leitura"
}

variable "autoscaling_max_read_capacity" {
  type        = number
  default     = 10
  description = "Capacidade maxima de unidade de leitura"
}

variable "autoscaling_min_write_capacity" {
  type        = number
  default     = 5
  description = "Capacidade minima de unidade de escrita"
}

variable "autoscaling_max_write_capacity" {
  type        = number
  default     = 10
  description = "Capacidade minima de unidade de escrita"
}

variable "sqs_queue_names" {
  type = list(any)
  default = [
    { name = "notification-queue", visibility_timeout = 3600 },
  ]
  description = "Nome das filas SQS."
}