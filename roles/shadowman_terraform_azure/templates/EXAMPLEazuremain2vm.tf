provider "azurerm" {
  features {}
}

# resource "azurerm_marketplace_agreement" "redhat" {
#   publisher = "redhat"
#   offer     = "rhel-byos"
#   plan      = "rhel-lvm95"
# }

resource "azurerm_resource_group" "tfrg" {
  name     = "shadowman-terraform-rg"
  location = "East US"
}

resource "azurerm_virtual_network" "tfvn" {
  name                = "shadowman-terraform-vnet"
  location            = azurerm_resource_group.tfrg.location
  resource_group_name = azurerm_resource_group.tfrg.name
  address_space       = ["10.0.0.0/16"]
}

resource "azurerm_subnet" "tfsubnet" {
  name                 = "shadowman-terraform-subnet"
  resource_group_name  = azurerm_resource_group.tfrg.name
  virtual_network_name = azurerm_virtual_network.tfvn.name
  address_prefixes     = ["10.0.2.0/24"]
}

resource "azurerm_public_ip" "tfpubip" {
  name                = "shadowman-terraform-public-ip"
  location            = azurerm_resource_group.tfrg.location
  resource_group_name = azurerm_resource_group.tfrg.name
  allocation_method   = "Static"
}

resource "azurerm_network_security_group" "tfnsg" {
  name                = "shadowman-terraform-nsg"
  location            = azurerm_resource_group.tfrg.location
  resource_group_name = azurerm_resource_group.tfrg.name

  security_rule {
    name                       = "HTTP"
    priority                   = 1001
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "80"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }

  security_rule {
    name                       = "HTTPS"
    priority                   = 1002
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "443"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }

  security_rule {
    name                       = "SSH"
    priority                   = 1003
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "22"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }
}

resource "azurerm_network_interface" "tfni" {
  name                = "shadowman-terraform-nic"
  location            = azurerm_resource_group.tfrg.location
  resource_group_name = azurerm_resource_group.tfrg.name

  ip_configuration {
    name                          = "shadowman-terraform-nic-ip-config"
    subnet_id                     = azurerm_subnet.tfsubnet.id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = azurerm_public_ip.tfpubip.id
  }
}

resource "azurerm_network_interface_security_group_association" "tfnga" {
  network_interface_id      = azurerm_network_interface.tfni.id
  network_security_group_id = azurerm_network_security_group.tfnsg.id
}

resource "azurerm_linux_virtual_machine" "app-server" {
  name                            = "appserver1.shadowman.dev"
  location                        = azurerm_resource_group.tfrg.location
  resource_group_name             = azurerm_resource_group.tfrg.name
  network_interface_ids           = [azurerm_network_interface.tfni.id]
  size                            = "Standard_B2s"
  admin_username                  = "{{ azureuser }}"
  admin_password                  = "{{ azurepassword }}"
  disable_password_authentication = false

  source_image_reference {
    publisher = "RedHat"
    offer     = "rhel-byos"
    sku       = "rhel-lvm95"
    version   = "latest"
  }

  plan {
    name      = "rhel-lvm95"
    product   = "rhel-byos"
    publisher = "redhat"
  }

  os_disk {
    name                 = "shadowman-terraform-os-disk"
    storage_account_type = "Standard_LRS"
    caching              = "ReadWrite"
  }

  tags = {
    environment      = "dev"
    owner            = "shadowman"
    operating_system = "RHEL"
  }
}

output "app-server" {
  value = azurerm_linux_virtual_machine.app-server.name
}


resource "azurerm_public_ip" "tfpubip2" {
  name                = "shadowman-terraform-public-ip2"
  location            = azurerm_resource_group.tfrg.location
  resource_group_name = azurerm_resource_group.tfrg.name
  allocation_method   = "Static"
}

resource "azurerm_network_interface" "tfni2" {
  name                = "shadowman-terraform-nic2"
  location            = azurerm_resource_group.tfrg.location
  resource_group_name = azurerm_resource_group.tfrg.name

  ip_configuration {
    name                          = "shadowman-terraform-nic-ip-config2"
    subnet_id                     = azurerm_subnet.tfsubnet.id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = azurerm_public_ip.tfpubip2.id
  }
}

resource "azurerm_network_interface_security_group_association" "tfnga2" {
  network_interface_id      = azurerm_network_interface.tfni2.id
  network_security_group_id = azurerm_network_security_group.tfnsg.id
}

resource "azurerm_linux_virtual_machine" "app-server2" {
  name                            = "appserver2.shadowman.dev"
  location                        = azurerm_resource_group.tfrg.location
  resource_group_name             = azurerm_resource_group.tfrg.name
  network_interface_ids           = [azurerm_network_interface.tfni2.id]
  size                            = "Standard_B1s"
  admin_username                  = "{{ azureuser }}"
  admin_password                  = "{{ azurepassword }}"
  disable_password_authentication = false

  source_image_reference {
    publisher = "RedHat"
    offer     = "rhel-byos"
    sku       = "rhel-lvm95"
    version   = "latest"
  }

  plan {
    name      = "rhel-lvm95"
    product   = "rhel-byos"
    publisher = "redhat"
  }

  os_disk {
    name                 = "shadowman-terraform-os-disk2"
    storage_account_type = "Standard_LRS"
    caching              = "ReadWrite"
  }

  tags = {
    environment      = "dev"
    owner            = "shadowman"
    operating_system = "RHEL"
  }
}

output "app-server2" {
  value = azurerm_linux_virtual_machine.app-server2.name
}
