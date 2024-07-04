# Create a resource group 1
resource "azurerm_resource_group" "DevSecOps33" {
  name     = "DevSecOps33"
  location = "eastus"
  tags = {
    Environment = "Development"
  }
}

# Create a resource group 2
resource "azurerm_resource_group" "superstar" {
  name     = "superstar"
  location = "eastus"
  tags = {
    Environment = "superstar"
  }
}

# Create a resource group 3
resource "azurerm_resource_group" "megastar" {
  name     = "megastar"
  location = "eastus"
  tags = {
    Environment = "megastar"
  }
}

# Create a resource group 4
resource "azurerm_resource_group" "burningstar" {
  name     = "burningstar"
  location = "eastus"
  tags = {
    Environment = "burningstar"
  }
}

# Create a resource group 5
resource "azurerm_resource_group" "rebelstarstar" {
  name     = "rebelstar"
  location = "eastus"
  tags = {
    Environment = "rebelstar"
  }
}

