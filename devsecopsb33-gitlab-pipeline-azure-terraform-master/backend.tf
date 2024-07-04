terraform {
  backend "azurerm" {
    resource_group_name  = "DevSecOps33Tfstate"
    storage_account_name = "devopsb33tfstate"
    container_name       = "tfstate"
    key                  = "devsecopsb33.tfstate"
  }
}
