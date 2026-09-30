# Copyright IBM Corp. 2026

# Ensure 'Allow Public Network Access' is set to 'Disabled'

policy {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = ">= 4.0.0, < 6.0.0"
    }
  }
}

input "databricks-public-network-access-disabled-enforcement-level" {
  type    = string
  default = "advisory"
}

resource_policy "azurerm_databricks_workspace" "public_network_access_disabled" {
    enforcement_level = input.databricks-public-network-access-disabled-enforcement-level

    locals {
        pna_raw     = core::try(attrs.public_network_access_enabled, null)
        pna_enabled = local.pna_raw == null ? true : local.pna_raw

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

        nsg_rules_required_raw = core::try(attrs.network_security_group_rules_required, null)
        nsg_rules_required     = local.nsg_rules_required_raw == null ? "" : core::lower(local.nsg_rules_required_raw)
    }

    enforce {
        condition     = local.pna_enabled == false && local.has_customer_vnet && local.has_public_subnet && local.has_private_subnet && (local.nsg_rules_required == "noazuredatabricksrules" || local.nsg_rules_required == "noazureservicerules")
        error_message = "Azure Databricks workspace must disable public network access, configure a customer-managed VNet with public and private subnet names, and set network_security_group_rules_required to NoAzureDatabricksRules or NoAzureServiceRules."
    }
}
