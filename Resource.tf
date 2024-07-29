
#     computer_name= "${var.prefix}machine"
#     username     = "${var.prefix}admin"
#     password     = "${var.prefix}@1234"
#     az vm list-ip-addresses -o table   # to obtain Ip addresses
# Resource: Resource Group
resource "azurerm_resource_group" "Test1" {
  name     = "RG-${var.prefix}"
  location = var.location
}

resource "azurerm_network_interface" "Test1" {
  name                = "${var.prefix}-nic"
  location            = azurerm_resource_group.Test1.location
  resource_group_name = azurerm_resource_group.Test1.name

  ip_configuration {
    name                          = "${var.prefix}-conf"
    subnet_id                     = azurerm_subnet.Test1.id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = azurerm_public_ip.Test1.id
   
  }
}
# Resource: Azure Network Security Group
resource "azurerm_network_security_group" "Test1" {
    resource_group_name = azurerm_resource_group.Test1.name
  name                = "${var.prefix}-NSG"
  location            = var.location

  security_rule {
    name                       = "Test1Rule"
    priority                   = 100
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "*"
    source_port_range          = "*"
    destination_port_range     = "*"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }
}
resource "azurerm_virtual_network" "Test1" {
  name                = "VNET-${var.prefix}"
  address_space       = ["10.0.0.0/16"]
  location            = azurerm_resource_group.Test1.location
  resource_group_name = azurerm_resource_group.Test1.name
}

resource "azurerm_subnet" "Test1" {
  name                 = "subnet-${var.prefix}"
  resource_group_name  = azurerm_resource_group.Test1.name
  virtual_network_name = azurerm_virtual_network.Test1.name
  address_prefixes     = ["10.0.2.0/24"]
}
# Resource: Azure Public IP Address
resource "azurerm_public_ip" "Test1" {
  name                = "PublicIp-${var.prefix}"
  resource_group_name = azurerm_resource_group.Test1.name
  location            = azurerm_resource_group.Test1.location
  allocation_method   = "Dynamic"
}

# Resource: Azure Virtual Machine
resource "azurerm_virtual_machine" "Test1" {
  name                  = "${var.prefix}-VM"
  location              = var.location
  resource_group_name   = azurerm_resource_group.Test1.name
  vm_size               = var.vm_size
  storage_image_reference {
    publisher = "canonical"
    offer     = "0001-com-ubuntu-server-focal"
    sku       = "20_04-lts-gen2"
    version   = "latest"
  }

  storage_os_disk {
    name              = "osdisk"
    caching           = "ReadWrite"
    create_option     = "FromImage"
    managed_disk_type = "Standard_LRS"
  }

  os_profile {
    computer_name  = "${var.prefix}machine"
    admin_username = "${var.prefix}admin"
    admin_password = "${var.prefix}@1234567"
  }

  os_profile_linux_config {
    disable_password_authentication = false
  }

  network_interface_ids = [
    azurerm_network_interface.Test1.id,
  ]

 

  tags = {
    environment = "production"
  }
}

# Output
output "adminUsername" {
  value = "${var.prefix}admin"
  
}
output "adminpassword" {
  value = "${var.prefix}@1234567"
}
