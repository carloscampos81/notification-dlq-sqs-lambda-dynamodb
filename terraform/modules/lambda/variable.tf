variable "function_name" {
    type        = string
    description = "Nome da function"
}

variable "environment" {
  type        = string
  description = "Nome do ambiente da fila SQS."
}


variable "s3_bucket_name" {
    type        = string
    default     = null
    description = "Nome do bucket"
}

variable "s3_key" {
    type        = string
    default     = null
    description = "Chave S3 de um objeto que contém o pacote de implantação da função"
}

variable "role_arn" {
    type        = any
    default     = []
    description = "Nome de recurso da Amazon (ARN) da função de execução da função. "
}

variable "handler" {
    type        = string
    description = "Ponto de entrada da função em seu código."
}

variable "runtime" {
    type        = string
    description = "O identificador do tempo de execução da função. "
}