data "azurerm_client_config" "current" {}

resource "azurerm_key_vault" "devsecopsb33kv" {
  name                = "${azurerm_resource_group.DevSecOps33.name}-kv-new"
  resource_group_name = azurerm_resource_group.DevSecOps33.name
  location            = azurerm_resource_group.DevSecOps33.location
  tenant_id           = data.azurerm_client_config.current.tenant_id
  sku_name            = "standard"
}

resource "azurerm_key_vault_secret" "linux-machine-1" {
  name         = "linux-machine-1"
  value        = random_password.linux-machine-1.result
  key_vault_id = azurerm_key_vault.devsecopsb33kv.id
  depends_on   = [azurerm_key_vault_access_policy.devsecopsb33-sp-access]
}

resource "azurerm_key_vault_secret" "linux-machine-2" {
  name         = "linux-machine-2"
  value        = random_password.linux-machine-2.result
  key_vault_id = azurerm_key_vault.devsecopsb33kv.id
  depends_on   = [azurerm_key_vault_access_policy.devsecopsb33-sp-access]
}

resource "azurerm_key_vault_secret" "linux-machine-3" {
  name         = "linux-machine-3"
  value        = random_password.linux-machine-3.result
  key_vault_id = azurerm_key_vault.devsecopsb33kv.id
  depends_on   = [azurerm_key_vault_access_policy.devsecopsb33-sp-access]
}