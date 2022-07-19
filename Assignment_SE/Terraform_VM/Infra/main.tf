# This random_pet will create a unique name for the resources
resource "random_pet" "assignment" {
  prefix = var.resource_group_name_prefix
}

# create a resource group
resource "azurerm_resource_group" "rg" {
  name     = random_pet.rg-name.id
  location = var.resource_group_name_loation
}

# create a virtual network
resource "azurerm_virtual_network" "myterranetwork" {
  name                = "testnet"
  address             = ["10.0.0.0/16"]
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
}

# create a subnet
resource "azurerm_subnet" "myterrasubnet" {
  name                 = "testsubnet"
  virtual_network_name = azurerm_virtual_network.myterraformnetwork.name
  resource_group_name  = azurerm_resource_group.rg.name
   address_prefixes    = ["10.0.1.0/24"]
}

# create a public IP
resource "azurerm_public_ip" "myterrapublicip" {
  name                 = "publicIP"
  location             = azurerm_resource_group.rg.location
  resource_group_name  = azurerm_resource_group.rg.name
  allocation_method    = "Dynamic"
}

#create a network security group and rules
resource "azurerm_network_security_group" "myterrasg" {
  name                = "myNetworkSecurityGroup"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  tags                = "demo_version"

  security_rule {
    name                       = "SSH"
    priority                   = 100
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "22"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }
  security_rule {
    name                       = "expose"
    priority                   = 101
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "36666"
    source_address_prefix      = "*"
    destination_address_prefix = [azurerm_public_ip.myterrapublicip.prefix]
  } 
}

# create a network interface
resource "azurerm_network_interface" "myterranic" {
  name                = "mynic"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name

  ip_configuration {
    name                          = "myipconfiguration"
    subnet_id                     = azurerm_subnet.myterrasubnet.id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = azurerm_public_ip.myterrapublicip.id
  }
}

# attach the security group to the nic
resource "azurerm_network_interface_security_group_association" "assignment" {
  network_interface_id = azurerm_network_interface.myterranic.id
  network_security_group_id = azurerm_network_security_group.myterrasg.id
}

# create storage account 
///for now ignoring on behalf of task
//resource "azurerm_storage_account" "mystorageaccount" {
//  name                     = "teststorage"
//  location                 = azurerm_resource_group.rg.location
//  resource_group_name      = azurerm_resource_group.rg.name
//  account_tier             = "Standard"
//  account_replication_type = "LRS"
//}

# Create (and display) an SSH key
resource "tls_private_key" "test_ssh" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

# create Virtual machine
resource "azurerm_linux_virtual_machine" "myterravm" {
  name                  = "my_ubuntu"
  location              = azurerm_resource_group.rg.location
  resource_group_name   = azurerm_resource_group.rg.location
  network_interface_ids = [azurerm_network_interface.myterranic.id]
  size                  = "Standard_DS1_v2"
}

  os_disk {
      name                 = "Myos"
      caching              = "ReadWrite"
      storage_account_type = "Standard_LRS"
  }
    source_image_reference {
    publisher = "Canonical"
    offer     = "UbuntuServer"
    sku       = "18.04-LTS"
    version   = "latest"
  }
  computer_name                   = "myvm"
  admin_username                  = "siemenstester"
  disable_password_authentication = true

    admin_ssh_key {
    username   = "siemenstester"
    public_key = tls_private_key.test_ssh.public_key_openssh
  }

    boot_diagnostics {
    storage_account_uri = azurerm_storage_account.mystorageaccount.primary_blob_endpoint
  }

  custom_data = filebase64("scripts/install.sh")
