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

resource_policy "azurerm_storage_account" "disable_public_network_access" {
  locals {
    public_network_access_raw = core::try(attrs.public_network_access, null)
    public_network_access     = local.public_network_access_raw == null ? "Enabled" : local.public_network_access_raw
  }

  enforcement_level = "advisory"
  enforce {
    condition     = local.public_network_access == "Disabled"
    error_message = "Storage accounts must set public_network_access to 'Disabled'. Disable public network access and use private endpoints for trusted network access."
  }
}
