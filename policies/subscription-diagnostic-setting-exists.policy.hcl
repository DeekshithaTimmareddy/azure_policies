# Copyright IBM Corp. 2026

# Ensure that a 'Diagnostic Setting' Exists for Subscription Activity Logs

policy {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = ">= 4.0.0, < 6.0.0"
    }
  }
}

input "subscription-diagnostic-setting-exists-enforcement-level" {
  type    = string
  default = "advisory"
}

resource_policy "azurerm_monitor_diagnostic_setting" "subscription_diagnostic_setting_exists" {
  filter = core::try(core::regex("^/subscriptions/[^/]+$", core::lower(core::trimsuffix(core::trimspace(attrs.target_resource_id), "/"))), null) != null

  enforcement_level = input.subscription-diagnostic-setting-exists-enforcement-level

  locals {
    enabled_logs = [
      for l in core::try([for b in attrs.enabled_log : b], []) : l
      if core::try(core::trimspace(l.category), "") != "" || core::try(core::trimspace(l.category_group), "") != ""
    ]
  }

  enforce {
    condition     = core::length(local.enabled_logs) > 0
    error_message = "A subscription diagnostic setting must export activity logs by declaring at least one enabled_log category or category_group."
  }
}
