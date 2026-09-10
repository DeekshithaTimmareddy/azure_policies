# Copyright IBM Corp. 2026

# Ensure that 'Public Network Access' is 'Disabled' for Storage Accounts

policy {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = ">= 4.0.0, < 6.0.0"
    }
  }
}

input "storage-no-public-enforcement-level" {
  type    = string
  default = "advisory"
}

resource_policy "azurerm_storage_account" "disable_public_network_access" {
  locals {
    public_network_access_enabled_raw = core::try(attrs.public_network_access_enabled, null)
    public_network_access_enabled     = local.public_network_access_enabled_raw == null ? true : local.public_network_access_enabled_raw
  }

  enforcement_level = input.storage-no-public-enforcement-level
  enforce {
    condition     = local.public_network_access_enabled == false
    error_message = "Storage accounts must set public_network_access_enabled to false. Disable public network access and use private endpoints for trusted network access."
  }
}
