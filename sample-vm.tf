module "catalog_vm" {
  source = "./modules/vm"
  resource_group = azurerm_resource_group.rg
  vm_name = "catalog-vm"
  sku = "Standard_B1s"
  subnet_id = azurerm_subnet.vm_subnet.id

  admin_username = "azureuser"
  public_key = tls_private_key.admin_ssh.public_key_openssh

  source_image = {
    publisher = "Canonical"
    offer     = "0001-com-ubuntu-server-focal"
    sku       = "20_04-lts-gen2"
    version   = "latest"
  }

  enable_shutdown = true
  shutdown_time = "2300"
  shutdown_timezone = "E. South America Standard Time"
  enable_public_ip = true
  private_ip_allocation = "Dynamic"
  public_ip_allocation = "Dynamic"
  log_analytics_workspace = azurerm_log_analytics_workspace.log_analytics
  boot_diagnostics_sa = azurerm_storage_account.catalog_boot_diagnostics.primary_blob_endpoint
}

# Create (and display) an SSH key
resource "tls_private_key" "admin_ssh" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

resource "local_file" "admin_private_key" {
  filename = "admin_private_key.pem"
  content = tls_private_key.admin_ssh.private_key_pem
  file_permission = "0600"
}

resource "azurerm_storage_account" "catalog_boot_diagnostics" {
  name = "samplevmdiag"
  resource_group_name      = azurerm_resource_group.rg.name
  location                 = azurerm_resource_group.rg.location
  account_tier             = "Standard"
  account_replication_type = "LRS"
}
