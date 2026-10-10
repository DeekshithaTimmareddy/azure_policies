policy {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = ">= 4.0.0, < 6.0.0"
    }
  }
}

locals {
  cis_7_10_waf_policies = [
    for p in core::getresources("azurerm_web_application_firewall_policy", {}) : {
      id      = core::try(core::lower(core::trimsuffix(core::trimspace(p.id), "/")), null)
      enabled = core::try(p.policy_settings[0].enabled, true) != false
    }
  ]
}

resource_policy "azurerm_application_gateway" "7_10" {
  enforcement_level = "advisory"

  locals {
    tier = core::try(attrs.sku[0].tier, null)
    firewall_policy_id = core::try(
      attrs.firewall_policy_id == null ? "" : core::lower(core::trimsuffix(core::trimspace(attrs.firewall_policy_id), "/")),
      null
    )
    reference_valid = local.firewall_policy_id == null ? true : core::try(
      core::regex("^/subscriptions/[^/]+/resourcegroups/[^/]+/providers/microsoft\\.network/applicationgatewaywebapplicationfirewallpolicies/[^/]+$", local.firewall_policy_id),
      null
    ) != null
    disabled_matches = [
      for p in local.cis_7_10_waf_policies : p
      if p.id != null && p.id != "" && p.id == local.firewall_policy_id && !p.enabled
    ]
  }

  enforce {
    condition     = local.tier == null ? true : local.tier == "WAF_v2"
    error_message = "The Application Gateway must use the WAF_v2 SKU tier."
  }

  enforce {
    condition     = local.reference_valid
    error_message = "The Application Gateway must reference a gateway-level Web Application Firewall policy through firewall_policy_id."
  }

  enforce {
    condition     = core::length(local.disabled_matches) == 0
    error_message = "The Application Gateway's associated Web Application Firewall policy must be enabled."
  }
}
