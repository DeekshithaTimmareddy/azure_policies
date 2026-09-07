# Copyright IBM Corp. 2026

# Ensure that 'Allow Blob Anonymous Access' is Set to 'Disabled'

policy {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = ">= 4.0.0, < 6.0.0"
    }
  }
}

resource_policy "azurerm_storage_account" "blob_anonymous_access_disabled" {
  locals {
    account_kind     = core::try(attrs.account_kind, "StorageV2")
    unsupported_kind = core::contains(["FileStorage", "BlockBlobStorage"], local.account_kind)

    allow_public_raw = core::try(attrs.allow_nested_items_to_be_public, null)
    allow_public     = local.allow_public_raw == null ? false : local.allow_public_raw
  }

  enforcement_level = "advisory"
  enforce {
    condition     = local.unsupported_kind || local.allow_public == false
    error_message = "Storage accounts must set allow_nested_items_to_be_public to false to disable anonymous blob access."
  }
}
