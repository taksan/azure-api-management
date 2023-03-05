output "storage_account_name" {
    value = azurerm_storage_account.function_sa.name
}

output "storage_container_name" {
    value = azurerm_storage_container.function_container.name
}

output "name" {
    value = azurerm_linux_function_app.a-function.name
}
