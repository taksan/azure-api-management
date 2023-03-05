module "linkedin-profile" {
  source = "./modules/functionapp"

  function_name = "linkedinprofiletak"
  function_storage_account_name = "linkedinprofilesatak"
  resourcegroup = azurerm_resource_group.rg
  runtime = "node"
}

