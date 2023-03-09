terraform {
  backend "azurerm" {
    resource_group_name  = "devanhanga-rg"
    storage_account_name = "devanhangabackendsa"
    container_name       = "tfstate"
    key                  = "dev.terraform.tfstate"
  }
}
