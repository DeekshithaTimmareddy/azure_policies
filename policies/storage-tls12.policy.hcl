# Copyright IBM Corp. 2026

# Ensure the 'Minimum TLS version' for Storage Accounts is Set to 'Version 1.2'

policy {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = ">= 4.0.0, < 6.0.0"
    }
  }
}

input "storage-tls12-enforcement-level" {
  type    = string
  default = "advisory"
}

resource_policy "azurerm_storage_account" "minimum_tls_version_1_2" {
  locals {
    min_tls_version = core::try(attrs.min_tls_version, null)
    is_compliant    = local.min_tls_version == null || local.min_tls_version == "TLS1_2"
  }

  enforcement_level = input.storage-tls12-enforcement-level
  enforce {
    condition     = local.is_compliant
    error_message = "Storage accounts must set min_tls_version to TLS1_2 or omit the attribute to use the provider default of TLS1_2."
  }
}
