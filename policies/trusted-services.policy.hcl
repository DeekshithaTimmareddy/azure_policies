# Copyright IBM Corp. 2026

# Ensure 'Allow trusted Microsoft services to access this resource' is Enabled for Storage Account Access

policy {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = ">= 4.0.0, < 6.0.0"
    }
  }
}

input "trusted-services-enforcement-level" {
  type    = string
  default = "advisory"
}

resource_policy "azurerm_storage_account" "allow_trusted_microsoft_services" {
  locals {
    public_network_access_enabled_raw = core::try(attrs.public_network_access_enabled, null)
    public_network_access_enabled     = local.public_network_access_enabled_raw == null ? true : local.public_network_access_enabled_raw

    inline_rules_raw  = core::try(attrs.network_rules, null)
    has_inline_rules  = local.inline_rules_raw != null
    inline_default    = core::try(local.inline_rules_raw[0].default_action, core::try(local.inline_rules_raw.default_action, ""))
    inline_bypass_raw = core::try(local.inline_rules_raw[0].bypass, core::try(local.inline_rules_raw.bypass, null))
    inline_bypass     = local.inline_bypass_raw != null ? local.inline_bypass_raw : []

    standalone_id_raw     = core::try(attrs.id, null)
    standalone_rules      = local.standalone_id_raw != null ? core::getresources("azurerm_storage_account_network_rules", { storage_account_id = local.standalone_id_raw }) : []
    standalone_deny_rules = [for r in local.standalone_rules : r if core::try(r.default_action, "") == "Deny"]
    standalone_in_scope   = local.public_network_access_enabled && core::length(local.standalone_deny_rules) > 0
    standalone_trusted_services = core::length(local.standalone_deny_rules) > 0 && core::length([
      for r in local.standalone_deny_rules : r
      if core::contains(core::try(r.bypass, null) != null ? r.bypass : [], "AzureServices")
    ]) == core::length(local.standalone_deny_rules)

    inline_in_scope  = local.public_network_access_enabled && local.has_inline_rules && local.inline_default == "Deny"
    in_scope         = local.inline_in_scope || local.standalone_in_scope
    trusted_services = local.inline_in_scope ? core::contains(local.inline_bypass, "AzureServices") : local.standalone_trusted_services
  }

  enforcement_level = input.trusted-services-enforcement-level
  enforce {
    condition     = !local.in_scope || local.trusted_services
    error_message = "Storage account network rules have a default action of Deny but 'AzureServices' is not included in the bypass list."
  }
}
