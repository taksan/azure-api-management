terraform {
  required_version = ">=1.3.5"

  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~>3.45.0"
    }
    random = {
      source  = "hashicorp/random"
      version = "~>3.0"
    }
    archive = {
      source = "hashicorp/archive"
      version = "2.3.0"
    }
    http = {
      source = "hashicorp/http"
      version = "3.2.1"
    }
    tls = {
      source = "hashicorp/tls"
      version = "4.0.4"
    }
  }
}

provider "azurerm" {
  features {
    key_vault {
      purge_soft_delete_on_destroy    = true
      recover_soft_deleted_key_vaults = true
    }
  }
}

