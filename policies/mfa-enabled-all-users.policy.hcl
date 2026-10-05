# Copyright IBM Corp. 2026

# Ensure that 'multifactor authentication' is 'enabled' For All Users

policy {
  required_providers {
    azuread = {
      source  = "hashicorp/azuread"
      version = ">= 3.0.0, < 4.0.0"
    }
  }
}

input "mfa-enabled-all-users-enforcement-level" {
  type    = string
  default = "advisory"
}

resource_policy "azuread_conditional_access_policy" "mfa_required_all_users" {
  locals {
    built_in_controls = core::try([for c in attrs.grant_controls[0].built_in_controls : core::lower(c)], [])
    requires_mfa      = core::contains(local.built_in_controls, "mfa") || core::try(core::trimspace(attrs.grant_controls[0].authentication_strength_policy_id), "") != ""
    targets_all_users = core::contains(core::try([for u in attrs.conditions[0].users[0].included_users : core::lower(u)], []), "all")

    is_enabled = core::try(core::lower(attrs.state), "") == "enabled"

    no_grant_bypass = core::try(core::upper(attrs.grant_controls[0].operator), "") == "AND" || (
      core::length([for c in local.built_in_controls : c if c != "mfa"]) == 0 &&
      core::length(core::try([for t in attrs.grant_controls[0].terms_of_use : t], [])) == 0 &&
      core::length(core::try([for f in attrs.grant_controls[0].custom_authentication_factors : f], [])) == 0
    )

    no_user_exclusions = (
      core::length(core::try([for u in attrs.conditions[0].users[0].excluded_users : u], [])) == 0 &&
      core::length(core::try([for g in attrs.conditions[0].users[0].excluded_groups : g], [])) == 0 &&
      core::length(core::try([for r in attrs.conditions[0].users[0].excluded_roles : r], [])) == 0 &&
      core::length(core::try([for e in attrs.conditions[0].users[0].excluded_guests_or_external_users : e], [])) == 0
    )

    all_apps = (
      core::contains(core::try([for a in attrs.conditions[0].applications[0].included_applications : core::lower(a)], []), "all") &&
      core::length(core::try([for a in attrs.conditions[0].applications[0].excluded_applications : a], [])) == 0 &&
      core::length(core::try([for f in attrs.conditions[0].applications[0].filter : f], [])) == 0
    )

    all_client_apps = core::contains(core::try([for c in attrs.conditions[0].client_app_types : core::lower(c)], []), "all")

    no_narrowing = (
      core::length(core::try([for l in attrs.conditions[0].locations : l], [])) == 0 &&
      core::length(core::try([for x in attrs.conditions[0].platforms : x], [])) == 0 &&
      core::length(core::try([for d in attrs.conditions[0].devices : d], [])) == 0 &&
      core::length(core::try([for r in attrs.conditions[0].sign_in_risk_levels : r], [])) == 0 &&
      core::length(core::try([for r in attrs.conditions[0].user_risk_levels : r], [])) == 0 &&
      core::length(core::try([for r in attrs.conditions[0].service_principal_risk_levels : r], [])) == 0 &&
      core::length(core::try([for m in attrs.conditions[0].authentication_flow_transfer_methods : m], [])) == 0 &&
      core::try(core::trimspace(attrs.conditions[0].insider_risk_levels), "") == ""
    )
  }

  filter = local.requires_mfa && local.targets_all_users

  enforcement_level = input.mfa-enabled-all-users-enforcement-level

  enforce {
    condition     = local.is_enabled && local.no_grant_bypass && local.no_user_exclusions && local.all_apps && local.all_client_apps && local.no_narrowing
    error_message = "A Conditional Access policy that requires MFA for All users must be enabled, apply to All cloud apps with no exclusions or application filter, use client app types 'all', have no user/group/role/guest exclusions, no location/platform/device/risk/auth-flow conditions, and must not use an OR grant that lets another control, terms of use or a custom factor replace MFA."
  }
}
