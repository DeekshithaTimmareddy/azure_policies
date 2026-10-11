# Copyright IBM Corp. 2026

# Ensure that Storage Accounts Have Declared Private Endpoint Connections

policy {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "= 5.8.0"
    }
  }
}

input "storage-private-endpoint-enforcement-level" {
  type    = string
  default = "advisory"
}

locals {
  storage_private_endpoints = core::getresources("azurerm_private_endpoint", {})
}

resource_policy "azurerm_storage_account" "storage_private_endpoint" {
  locals {
    sa_id_raw = core::try(attrs.id, null)
    sa_id     = local.sa_id_raw == null ? "" : core::try(core::lower(local.sa_id_raw), "")

    matching_private_endpoints = [
      for pe in local.storage_private_endpoints : pe
      if local.sa_id != "" &&
      core::try(core::lower(pe.private_service_connection[0].private_connection_resource_id), "") == local.sa_id &&
      core::try(pe.private_service_connection[0].is_manual_connection, null) == false
    ]
  }

  enforcement_level = input.storage-private-endpoint-enforcement-level
  enforce {
    condition     = core::length(local.matching_private_endpoints) > 0
    error_message = "No azurerm_private_endpoint is declared with an exact private_service_connection target to this storage account and is_manual_connection = false. Terraform configuration cannot prove that the connection is Approved or that every required VNet has its own endpoint; verify those conditions in Azure."
  }
}
