variable "resource_group_name" {
  description = "Name of the landing zone resource group"
  type        = string
  default     = "landing-zone-rg"
}

variable "location" {
  description = "Azure region for deployment"
  type        = string
  default     = "eastus"
}

variable "environment" {
  description = "Deployment environment (dev, staging, prod)"
  type        = string
  default     = "dev"
}

variable "aks_cluster_name" {
  description = "Name of the AKS cluster"
  type        = string
  default     = "landing-zone-aks"
}

variable "key_vault_name" {
  description = "Name of the Azure Key Vault"
  type        = string
  default     = "landingzone-kv"
}

variable "tenant_id" {
  description = "Azure AD tenant ID"
  type        = string
}

variable "admin_group_object_ids" {
  description = "List of Entra ID group object IDs granted AKS admin access"
  type        = list(string)
  default     = []
}
