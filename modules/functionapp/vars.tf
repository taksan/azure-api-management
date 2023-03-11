variable "resourcegroup" {
}

variable "function_name" {
}

variable "function_storage_account_name" {
}

variable "runtime" {
}

variable "account_tier" {
    type = string
    default = "Standard"
}

variable "account_replication_type" {
    type = string
    default = "LRS"
}

variable "auth_settings" {
  type = object({
    tenant_id     = string
    client_id     = string
    client_secret = string
  })
  default = null
}