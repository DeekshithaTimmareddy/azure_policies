# Copyright IBM Corp. 2026

# Ensure that No Custom Subscription Administrator Roles Exist

policy {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = ">= 4.0.0, < 6.0.0"
    }
  }
}

input "no-custom-subscription-admin-roles-enforcement-level" {
  type    = string
  default = "advisory"
}

resource_policy "azurerm_role_definition" "no_custom_subscription_admin_roles" {
  enforcement_level = input.no-custom-subscription-admin-roles-enforcement-level

  locals {
    grants_wildcard = core::length([
      for p in core::try([for b in attrs.permissions : b], []) : p
      if core::contains(core::try([for a in p.actions : core::trimspace(a)], []), "*")
    ]) > 0

    declared_scopes   = core::try([for s in attrs.assignable_scopes : s], [])
    effective_scopes  = core::length(local.declared_scopes) > 0 ? local.declared_scopes : core::try([attrs.scope], [])
    normalized_scopes = [for s in local.effective_scopes : core::lower(core::trim(core::trimspace(s), "/")) if s != null]

    subscription_or_broader = core::length([
      for s in local.normalized_scopes : s
      if s == "" ||
         core::try(core::regex("^subscriptions/[^/]+$", s), null) != null ||
         core::try(core::regex("^providers/microsoft\\.management/managementgroups/[^/]+$", s), null) != null
    ]) > 0
  }

  enforce {
    condition     = !(local.grants_wildcard && local.subscription_or_broader)
    error_message = "Custom role definitions must not grant the \"*\" action while assignable at subscription, management group or root scope. When assignable_scopes is omitted it defaults to scope."
  }
}
