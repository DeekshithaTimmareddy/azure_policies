policy {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "= 5.8.0"
    }
  }
}

locals {
  all_sa_network_rules = core::getresources("azurerm_storage_account_network_rules", {})
  all_storage_accounts = core::getresources("azurerm_storage_account", {})
}

resource_policy "azurerm_storage_account" "default_network_access_deny" {
  locals {
    pna_raw     = core::try(attrs.public_network_access_enabled, null)
    pna_enabled = local.pna_raw == null ? true : local.pna_raw
    sa_id       = core::try(core::lower(attrs.id), "")

    inline_blocks = core::try([for b in attrs.network_rules : b], [])
    inline_da_raw = core::length(local.inline_blocks) > 0 ? core::try(local.inline_blocks[0].default_action, null) : null
    inline_action = local.inline_da_raw == null ? "" : local.inline_da_raw

    rule_refs = [for r in local.all_sa_network_rules : { sid = core::try(core::lower(r.storage_account_id), ""), da = core::try(r.default_action, null) }]

    correlated         = [for r in local.rule_refs : r if r.sid != "" && local.sa_id != "" && r.sid == local.sa_id]
    correlated_actions = [for r in local.correlated : r.da == null ? "" : r.da]
    has_correlated      = core::length(local.correlated_actions) > 0
    correlated_all_deny = core::length([for a in local.correlated_actions : a if a != "Deny"]) == 0
    effective_deny      = local.has_correlated ? local.correlated_all_deny : local.inline_action == "Deny"
  }

  enforcement_level = "advisory"

  enforce {
    condition     = local.pna_enabled == false || local.effective_deny
    error_message = "Storage account '${core::try(attrs.name, "unknown")}' must set its default network access rule (network_rules.default_action or azurerm_storage_account_network_rules.default_action) to 'Deny' unless public network access is disabled (CIS 9.3.2.3)."
  }
}

resource_policy "azurerm_storage_account_network_rules" "network_rules_default_action_deny" {
  locals {
    da_raw = core::try(attrs.default_action, null)
    da     = local.da_raw == null ? "" : local.da_raw
    sid    = core::try(core::lower(attrs.storage_account_id), "")

    sa_refs = [for s in local.all_storage_accounts : { id = core::try(core::lower(s.id), ""), pna = core::try(s.public_network_access_enabled, null) }]
    matched = [for s in local.sa_refs : s if local.sid != "" && s.id != "" && s.id == local.sid]

    sa_public_disabled = core::length(local.matched) > 0 && core::length([for s in local.matched : s if s.pna != false]) == 0
  }

  enforcement_level = "advisory"

  enforce {
    condition     = local.da == "Deny" || local.sa_public_disabled
    error_message = "azurerm_storage_account_network_rules for '${core::try(attrs.storage_account_id, "unknown")}' must set default_action to 'Deny' unless the exactly matched storage account has public network access disabled (CIS 9.3.2.3)."
  }
}
