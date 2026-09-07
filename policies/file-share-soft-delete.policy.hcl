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

resource_policy "azurerm_storage_account" "file_share_soft_delete" {
  locals {
    account_kind_raw  = core::try(attrs.account_kind, null)
    account_kind      = local.account_kind_raw == null ? "StorageV2" : local.account_kind_raw
    is_supported_kind = core::contains(["StorageV2", "FileStorage"], local.account_kind)

    share_properties_raw = core::try(attrs.share_properties[0], core::try(attrs.share_properties, null))
    has_share_properties = local.share_properties_raw != null

    retention_policy_raw = core::try(local.share_properties_raw.retention_policy[0], core::try(local.share_properties_raw.retention_policy, null))
    has_retention_policy = local.retention_policy_raw != null

    retention_days_raw   = core::try(local.retention_policy_raw.days, null)
    retention_days       = local.retention_days_raw != null ? local.retention_days_raw : 0

    has_valid_retention_period = local.retention_days >= 1 && local.retention_days <= 365

    is_compliant = !local.is_supported_kind || (local.has_share_properties && local.has_retention_policy && local.has_valid_retention_period)
  }

  enforcement_level = "advisory"
  enforce {
    condition     = local.is_compliant
    error_message = "Azure Storage Accounts must enable file-share soft delete by configuring share_properties.retention_policy.days between 1 and 365 days."
  }
}
