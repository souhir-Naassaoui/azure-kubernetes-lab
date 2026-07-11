# resource "azurerm_virtual_network" "vnet" {
#   name                = "vnet-k8s"
#   location            = azurerm_resource_group.k8s_lab.location
#   resource_group_name = azurerm_resource_group.k8s_lab.name
#   address_space       = ["10.0.0.0/16"]
# }


# /************ SUBNET GATEWAY *************/
# resource "azurerm_subnet" "gateway_subnet" {
#   name                 = "GatewaySubnet"
#   resource_group_name  = azurerm_resource_group.k8s_lab.name
#   virtual_network_name = azurerm_virtual_network.vnet.name
#   address_prefixes     = ["10.0.255.0/27"]
# }

# resource "azurerm_public_ip" "vpn_ip" {
#   name                = "vpn-gateway-ip"
#   location            = azurerm_resource_group.k8s_lab.location
#   resource_group_name = azurerm_resource_group.k8s_lab.name
#   allocation_method   = "Static"
# }

# resource "azurerm_virtual_network_gateway" "vpn" {
#   name                = "vnet-vpn-gateway"
#   location            = azurerm_resource_group.k8s_lab.location
#   resource_group_name = azurerm_resource_group.k8s_lab.name

#   type     = "Vpn"
#   vpn_type = "RouteBased"

#   active_active = false
#   bgp_enabled   = false
#   sku           = "VpnGw1"

#   ip_configuration {
#     name                          = "vpnConfig"
#     public_ip_address_id         = azurerm_public_ip.vpn_ip.id
#     private_ip_address_allocation = "Dynamic"
#     subnet_id                    = azurerm_subnet.gateway_subnet.id
#   }
# }


# /************ SUBNET VM *************/
# resource "azurerm_subnet" "vm_subnet" {
#   name                 = "WebSubnet"
#   resource_group_name  = azurerm_resource_group.k8s_lab.name
#   virtual_network_name = azurerm_virtual_network.vnet.name
#   address_prefixes     = ["10.0.1.0/24"]
# }

# resource "azurerm_network_security_group" "nsg" {
#   name                = "nsg-k8s"
#   location            = azurerm_resource_group.k8s_lab.location
#   resource_group_name = azurerm_resource_group.k8s_lab.name
# }

# resource "azurerm_subnet_network_security_group_association" "assoc" {
#   subnet_id                 = azurerm_subnet.vm_subnet.id
#   network_security_group_id = azurerm_network_security_group.nsg.id
# } 

# resource "azurerm_network_security_rule" "ssh" { // SSH autorisé UNIQUEMENT via VPN
#   name                        = "allow-ssh-vpn"
#   priority                    = 100
#   direction                   = "Inbound"
#   access                      = "Allow"
#   protocol                    = "Tcp"
#   source_port_range           = "*"
#   destination_port_range      = "22"
#   source_address_prefix       = "10.0.0.0/16"
#   destination_address_prefix  = "*"
#   resource_group_name         = azurerm_resource_group.k8s_lab.name
#   network_security_group_name = azurerm_network_security_group.nsg.name
# }


# /************ NIC *************/ 
# resource "azurerm_network_interface" "master_nic" {
#   name                = "nic-master"
#   location            = azurerm_resource_group.k8s_lab.location
#   resource_group_name = azurerm_resource_group.k8s_lab.name

#   ip_configuration {
#     name                          = "internal"
#     subnet_id                     = azurerm_subnet.vm_subnet.id
#     private_ip_address_allocation = "Dynamic"
#   }
# }

# resource "azurerm_network_interface" "worker_nic" {
#   name                = "nic-worker"
#   location            = azurerm_resource_group.k8s_lab.location
#   resource_group_name = azurerm_resource_group.k8s_lab.name

#   ip_configuration {
#     name                          = "internal"
#     subnet_id                     = azurerm_subnet.vm_subnet.id
#     private_ip_address_allocation = "Dynamic"
#   }
# }

