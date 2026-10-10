policy {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "= 5.8.0"
    }
  }
}

resource_policy "azurerm_storage_account" "container_soft_delete_enabled" {
  locals {
    kind_raw   = core::try(attrs.account_kind, null)
    kind       = local.kind_raw == null ? "StorageV2" : local.kind_raw
    blob_props = core::try([for block in attrs.blob_properties : block], [])
    policies   = core::try([for policy in attrs.blob_properties[0].container_delete_retention_policy : policy], [])
    days_raw   = core::try(attrs.blob_properties[0].container_delete_retention_policy[0].days, null)
    days       = local.days_raw == null ? 7 : local.days_raw
  }

  filter = local.kind != "FileStorage"

  enforcement_level = "advisory"

  enforce {
    condition     = core::length(local.blob_props) > 0 && core::length(local.policies) > 0 && local.days >= 7 && local.days <= 365
    error_message = "Blob-capable storage accounts must enable container soft delete with a retention period of at least 7 days and no more than 365 days; AzureRM defaults omitted retention days to 7."
  }
}
