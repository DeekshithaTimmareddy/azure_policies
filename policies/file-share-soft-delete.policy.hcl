# Copyright IBM Corp. 2026

# Ensure Soft Delete for Azure File Shares is Enabled

policy {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = ">= 4.0.0, < 6.0.0"
    }
  }
}

input "file-share-soft-delete-enforcement-level" {
  type    = string
  default = "advisory"
}

resource_policy "azurerm_storage_account" "file_share_soft_delete" {
  locals {
    account_kind_raw  = core::try(attrs.account_kind, null)
    account_kind      = local.account_kind_raw == null ? "StorageV2" : local.account_kind_raw
    account_tier      = core::try(attrs.account_tier, "Standard")
    is_supported_kind = (
      local.account_kind == "FileStorage"
      || (local.account_kind == "StorageV2" && local.account_tier == "Standard")
      || (local.account_kind == "Storage" && local.account_tier == "Standard")
    )

    share_properties_raw = core::try(attrs.share_properties, null)
    retention_policy_raw = core::try(attrs.share_properties[0].retention_policy, core::try(attrs.share_properties.retention_policy, null))

    has_share_properties       = local.share_properties_raw != null
    has_retention_policy       = local.retention_policy_raw != null
    retention_days             = core::try(local.retention_policy_raw[0].days, core::try(local.retention_policy_raw.days, null))
    has_valid_retention_period = core::try(local.retention_days >= 1 && local.retention_days <= 365, false)
  }

  filter = local.is_supported_kind

  enforcement_level = input.file-share-soft-delete-enforcement-level
  enforce {
    condition     = local.has_share_properties && local.has_retention_policy && local.has_valid_retention_period
    error_message = "Azure Storage Accounts must enable file-share soft delete by configuring share_properties.retention_policy.days between 1 and 365 days."
  }
}
