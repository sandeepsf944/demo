# Create a resource group 1
#resource "azurerm_resource_group" "DevSecOps33Tfstate" {
#  name     = "DevSecOps33Tfstate"
#  location = "eastus"
#  tags = {
#    Environment = "Development"
#  }
#}
#
#resource "azurerm_storage_account" "devopsb33tfstate" {
#  name                     = "devopsb33tfstate"
#  resource_group_name      = azurerm_resource_group.DevSecOps33Tfstate.name
#  location                 = azurerm_resource_group.DevSecOps33Tfstate.location
#  account_tier             = "Standard"
#  account_replication_type = "LRS"
#
#  tags = {
#    Environment = "Development"
#  }
#}