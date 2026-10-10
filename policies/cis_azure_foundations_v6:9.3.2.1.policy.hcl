policy {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "= 5.8.0"
    }
  }
}

locals {
  cis_9_3_2_1_private_endpoints = core::getresources("azurerm_private_endpoint", {})
}

resource_policy "azurerm_storage_account" "storage_private_endpoint" {
  locals {
    sa_id_raw = core::try(attrs.id, null)
    sa_id     = local.sa_id_raw == null ? "" : core::try(core::lower(local.sa_id_raw), "")

    matching_private_endpoints = [
      for pe in local.cis_9_3_2_1_private_endpoints : pe
      if local.sa_id != "" &&
      core::try(core::lower(pe.private_service_connection[0].private_connection_resource_id), "") == local.sa_id &&
      core::try(pe.private_service_connection[0].is_manual_connection, null) == false
    ]
  }

  enforcement_level = "advisory"

  enforce {
    condition     = core::length(local.matching_private_endpoints) > 0
    error_message = "No azurerm_private_endpoint is declared with an exact private_service_connection target to this storage account and is_manual_connection = false. Terraform configuration cannot prove that the connection is Approved or that every required VNet has its own endpoint; verify those conditions in Azure."
  }
}
