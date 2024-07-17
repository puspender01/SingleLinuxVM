
#     computer_name= "${var.prefix}machine"
#     username     = "${var.prefix}admin"
#     password     = "${var.prefix}@1234"
#     az vm list-ip-addresses -o table   # to obtain Ip addresses

resource "azurerm_resource_group" "Test1" {
  name     = "RG-${var.prefix}"
  location = var.location
}

resource "azurerm_public_ip" "Test1" {
  name                = "PublicIp-${var.prefix}"
  resource_group_name = azurerm_resource_group.Test1.name
  location            = azurerm_resource_group.Test1.location
  allocation_method   = "Dynamic"
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

# Create Network Security Group and rule
resource "azurerm_network_security_group" "Test1" {
  name                = "myNetworkSecurityGroup"
  location            = azurerm_resource_group.Test1.location
  resource_group_name = azurerm_resource_group.Test1.name

  security_rule {
    name                       = "SSH"
    priority                   = 1001
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "22"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }
}

# Connect the security group to the network interface
resource "azurerm_network_interface_security_group_association" "Test1" {
  network_interface_id      = azurerm_network_interface.Test1.id
  network_security_group_id = azurerm_network_security_group.Test1.id
}

resource "azurerm_virtual_machine" "Test1" {
  name                  = "${var.prefix}-vm"
  location              = azurerm_resource_group.Test1.location
  resource_group_name   = azurerm_resource_group.Test1.name
  network_interface_ids = [azurerm_network_interface.Test1.id]
  vm_size               = var.vmimage

  # Uncomment this line to delete the OS disk automatically when deleting the VM
  # delete_os_disk_on_termination = true

  # Uncomment this line to delete the data disks automatically when deleting the VM
  # delete_data_disks_on_termination = true

  storage_image_reference {
    publisher = "Canonical"
    offer     = "0001-com-ubuntu-server-jammy"
    sku       = "22_04-lts"
    version   = "latest"
  }
  storage_os_disk {
    name              = "myosdisk1"
    caching           = "ReadWrite"
    create_option     = "FromImage"
    managed_disk_type = "Standard_LRS"
  }
  os_profile {
    computer_name  = "${var.prefix}machine"
    admin_username = "${var.prefix}admin"
    admin_password = "${var.prefix}@1234"
  }
  os_profile_linux_config {
    disable_password_authentication = false
  }
  tags = {
    environment = "staging"
  }
}
