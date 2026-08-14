resource "azuread_group" "platform_admins" {
  display_name     = "landing-zone-platform-admins"
  security_enabled = true
}

resource "azurerm_role_assignment" "aks_admin_rbac" {
  scope                = azurerm_kubernetes_cluster.aks.id
  role_definition_name = "Azure Kubernetes Service RBAC Cluster Admin"
  principal_id         = azuread_group.platform_admins.object_id
}

resource "azurerm_role_assignment" "keyvault_reader" {
  scope                = azurerm_key_vault.landing_zone_kv.id
  role_definition_name = "Key Vault Reader"
  principal_id         = azuread_group.platform_admins.object_id
}
