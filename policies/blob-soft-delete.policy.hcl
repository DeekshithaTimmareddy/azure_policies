# Copyright IBM Corp. 2026

# Ensure That Soft Delete for Blobs on Azure Blob Storage Storage Accounts is Enabled

policy {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = ">= 4.0.0, < 6.0.0"
    }
  }
}

resource_policy "azurerm_storage_account" "azure_blob_soft_delete" {
  locals {
    account_kind     = core::try(attrs.account_kind, "StorageV2")
    unsupported_kind = core::contains(["Storage", "FileStorage"], local.account_kind)

    blob_properties_raw         = core::try(attrs.blob_properties[0], core::try(attrs.blob_properties, null))
    has_blob_properties         = local.blob_properties_raw != null
    delete_retention_policy_raw = core::try(local.blob_properties_raw.delete_retention_policy, null)
    has_delete_retention_policy     = local.delete_retention_policy_raw != null
    retention_days_raw              = core::try(local.delete_retention_policy_raw.days, null)
    retention_days                  = local.retention_days_raw == null ? 7 : local.retention_days_raw
    has_valid_blob_retention_period = local.retention_days >= 7 && local.retention_days <= 365
  }

  enforcement_level = "advisory"
  enforce {
    condition     = local.unsupported_kind || (local.has_blob_properties && local.has_delete_retention_policy && local.has_valid_blob_retention_period)
    error_message = "Azure Storage Accounts must enable blob soft delete with a retention period of 7 through 365 days. Add blob_properties with a delete_retention_policy block and set days to a value between 7 and 365."
  }
}
