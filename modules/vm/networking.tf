# Create public IPs
resource "azurerm_public_ip" "vm_public_ip" {
  count = var.enable_public_ip == true? 1: 0

  name                = "${var.vm_name}-public-ip"
  location            = var.resource_group.location
  resource_group_name = var.resource_group.name
  allocation_method   = var.public_ip_allocation

  tags = merge(var.default_tags, local.tags)
}

# Create Network Security Group and rule
resource "azurerm_network_security_group" "vm_nsg" {
  name                = "${var.vm_name}-nsg"
  location            = var.resource_group.location
  resource_group_name = var.resource_group.name

  dynamic "security_rule" {
    for_each = var.security_rules
    content {
        name                       = security_rule.value.name
        priority                   = security_rule.value.priority
        direction                  = security_rule.value.direction
        access                     = security_rule.value.access
        protocol                   = security_rule.value.protocol
        source_port_range          = security_rule.value.source_port_range
        destination_port_range     = security_rule.value.destination_port_range
        source_address_prefix      = security_rule.value.source_address_prefix
        destination_address_prefix = security_rule.value.destination_address_prefix
    }
  }

  tags = merge(var.default_tags, local.tags)
}

# Create network interface
resource "azurerm_network_interface" "vm_nic" {
  name                = "${var.vm_name}-nic"
  location            = var.resource_group.location
  resource_group_name = var.resource_group.name

  dynamic "ip_configuration" {
    for_each = var.enable_public_ip == true? [azurerm_public_ip.vm_public_ip[0].id]:[null]

    content {
        name                          = "${var.vm_name}-ip-config"
        subnet_id                     = var.subnet_id
        private_ip_address_allocation = var.private_ip_allocation
        public_ip_address_id          = ip_configuration.value
    }
  }

  tags = merge(var.default_tags, local.tags)
}

# Connect the security group to the network interface
resource "azurerm_network_interface_security_group_association" "vm_nic_nsg" {
  network_interface_id      = azurerm_network_interface.vm_nic.id
  network_security_group_id = azurerm_network_security_group.vm_nsg.id
}