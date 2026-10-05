# Copyright IBM Corp. 2026

# Ensure Diagnostic Setting Captures Appropriate Categories

policy {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = ">= 4.0.0, < 6.0.0"
    }
  }
}

input "subscription-diagnostic-setting-categories-enforcement-level" {
  type    = string
  default = "advisory"
}

resource_policy "azurerm_monitor_diagnostic_setting" "subscription_diagnostic_setting_categories" {
  filter = core::try(core::regex("^/subscriptions/[^/]+$", core::lower(core::trimsuffix(core::trimspace(attrs.target_resource_id), "/"))), null) != null

  enforcement_level = input.subscription-diagnostic-setting-categories-enforcement-level

  locals {
    enabled_logs    = core::try([for b in attrs.enabled_log : b], [])
    categories      = [for l in local.enabled_logs : core::lower(core::trimspace(l.category)) if core::try(l.category, null) != null]
    category_groups = [for l in local.enabled_logs : core::lower(core::trimspace(l.category_group)) if core::try(l.category_group, null) != null]

    all_logs = core::contains(local.category_groups, "alllogs")
    missing  = [for c in ["Administrative", "Alert", "Policy", "Security"] : c if !core::contains(local.categories, core::lower(c))]
  }

  enforce {
    condition     = local.all_logs || core::length(local.missing) == 0
    error_message = "The subscription diagnostic setting must enable the Administrative, Alert, Policy and Security log categories, or the allLogs category group. Missing: ${core::join(", ", local.missing)}."
  }
}
