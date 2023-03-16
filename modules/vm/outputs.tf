output "private_ip" {
    value = azurerm_linux_virtual_machine.vm.private_ip_address
}

output "public_ip" {
    value = azurerm_linux_virtual_machine.vm.public_ip_address
}

output "id" {
    value = azurerm_linux_virtual_machine.vm.id
}

output "identity" {
  value = azurerm_linux_virtual_machine.vm.identity[0]
}