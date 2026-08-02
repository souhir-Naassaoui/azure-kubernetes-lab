resource "local_file" "ansible_inventory" {


  filename = "../ansible/inventory.ini"


  content = <<EOF

[master]

${azurerm_public_ip.master_ip.ip_address}



[worker]

${azurerm_network_interface.worker_nic.private_ip_address}



[all:vars]

ansible_user=azureuser

ansible_ssh_private_key_file=/home/runner/.ssh/id_rsa

ansible_ssh_common_args='-o ProxyJump=azureuser@${azurerm_public_ip.master_ip.ip_address}'


EOF

} 