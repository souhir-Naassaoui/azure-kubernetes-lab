# resource : indique que Terraform doit créer une ressource.
# azurerm_resource_group : type de ressource Azure.
# k8s_lab : nom logique utilisé dans Terraform.
resource "azurerm_resource_group" "k8s_lab" {
  name     = "rg-k8s-lab"     //nom réel qui apparaîtra dans Azure.
  location = "Canada Central" //région où sera créé le Resource Group
}
