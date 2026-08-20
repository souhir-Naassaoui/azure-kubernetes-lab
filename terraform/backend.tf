terraform {
  backend "azurerm" {
    resource_group_name  = "rg-tfstate"
    storage_account_name = "tfstatek8slab2026"
    container_name       = "tfstate"
    key                  = "k8s.tfstate"
  }
}