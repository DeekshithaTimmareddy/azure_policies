# Copyright IBM Corp. 2026

# Ensure 'Allow storage account key access' for Azure Storage Accounts is 'Disabled'

policy {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = ">= 4.0.0, < 6.0.0"
    }
  }
}

input "disable-shared-key-enforcement-level" {
  type    = string
  default = "advisory"
}

resource_policy "azurerm_storage_account" "disable_shared_key_access" {
  locals {
    shared_access_key_enabled = core::try(attrs.shared_access_key_enabled, null)
    is_compliant              = local.shared_access_key_enabled != null && local.shared_access_key_enabled == false
  }

  enforcement_level = input.disable-shared-key-enforcement-level
  enforce {
    condition     = local.is_compliant
    error_message = "Azure Storage Accounts must explicitly set shared_access_key_enabled to false. Set shared_access_key_enabled = false to disable Shared Key authorization."
  }
}
