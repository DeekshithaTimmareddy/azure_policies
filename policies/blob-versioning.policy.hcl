# Copyright IBM Corp. 2026

# Ensure 'Versioning' is Set to 'Enabled' on Azure Blob Storage Storage Accounts

policy {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = ">= 4.0.0, < 6.0.0"
    }
  }
}

input "blob-versioning-enforcement-level" {
  type    = string
  default = "advisory"
}

resource_policy "azurerm_storage_account" "blob_versioning_enabled" {
  filter = core::try(attrs.account_kind, "StorageV2") != "Storage" && core::try(attrs.account_kind, "StorageV2") != "FileStorage"

  locals {
    versioning_enabled_raw = core::try(attrs.blob_properties[0].versioning_enabled, attrs.blob_properties.versioning_enabled, null)
    versioning_enabled     = local.versioning_enabled_raw == null ? false : local.versioning_enabled_raw
  }

  enforcement_level = input.blob-versioning-enforcement-level
  enforce {
    condition     = local.versioning_enabled == true
    error_message = "Enable blob versioning by setting blob_properties.versioning_enabled to true on this Azure storage account."
  }
}
