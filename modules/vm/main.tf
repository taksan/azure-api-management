locals {
  tags = {}
}

# Create virtual machine
resource "azurerm_linux_virtual_machine" "vm" {
  name                  = var.vm_name
  location              = var.resource_group.location
  resource_group_name   = var.resource_group.name
  network_interface_ids = [azurerm_network_interface.vm_nic.id]
  size                  = var.sku

  os_disk {
    name                 = "${var.vm_name}-disk"
    caching              = var.disk_caching
    storage_account_type = var.storage_account_type
    disk_size_gb         = var.disk_size_gb
  }

  source_image_reference {
    publisher = var.source_image.publisher
    offer     = var.source_image.offer
    sku       = var.source_image.sku
    version   = var.source_image.version
  }

  computer_name                   = var.vm_name
  admin_username                  = var.admin_username
  disable_password_authentication = true

  admin_ssh_key {
    username   = var.admin_username
    public_key = var.public_key
  }

  boot_diagnostics {
    storage_account_uri = var.boot_diagnostics_sa
  }
  identity {
    type = "SystemAssigned"
  }

  tags = merge(var.default_tags, local.tags)
}

resource "azurerm_dev_test_global_vm_shutdown_schedule" "vm_shutdown_schedule" {
  count = var.enable_shutdown ? 1:0
  virtual_machine_id = azurerm_linux_virtual_machine.vm.id
  location           = var.resource_group.location
  enabled            = true

  daily_recurrence_time = var.shutdown_time
  timezone              = var.shutdown_timezone

  notification_settings {
    enabled         = false
  }
}
