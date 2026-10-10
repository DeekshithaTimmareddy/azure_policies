policy {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "= 5.8.0"
    }
  }
}

locals {
  all_waf_policies_for_body_check = core::try(core::getresources("azurerm_web_application_firewall_policy", {}), [])
}

resource_policy "azurerm_application_gateway" "appgw_request_body_check" {
  locals {
    waf_list   = core::try([for w in attrs.waf_configuration : w], [])
    inline_bad = [for w in local.waf_list : w if (core::try(w.request_body_check, null) == null ? true : core::try(w.request_body_check, null)) != true]

    fp_id_raw = core::try(attrs.firewall_policy_id, null)
    fp_id     = local.fp_id_raw == null ? "" : core::try(core::lower(local.fp_id_raw), "")

    linked     = local.fp_id == "" ? [] : [for p in local.all_waf_policies_for_body_check : p if core::try(core::lower(p.id), "") == local.fp_id]
    linked_bad = [for p in local.linked : p if (core::try(p.policy_settings[0].request_body_check, null) == null ? true : core::try(p.policy_settings[0].request_body_check, null)) != true]
  }

  enforcement_level = "advisory"
  enforce {
    condition     = core::length(local.inline_bad) == 0 && core::length(local.linked_bad) == 0
    error_message = "Application gateway must have request body inspection enabled: its linked WAF policy and any inline waf_configuration must not set request_body_check = false."
  }
}
