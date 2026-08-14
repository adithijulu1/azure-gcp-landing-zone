resource "azurerm_key_vault" "landing_zone_kv" {
  name                       = var.key_vault_name
  location                   = azurerm_resource_group.landing_zone.location
  resource_group_name        = azurerm_resource_group.landing_zone.name
  tenant_id                  = var.tenant_id
  sku_name                   = "standard"
  purge_protection_enabled   = true
  soft_delete_retention_days = 30

  network_acls {
    default_action = "Deny"
    bypass         = "AzureServices"
  }
}

resource "azurerm_key_vault_access_policy" "aks_access" {
  key_vault_id = azurerm_key_vault.landing_zone_kv.id
  tenant_id    = var.tenant_id
  object_id    = azurerm_kubernetes_cluster.aks.identity[0].principal_id

  secret_permissions = ["Get", "List"]
}
