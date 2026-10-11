# Copyright IBM Corp. 2026

# Ensure that Storage Accounts Use Geo-Redundant Replication

policy {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "= 5.8.0"
    }
  }
}

input "storage-geo-redundant-enforcement-level" {
  type    = string
  default = "advisory"
}

resource_policy "azurerm_storage_account" "storage_account_geo_redundant" {
  locals {
    repl_raw = core::try(attrs.account_replication_type, null)
    repl     = local.repl_raw == null ? "" : local.repl_raw
    allowed  = ["GRS", "RAGRS", "GZRS", "RAGZRS"]
  }

  enforcement_level = input.storage-geo-redundant-enforcement-level
  enforce {
    condition     = core::contains(local.allowed, local.repl)
    error_message = "Storage account must use geo-redundant replication (GRS, RAGRS, GZRS or RAGZRS) for account_replication_type."
  }
}
