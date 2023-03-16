output "resource_group_name" {
  value = azurerm_resource_group.rg.name
}

output "api-management-api-url" {
  value = azurerm_api_management.api4fun.gateway_url
}

output "api-managament-starter-product" {
  value = data.azurerm_api_management_product.starter.display_name
}

output "user-ids" {
  value = {
    for k, v in random_pet.user : k => v.id
  }
}

output "vm-ip" {
  value = module.catalog_vm.public_ip
}

output "apim-private-ip" {
  value = azurerm_api_management.api4fun.private_ip_addresses
}

output "api-url" {
  value = azurerm_api_management.api4fun.gateway_url
}
