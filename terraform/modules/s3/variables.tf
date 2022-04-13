variable "name" {
  type        = string
  description = "Nome do bucket."
}

variable "bucket_lambda_name" {
  type        = string
  default     = ""
  description = "Nome do bucket."
}


variable "environment" {
  type        = string
  description = "Nome do ambiente do bucket."
}

variable "accounts_arn" {
  type        = string
  description = "ARN da conta que terá acesso ao bucket."
}

variable "bucket_cleanup" {
  type        = string
  description = "ARN da conta que terá acesso ao bucket."
}