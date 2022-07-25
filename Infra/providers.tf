# define the terraform version
terraform {

  required_version = ">=0.12"

# define the terrafrom resource manager provider API source
  required_providers {
    azurerm = {
      source = "hashicorp/azurerm"
      version = "~>3.14.0"
    }
  }
}

provider "azurerm" {
  features {}
}