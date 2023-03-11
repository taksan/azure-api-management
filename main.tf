resource "azurerm_resource_group" "rg" {
  location = var.resource_group_location
  name     = "drill-api-mgmt"
}

data "azurerm_client_config" "current" {}
data "azuread_client_config" "current" {}
