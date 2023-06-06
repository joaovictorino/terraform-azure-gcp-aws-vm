provider "azurerm" {
  skip_provider_registration = true
  features {
    resource_group {
      prevent_deletion_if_contains_resources = false
    }
  }
}

resource "azurerm_resource_group" "rg-sample" {
  name     = "rg-sample"
  location = "eastus"

  tags = {
    project = "aula"
  }
}

resource "azurerm_virtual_network" "vnet-sample" {
  name                = "vnet-sample"
  address_space       = ["10.0.0.0/16"]
  location            = "eastus"
  resource_group_name = azurerm_resource_group.rg-sample.name

  tags = {
    project = "aula"
  }
}

resource "azurerm_subnet" "sub-sample" {
  name                 = "sub-sample"
  resource_group_name  = azurerm_resource_group.rg-sample.name
  virtual_network_name = azurerm_virtual_network.vnet-sample.name
  address_prefixes     = ["10.0.1.0/24"]
}

resource "azurerm_public_ip" "pip-sample" {
  name                = "pip-sample"
  location            = "eastus"
  resource_group_name = azurerm_resource_group.rg-sample.name
  allocation_method   = "Static"

  tags = {
    project = "aula"
  }
}

resource "azurerm_network_security_group" "nsg-sample" {
  name                = "nsg-sample"
  location            = "eastus"
  resource_group_name = azurerm_resource_group.rg-sample.name

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

  tags = {
    project = "aula"
  }
}

resource "azurerm_network_interface" "nic-sample" {
  name                = "nic-sample"
  location            = "eastus"
  resource_group_name = azurerm_resource_group.rg-sample.name

  ip_configuration {
    name                          = "nic-sample-config"
    subnet_id                     = azurerm_subnet.sub-sample.id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = azurerm_public_ip.pip-sample.id
  }

  tags = {
    project = "aula"
  }
}

resource "azurerm_network_interface_security_group_association" "nic-nsg-sample" {
  network_interface_id      = azurerm_network_interface.nic-sample.id
  network_security_group_id = azurerm_network_security_group.nsg-sample.id
}

resource "azurerm_linux_virtual_machine" "vm-sample" {
  name                  = "vm-sample"
  location              = "eastus"
  resource_group_name   = azurerm_resource_group.rg-sample.name
  network_interface_ids = [azurerm_network_interface.nic-sample.id]
  size                  = "Standard_DS1_v2"

  os_disk {
    name                 = "disk-sample"
    caching              = "ReadWrite"
    storage_account_type = "Premium_LRS"
  }

  source_image_reference {
    publisher = "Canonical"
    offer     = "0001-com-ubuntu-server-jammy"
    sku       = "22_04-lts-gen2"
    version   = "latest"
  }

  computer_name                   = "myvm"
  admin_username                  = "ubuntu"
  disable_password_authentication = true

  admin_ssh_key {
    username   = "ubuntu"
    public_key = file("id_rsa.pub")
  }

  tags = {
    project = "aula"
  }
}

output "public_ip_azure" {
  value = azurerm_public_ip.pip-sample.ip_address
}