# Copyright IBM Corp. 2026

# Ensure 'Cross Tenant Replication' is Not Enabled

policy {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = ">= 4.0.0, < 6.0.0"
    }
  }
}

input "cross-tenant-replication-enforcement-level" {
  type    = string
  default = "advisory"
}

resource_policy "azurerm_storage_account" "cross_tenant_replication_disabled" {
  locals {
    cross_tenant_replication_enabled_raw = core::try(attrs.cross_tenant_replication_enabled, null)
    cross_tenant_replication_enabled     = local.cross_tenant_replication_enabled_raw == null ? false : local.cross_tenant_replication_enabled_raw
  }

  enforcement_level = input.cross-tenant-replication-enforcement-level
  enforce {
    condition     = !local.cross_tenant_replication_enabled
    error_message = "Azure Storage Accounts must disable cross-tenant replication. Set cross_tenant_replication_enabled to false."
  }
}
