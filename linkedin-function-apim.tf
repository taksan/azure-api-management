data "azurerm_function_app_host_keys" "linkedin-profile" {
  name                = module.linkedin-profile.name
  resource_group_name = azurerm_resource_group.rg.name

  depends_on = [
    module.linkedin-profile
  ]
}

resource "azurerm_api_management_backend" "linkedin-profile-backend" {
  name                = "linkedin-profile-backend"
  resource_group_name = azurerm_resource_group.rg.name
  api_management_name = azurerm_api_management.api4fun.name
  protocol            = "http"
  url                 = "https://${module.linkedin-profile.name}.azurewebsites.net/api/"

  credentials {
    header = {
      "x-functions-key" = data.azurerm_function_app_host_keys.linkedin-profile.default_function_key
    }
  }
  depends_on = [
    module.linkedin-profile
  ]
}
