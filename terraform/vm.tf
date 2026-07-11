resource "azurerm_virtual_network" "vnet" {
  name                = "vnet-k8s"
  location            = azurerm_resource_group.k8s_lab.location
  resource_group_name = azurerm_resource_group.k8s_lab.name
  address_space       = ["10.0.0.0/16"]
}

resource "azurerm_subnet" "subnet" {
  name                 = "subnet-k8s"
  resource_group_name  = azurerm_resource_group.k8s_lab.name
  virtual_network_name = azurerm_virtual_network.vnet.name
  address_prefixes     = ["10.0.1.0/24"]
}
resource "azurerm_network_security_group" "nsg" {
  name                = "nsg-k8s"
  location            = azurerm_resource_group.k8s_lab.location
  resource_group_name = azurerm_resource_group.k8s_lab.name
}

# resource "azurerm_network_security_rule" "ssh" {
#   name                   = "allow-ssh"
#   priority               = 100
#   direction              = "Inbound"
#   access                 = "Allow"
#   protocol               = "Tcp"
#   source_port_range      = "*"
#   destination_port_range = "22"

#   source_address_prefix      = "*"
#   destination_address_prefix = "*"

#   resource_group_name         = azurerm_resource_group.k8s_lab.name
#   network_security_group_name = azurerm_network_security_group.nsg.name
# }
resource "azurerm_network_security_rule" "ssh_master" {

  name = "allow-ssh-master"

  priority = 100

  direction = "Inbound"

  access = "Allow"

  protocol = "Tcp"

  source_port_range = "*"

  destination_port_range = "22"

  source_address_prefix = "*"

  destination_address_prefix = "*"


  resource_group_name = azurerm_resource_group.k8s_lab.name

  network_security_group_name = azurerm_network_security_group.nsg.name
}

resource "azurerm_network_security_rule" "allow_icmp" { //protocole de ping, uniquement pour tester, kube n a pas besoin de ping
  name                        = "allow-icmp"
  priority                    = 110
  direction                   = "Inbound"
  access                      = "Allow"
  protocol                    = "Icmp"
  source_port_range           = "*"
  destination_port_range      = "*"
  source_address_prefix       = "*"
  destination_address_prefix  = "*"
  resource_group_name         = azurerm_resource_group.k8s_lab.name
  network_security_group_name = azurerm_network_security_group.nsg.name
}

resource "azurerm_subnet_network_security_group_association" "assoc" {
  subnet_id                 = azurerm_subnet.subnet.id
  network_security_group_id = azurerm_network_security_group.nsg.id
}

resource "azurerm_public_ip" "master_ip" {
  name                = "pip-master"
  location            = azurerm_resource_group.k8s_lab.location
  resource_group_name = azurerm_resource_group.k8s_lab.name
  allocation_method   = "Dynamic"
}

# resource "azurerm_public_ip" "worker_ip" {
#   name                = "pip-worker"
#   location            = azurerm_resource_group.k8s_lab.location
#   resource_group_name = azurerm_resource_group.k8s_lab.name
#   allocation_method   = "Dynamic"
# }

resource "azurerm_network_interface" "master_nic" {
  name                = "nic-master"
  location            = azurerm_resource_group.k8s_lab.location
  resource_group_name = azurerm_resource_group.k8s_lab.name

  ip_configuration {
    name                          = "internal"
    subnet_id                     = azurerm_subnet.subnet.id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = azurerm_public_ip.master_ip.id
  }

}

# resource "azurerm_network_interface" "worker_nic" {
#   name                = "nic-worker"
#   location            = azurerm_resource_group.k8s_lab.location
#   resource_group_name = azurerm_resource_group.k8s_lab.name

#   ip_configuration {
#     name                          = "internal"
#     subnet_id                     = azurerm_subnet.subnet.id
#     private_ip_address_allocation = "Dynamic"
#     public_ip_address_id          = azurerm_public_ip.worker_ip.id
#   }
# }
resource "azurerm_network_interface" "worker_nic" {

  name                = "nic-worker"
  location            = azurerm_resource_group.k8s_lab.location
  resource_group_name = azurerm_resource_group.k8s_lab.name


  ip_configuration {

    name = "internal"

    subnet_id = azurerm_subnet.subnet.id

    private_ip_address_allocation = "Dynamic"

  }
}

resource "azurerm_linux_virtual_machine" "master" {
  name                = "vm-k8s-master"
  resource_group_name = azurerm_resource_group.k8s_lab.name
  location            = azurerm_resource_group.k8s_lab.location
  size                = "Standard_B2s"

  admin_username        = "azureuser"
  network_interface_ids = [azurerm_network_interface.master_nic.id]

  disable_password_authentication = true

  admin_ssh_key {
    username   = "azureuser"
    public_key = var.ssh_public_key
  }

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  source_image_reference {
    publisher = "Canonical"
    offer     = "0001-com-ubuntu-server-jammy"
    sku       = "22_04-lts"
    version   = "latest"
  }
}

resource "azurerm_linux_virtual_machine" "worker" {
  name                = "vm-k8s-worker"
  resource_group_name = azurerm_resource_group.k8s_lab.name
  location            = azurerm_resource_group.k8s_lab.location
  size                = "Standard_B2s"

  admin_username        = "azureuser"
  network_interface_ids = [azurerm_network_interface.worker_nic.id]

  disable_password_authentication = true

  admin_ssh_key {
    username   = "azureuser"
    public_key = var.ssh_public_key
  }

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  source_image_reference {
    publisher = "Canonical"
    offer     = "0001-com-ubuntu-server-jammy"
    sku       = "22_04-lts"
    version   = "latest"
  }
}

