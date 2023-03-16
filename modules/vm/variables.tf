variable "resource_group" {
}

variable "vm_name" {
  type = string
}

variable "admin_username" {
  type = string
}

variable "public_key" {
  type = string
}

variable "subnet_id" {
  type = string
}

variable "storage_account_type" {
  type = string
  default = "Standard_LRS"
}

variable "disk_size_gb" {
  type = string
  default = "30"
}

variable "disk_caching" {
  default = "ReadWrite"
}

variable "sku" {
  default = "Standard_B1s"
}

variable "source_image" {
  default = {
    publisher = ""
    offer     = ""
    sku       = ""
    version   = ""
  }
}

variable "default_tags" {
  default = {}
}

variable "enable_shutdown" {
  default = true
  description = "(optional) describe your variable"
}

variable "shutdown_time" {
  type = string
  default = "2300"
}

variable "shutdown_timezone" {
  type = string
  default = "E. South America Standard Time"
}

variable "enable_public_ip" {
  default = false
}

variable "public_ip_allocation" {
  type = string
  default = "Dynamic"
}

variable "private_ip_allocation" {
  type = string
  default = "Dynamic"
}

variable "security_rules" {
  default = [
    {
      name                       = "SSH"
      priority                   = 300
      direction                  = "Inbound"
      access                     = "Allow"
      protocol                   = "Tcp"
      source_port_range          = "*"
      destination_port_range     = "22"
      source_address_prefix      = "*"
      destination_address_prefix = "*"
    }
  ]
}

variable "log_analytics_workspace" {
}

variable "boot_diagnostics_sa" {
  default = null
}
