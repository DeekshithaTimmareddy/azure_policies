# Copyright IBM Corp. 2026

# Ensure Private Endpoints are used to access Azure Databricks workspaces

policy {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = ">= 4.0.0, < 6.0.0"
    }
  }
}

input "databricks-private-endpoints-used-enforcement-level" {
  type    = string
  default = "advisory"
}

locals {
  databricks_private_endpoints = core::getresources("azurerm_private_endpoint", {})
}

resource_policy "azurerm_databricks_workspace" "require_private_endpoint" {
  locals {
    ws_id_raw = core::try(attrs.id, null)
    ws_id     = local.ws_id_raw == null ? "" : core::lower(local.ws_id_raw)
    has_ws_id = core::try(core::regex("[^ \\t\\r\\n]", local.ws_id), null) != null

    custom_params_raw = core::try(attrs.custom_parameters, null)
    custom_params     = local.custom_params_raw == null ? [] : local.custom_params_raw
    vnet_id_raw       = core::length(local.custom_params) > 0 ? core::try(local.custom_params[0].virtual_network_id, null) : null
    vnet_id           = local.vnet_id_raw == null ? "" : local.vnet_id_raw
    public_subnet_raw = core::length(local.custom_params) > 0 ? core::try(local.custom_params[0].public_subnet_name, null) : null
    public_subnet     = local.public_subnet_raw == null ? "" : local.public_subnet_raw
    private_subnet_raw = core::length(local.custom_params) > 0 ? core::try(local.custom_params[0].private_subnet_name, null) : null
    private_subnet     = local.private_subnet_raw == null ? "" : local.private_subnet_raw
    no_public_ip_raw   = core::try(attrs.custom_parameters[0].no_public_ip, null)
    no_public_ip       = local.no_public_ip_raw == null ? true : local.no_public_ip_raw
    has_vnet           = core::try(core::regex("[^ \\t\\r\\n]", local.vnet_id), null) != null
    has_public_subnet  = core::try(core::regex("[^ \\t\\r\\n]", local.public_subnet), null) != null
    has_private_subnet = core::try(core::regex("[^ \\t\\r\\n]", local.private_subnet), null) != null
    prerequisites_met  = core::lower(core::try(attrs.sku, "")) == "premium" && local.has_vnet && local.has_public_subnet && local.has_private_subnet && local.no_public_ip == true

    matching_pe_count = core::length([
      for pe in local.databricks_private_endpoints : pe
      if core::length([
        for psc in core::try([for c in pe.private_service_connection : c], []) : psc
        if local.has_ws_id &&
        core::lower(core::try(psc.private_connection_resource_id, null) == null ? "" : core::try(psc.private_connection_resource_id, null)) == local.ws_id &&
        core::length([
          for group_id in core::try([for group in psc.subresource_names : group], []) : group_id
          if (group_id != null ? core::lower(group_id) : "") == "databricks_ui_api" ||
          (group_id != null ? core::lower(group_id) : "") == "browser_authentication"
        ]) > 0 &&
        core::try(core::regex("[^ \\t\\r\\n]", core::try(pe.subnet_id, "")), null) != null
      ]) > 0
    ])
  }

  enforcement_level = input.databricks-private-endpoints-used-enforcement-level

  enforce {
    condition     = local.prerequisites_met && local.matching_pe_count > 0
    error_message = "Azure Databricks workspace must use the Premium SKU, customer VNet injection with both subnet names, Secure Cluster Connectivity (No Public IP), and a planned Private Endpoint targeting this workspace with a supported Databricks subresource."
  }
}
