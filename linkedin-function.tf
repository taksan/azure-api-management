module "linkedin-profile" {
  source = "./modules/functionapp"

  function_name                 = "linkedinprofiletak"
  function_storage_account_name = "linkedinprofilesatak"
  resourcegroup                 = azurerm_resource_group.rg
  runtime                       = "node"
  auth_settings                 = {
    tenant_id     = data.azurerm_client_config.current.tenant_id
    client_id     = azuread_application.linkedin_app.application_id
    client_secret = azuread_application_password.linkedin_app.value
  }
}
