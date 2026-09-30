# Copyright IBM Corp. 2026

# Ensure that Azure Databricks is deployed in a customer-managed virtual network (VNet)

policy {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = ">= 4.0.0, < 6.0.0"
    }
  }
}

input "databricks-vnet-injection-enforcement-level" {
  type    = string
  default = "advisory"
}

resource_policy "azurerm_databricks_workspace" "vnet_injection" {
    enforcement_level = input.databricks-vnet-injection-enforcement-level

    locals {
        custom_params_raw = core::try(attrs.custom_parameters, null)
        custom_params     = local.custom_params_raw == null ? [] : local.custom_params_raw
        vnet_id_raw       = core::length(local.custom_params) > 0 ? core::try(local.custom_params[0].virtual_network_id, null) : null
        vnet_id           = local.vnet_id_raw == null ? "" : local.vnet_id_raw
        has_customer_vnet = core::try(core::regex("[^ \\t\\r\\n]", local.vnet_id), null) != null

        public_subnet_raw = core::length(local.custom_params) > 0 ? core::try(local.custom_params[0].public_subnet_name, null) : null
        public_subnet     = local.public_subnet_raw == null ? "" : local.public_subnet_raw
        has_public_subnet = core::try(core::regex("[^ \\t\\r\\n]", local.public_subnet), null) != null

        private_subnet_raw = core::length(local.custom_params) > 0 ? core::try(local.custom_params[0].private_subnet_name, null) : null
        private_subnet     = local.private_subnet_raw == null ? "" : local.private_subnet_raw
        has_private_subnet = core::try(core::regex("[^ \\t\\r\\n]", local.private_subnet), null) != null
    }

    enforce {
        condition     = local.has_customer_vnet && local.has_public_subnet && local.has_private_subnet
        error_message = "Azure Databricks VNet injection requires a non-blank customer VNet ID and both public and private subnet names."
    }
}
