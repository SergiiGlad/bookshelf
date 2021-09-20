variable "project_id" {
  type = string
}

variable "secret_id" {
  type = string
}

variable "secret_data" {
  type    = string
  default = ""
}

variable "secret_data_cypher" {
  type    = string
  default = ""
}

variable "kms_crypto_key" {
  type    = string
  default = ""
}

variable "secret_accessors" {
  type = list(string)
}
