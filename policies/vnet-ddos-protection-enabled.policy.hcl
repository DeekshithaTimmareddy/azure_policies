# Copyright IBM Corp. 2026

# Ensure that DDoS Network Protection is Enabled on Virtual Networks

policy {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "= 5.8.0"
    }
  }
}

input "vnet-ddos-protection-enabled-enforcement-level" {
  type    = string
  default = "advisory"
}

resource_policy "azurerm_virtual_network" "ddos_protection_enabled" {
  locals {
    ddos_blocks = core::try([for block in attrs.ddos_protection_plan : block], [])
    enable_raw  = core::try(attrs.ddos_protection_plan[0].enable, null)
    enable      = local.enable_raw == null ? false : local.enable_raw
    id_raw      = core::try(attrs.ddos_protection_plan[0].id, null)
    plan_id     = local.id_raw == null ? "" : local.id_raw
  }

  enforcement_level = input.vnet-ddos-protection-enabled-enforcement-level
  enforce {
    condition     = core::length(local.ddos_blocks) > 0 && local.enable == true && core::trimspace(local.plan_id) != ""
    error_message = "Virtual network must have DDoS Network Protection enabled and reference a DDoS protection plan (ddos_protection_plan.enable = true with a non-empty plan id)."
  }
}
