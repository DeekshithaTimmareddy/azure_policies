policy {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "= 5.8.0"
    }
  }
}

locals {
  all_waf_policies_for_bot_protection = core::try(core::getresources("azurerm_web_application_firewall_policy", {}), [])
}

resource_policy "azurerm_application_gateway" "bot_protection_enabled" {
  locals {
    sku_list                = core::try([for s in attrs.sku : s], [])
    sku                     = core::try(local.sku_list[0], {})
    tier                    = core::try(local.sku.tier, "")
    in_scope                = local.tier == "WAF_v2"
    policy_id_raw           = core::try(attrs.firewall_policy_id, null)
    policy_id               = local.policy_id_raw == null ? "" : core::try(core::lower(local.policy_id_raw), "")
    linked_policy           = local.policy_id == "" ? [] : [for p in local.all_waf_policies_for_bot_protection : p if core::try(core::lower(p.id), "") == local.policy_id]
    inline_waf              = core::try([for w in attrs.waf_configuration : w], [])
    managed_rules           = core::flatten([for p in local.linked_policy : core::try([for m in p.managed_rules : m], [])])
    rule_sets               = core::flatten([for m in local.managed_rules : core::try([for s in m.managed_rule_set : s], [])])
    bot_sets                = [for s in local.rule_sets : s if core::try(s.type, "") == "Microsoft_BotManagerRuleSet"]
    known_bad_overrides = core::flatten([
      for s in local.bot_sets : [
        for o in core::try([for x in s.rule_group_override : x], []) : o
        if core::try(o.rule_group_name, "") == "KnownBadBots"
      ]
    ])
    disabled_known_bad_rules = core::flatten([
      for o in local.known_bad_overrides : [
        for r in core::try([for x in o.rule : x], []) : r
        if core::try(r.enabled, null) == null ? true : core::try(r.enabled, false) == false
      ]
    ])
    association_deferred    = (local.policy_id == "" && core::length(local.inline_waf) == 0) || (local.policy_id != "" && core::length(local.linked_policy) == 0)
    bot_protection_enabled = core::length(local.bot_sets) > 0 && core::length(local.disabled_known_bad_rules) == 0
  }

  enforcement_level = "advisory"

  enforce {
    condition     = !local.in_scope || local.association_deferred || local.bot_protection_enabled
    error_message = "Azure Application Gateway WAF must be associated with a plan-visible WAF policy that enables Microsoft_BotManagerRuleSet and does not disable any KnownBadBots rules (CIS 7.15)."
  }
}
