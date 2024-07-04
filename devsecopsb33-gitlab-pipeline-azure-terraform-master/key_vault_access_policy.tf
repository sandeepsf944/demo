resource "azurerm_key_vault_access_policy" "devsecopsb33-sp-access" {
  key_vault_id = azurerm_key_vault.devsecopsb33kv.id
  tenant_id    = data.azurerm_client_config.current.tenant_id
  object_id    = data.azurerm_client_config.current.object_id

  secret_permissions = [
    "Get", "List", "Recover", "Delete", "Purge", "Restore", "Set"
  ]
}