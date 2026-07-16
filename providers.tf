terraform {
  required_version = ">= 1.9, < 2.0"
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 4.0"
    }
  }
}

provider "azurerm" {
  features {
    resource_group {
      prevent_deletion_if_contains_resources = false
    }
  }
}


# this next block is the marketplace agreement, 
# which must be accepted ONCE per Azure subscription or the `terraform apply` will fail at VM creation with a legal terms error 
# while `az vm image terms accept` is an option, its a manual step outside of Terraform 
# the idea is to make this entire project as reproducible as possible, so we bake the marketplace agreement in the script

resource "azurerm_marketplace_agreement" "kali" {
  publisher = "kali-linux"
  offer     = "kali"
  plan      = "kali-2026-2"
}