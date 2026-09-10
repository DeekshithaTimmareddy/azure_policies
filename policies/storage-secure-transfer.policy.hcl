# Copyright IBM Corp. 2026

# Ensure Storage Secure Transfer Is Enabled

policy {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = ">= 4.0.0, < 6.0.0"
    }
  }
}

input "storage-secure-transfer-enforcement-level" {
  type    = string
  default = "advisory"
}

resource_policy "azurerm_storage_account" "ensure_secure_transfer_enabled" {
  locals {
    https_traffic_only_enabled_raw = core::try(attrs.https_traffic_only_enabled, null)
    https_traffic_only_enabled     = local.https_traffic_only_enabled_raw == null ? true : local.https_traffic_only_enabled_raw
  }

  enforcement_level = input.storage-secure-transfer-enforcement-level
  enforce {
    condition     = local.https_traffic_only_enabled
    error_message = "Azure Storage Accounts must require secure transfer by setting https_traffic_only_enabled to true."
  }
}
