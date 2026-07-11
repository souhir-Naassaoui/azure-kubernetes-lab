terraform {
  required_version = ">= 1.6" // indique la version minimale de Terraform

  required_providers { //télécharge le provider Azure
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~>4.0"
    }
  }
}

provider "azurerm" { // configure l'accès à Azure
  features {}        // Grâce à az login, il n'y a aucun mot de passe à écrire.
}

