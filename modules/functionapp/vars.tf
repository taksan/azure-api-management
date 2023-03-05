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
