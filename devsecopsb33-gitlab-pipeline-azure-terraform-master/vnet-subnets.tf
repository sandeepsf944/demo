# Create a virtual network
resource "azurerm_virtual_network" "vnet1" {
  name                = "${azurerm_resource_group.DevSecOps33.name}-vnet1"
  resource_group_name = azurerm_resource_group.DevSecOps33.name
  location            = azurerm_resource_group.DevSecOps33.location
  address_space       = ["10.33.0.0/16"]
  tags = {
    Environment = "Development"
  }
}

resource "azurerm_subnet" "subnets" {
  count                = 3 # 0 1 2
  name                 = "${azurerm_resource_group.DevSecOps33.name}-Subnet-${count.index}"
  resource_group_name  = azurerm_resource_group.DevSecOps33.name
  virtual_network_name = azurerm_virtual_network.vnet1.name
  address_prefixes     = [element(var.subnet_cidr, count.index)]
}
