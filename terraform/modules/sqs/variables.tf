variable "name" {
  type        = string
  description = "Nome da fila SQS."
}

variable "environment" {
  type        = string
  description = "Nome do ambiente da fila SQS."
}

variable "account_arn" {
  type        = string
  description = "ARN da conta que terá acesso à SQS."
}

variable "visibility_timeout" {
  type        = number
  description = "Timeout de visibilidade padrão da mensagem"
}

variable "function_arn" {
  type        = any
  default     = ""
  description = " O nome ou o ARN da função do Lambda que se inscreverá em eventos"
}