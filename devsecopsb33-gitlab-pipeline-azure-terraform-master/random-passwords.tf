#Generating random password for Linux Machines
resource "random_password" "linux-machine-1" {
  length  = 16
  special = true
  #depends_on = ["azurerm_key_vault_access_pol"]
}

resource "random_password" "linux-machine-2" {
  length  = 16
  special = true
  #depends_on = ["azurerm_key_vault_access_pol"]
}

resource "random_password" "linux-machine-3" {
  length  = 16
  special = true
  #depends_on = ["azurerm_key_vault_access_pol"]
}