# Copyright IBM Corp. 2026

# Ensure that Activity Log Alert exists for Delete Policy Assignment

policy {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = ">= 4.0.0, < 6.0.0"
    }
  }
}

input "delete-policy-assignment-alert-enforcement-level" {
  type    = string
  default = "advisory"
}

resource_policy "azurerm_monitor_activity_log_alert" "delete_policy_assignment_alert" {
  filter = core::try(core::lower(core::trimspace(attrs.criteria[0].operation_name)), "") == "microsoft.authorization/policyassignments/delete"

  enforcement_level = input.delete-policy-assignment-alert-enforcement-level

  locals {
    criteria = core::try(attrs.criteria[0], {})

    is_enabled = core::try(attrs.enabled, true) != false

    is_administrative = core::try(core::lower(core::trimspace(local.criteria.category)), "") == "administrative"

    known_scopes        = [for s in core::try([for x in attrs.scopes : x], []) : core::lower(core::trimsuffix(core::trimspace(s), "/")) if s != null]
    subscription_scoped = core::length(local.known_scopes) == 0 || core::length([for s in local.known_scopes : s if core::try(core::regex("^/subscriptions/[^/]+$", s), null) != null]) > 0

    has_action_group = core::length([
      for a in core::try([for x in attrs.action : x], []) : a
      if core::try(core::trimspace(a.action_group_id), "unknown") != ""
    ]) > 0

    narrowing_filters = [
      for k in [
        "caller", "level", "levels", "status", "statuses", "sub_status", "sub_statuses",
        "resource_group", "resource_groups", "resource_id", "resource_ids",
        "resource_provider", "resource_providers", "resource_type", "resource_types",
      ] : k
      if core::try(core::trimspace(local.criteria[k]), "") != "" || core::length(core::try([for v in local.criteria[k] : v], [])) > 0
    ]
  }

  enforce {
    condition     = local.is_enabled
    error_message = "The Delete Policy Assignment activity log alert must be enabled."
  }

  enforce {
    condition     = local.is_administrative
    error_message = "The Delete Policy Assignment activity log alert must use criteria category Administrative."
  }

  enforce {
    condition     = local.subscription_scoped
    error_message = "The Delete Policy Assignment activity log alert must be scoped to a subscription."
  }

  enforce {
    condition     = local.has_action_group
    error_message = "The Delete Policy Assignment activity log alert must notify an action group."
  }

  enforce {
    condition     = core::length(local.narrowing_filters) == 0
    error_message = "The Delete Policy Assignment activity log alert must not filter on level, status, caller or resource. Remove: ${core::join(", ", local.narrowing_filters)}."
  }
}
