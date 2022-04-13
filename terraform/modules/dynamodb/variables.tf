variable "name" {
  type        = string
  description = "Nome da tabela"
}

variable "environment" {
  type        = string
  description = "Ambientes, e.g. 'prod', 'staging', 'dev', 'pre-prod', 'UAT'"
}

variable "billing_mode" {
  type        = string
  description = "DynamoDB Billing mode - 'PROVISIONED or PAY_PER_REQUEST' - Controle da cobrança da taxa de leitura e gravação"
}


variable "hash_key" {
  type        = string
  description = "O atributo a ser usado como a chave de hash (partição)."
}

variable "range_key" {
  type        = string

  description = "O atributo a ser usado como chave de intervalo (classificação)"
}

variable "attributes" {
  type        = list(map(string))
  default     = []
  description = "Os tipos de atributos devem ser: `S`, `N`, or `B` for (S)tring, (N)umber or (B)inary data"
}

variable "ttl_attribute_name" {
  type        = string
  default     = ""
  description = "O nome do atributo de tabela no qual armazenar o carimbo de data/hora TTL."
}

variable "ttl_enable" {
  type        = bool
  default     = false
  description = "Indica se ttl está habilitado (verdadeiro) ou desabilitado (falso)e"
}

variable "global_secondary_indexes" {
  description = "Descreva o GSI para a tabela; sujeito aos limites normais do número de GSIs, atributos projetados, etc."
  type        = any
  default     = []
}

variable "autoscale_min_read_capacity" {
  type        = number
  description = "DynamoDB autoscaling minimo read capacity"
}

variable "autoscale_max_read_capacity" {
  type        = number
  description = "DynamoDB autoscaling maximo read capacity"
}

variable "autoscale_min_write_capacity" {
  type        = number
  description = "DynamoDB autoscaling minimo write capacity"
}

variable "autoscale_max_write_capacity" {
  type        = number
  description = "DynamoDB autoscaling maximo write capacity"
}