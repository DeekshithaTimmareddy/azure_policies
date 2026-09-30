# Copyright IBM Corp. 2026

# Ensure that Network Security Groups are Configured for Databricks Subnets

policy {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = ">= 4.0.0, < 6.0.0"
    }
  }
}

input "databricks-subnet-nsg-configured-enforcement-level" {
  type    = string
  default = "advisory"
}

locals {
  databricks_subnet_nsg_associations = core::getresources("azurerm_subnet_network_security_group_association", {})
  databricks_nsgs                    = core::getresources("azurerm_network_security_group", {})
  databricks_standalone_nsg_rules        = core::getresources("azurerm_network_security_rule", {})
}

resource_policy "azurerm_databricks_workspace" "nsg_associated_to_subnets" {
  locals {
    custom_params_raw = core::try(attrs.custom_parameters, null)
    custom_params     = local.custom_params_raw == null ? [] : local.custom_params_raw

    vnet_id_raw = core::length(local.custom_params) > 0 ? core::try(local.custom_params[0].virtual_network_id, null) : null
    vnet_id     = local.vnet_id_raw == null ? "" : local.vnet_id_raw
    has_vnet_id = core::try(core::regex("[^ \\t\\r\\n]", local.vnet_id), null) != null

    public_subnet_raw = core::length(local.custom_params) > 0 ? core::try(local.custom_params[0].public_subnet_name, null) : null
    public_subnet     = local.public_subnet_raw == null ? "" : local.public_subnet_raw
    has_public_subnet = core::try(core::regex("[^ \\t\\r\\n]", local.public_subnet), null) != null

    private_subnet_raw = core::length(local.custom_params) > 0 ? core::try(local.custom_params[0].private_subnet_name, null) : null
    private_subnet     = local.private_subnet_raw == null ? "" : local.private_subnet_raw
    has_private_subnet = core::try(core::regex("[^ \\t\\r\\n]", local.private_subnet), null) != null

    public_subnet_id  = local.has_vnet_id && local.has_public_subnet ? core::lower("${local.vnet_id}/subnets/${local.public_subnet}") : ""
    private_subnet_id = local.has_vnet_id && local.has_private_subnet ? core::lower("${local.vnet_id}/subnets/${local.private_subnet}") : ""

    public_nsg_associations = [
      for association in local.databricks_subnet_nsg_associations : association
      if local.public_subnet_id != "" &&
      core::lower(core::try(association.subnet_id, "")) == local.public_subnet_id &&
      core::try(association.network_security_group_id, "") != ""
    ]

    private_nsg_associations = [
      for association in local.databricks_subnet_nsg_associations : association
      if local.private_subnet_id != "" &&
      core::lower(core::try(association.subnet_id, "")) == local.private_subnet_id &&
      core::try(association.network_security_group_id, "") != ""
    ]

    public_associations_with_deny_rule = [
      for association in local.public_nsg_associations : association
      if core::length([
        for nsg in local.databricks_nsgs : nsg
        if core::lower(core::try(nsg.id, "")) == core::lower(core::try(association.network_security_group_id, "")) &&
        (
          core::length([
            for rule in core::try([for item in nsg.security_rule : item], []) : rule
            if core::lower(core::try(rule.access, "")) == "deny"
          ]) > 0 ||
          core::length([
            for rule in local.databricks_standalone_nsg_rules : rule
            if core::lower(core::try(rule.network_security_group_name, "")) == core::lower(core::try(nsg.name, "")) &&
            core::lower(core::try(rule.resource_group_name, "")) == core::lower(core::try(nsg.resource_group_name, "")) &&
            core::lower(core::try(rule.access, "")) == "deny"
          ]) > 0
        )
      ]) > 0
    ]

    private_associations_with_deny_rule = [
      for association in local.private_nsg_associations : association
      if core::length([
        for nsg in local.databricks_nsgs : nsg
        if core::lower(core::try(nsg.id, "")) == core::lower(core::try(association.network_security_group_id, "")) &&
        (
          core::length([
            for rule in core::try([for item in nsg.security_rule : item], []) : rule
            if core::lower(core::try(rule.access, "")) == "deny"
          ]) > 0 ||
          core::length([
            for rule in local.databricks_standalone_nsg_rules : rule
            if core::lower(core::try(rule.network_security_group_name, "")) == core::lower(core::try(nsg.name, "")) &&
            core::lower(core::try(rule.resource_group_name, "")) == core::lower(core::try(nsg.resource_group_name, "")) &&
            core::lower(core::try(rule.access, "")) == "deny"
          ]) > 0
        )
      ]) > 0
    ]
  }

  enforcement_level = input.databricks-subnet-nsg-configured-enforcement-level

  enforce {
    condition     = core::length(local.public_associations_with_deny_rule) > 0 && core::length(local.private_associations_with_deny_rule) > 0
    error_message = "Both Azure Databricks subnets must have a planned NSG association, and each associated NSG must be represented in the plan with an explicit Deny rule configured inline or as a standalone rule."
  }
}
