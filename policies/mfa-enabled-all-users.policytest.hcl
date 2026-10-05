# Copyright IBM Corp. 2026

policytest {
  targets = ["mfa-enabled-all-users.policy.hcl"]
}

resource "azuread_conditional_access_policy" "pass_real_plan_shape" {
  attrs = {
  display_name = "pass-real-plan-shape"
  state = "enabled"
  conditions = [
    {
    client_app_types = ["all"]
    authentication_flow_transfer_methods = null
    insider_risk_levels = null
    service_principal_risk_levels = null
    sign_in_risk_levels = null
    user_risk_levels = null
    locations = []
    platforms = []
    devices = []
    client_applications = []
    applications = [
      {
      excluded_applications = null
      filter = []
      included_applications = ["All"]
      included_user_actions = null
      }
    ]
    users = [
      {
      excluded_groups = null
      excluded_guests_or_external_users = []
      excluded_roles = null
      excluded_users = null
      included_groups = null
      included_guests_or_external_users = []
      included_roles = null
      included_users = ["All"]
      }
    ]
    }
  ]
  grant_controls = [
    {
    authentication_strength_policy_id = null
    built_in_controls = ["mfa"]
    custom_authentication_factors = null
    operator = "OR"
    terms_of_use = null
    }
  ]
  session_controls = []
  }
}

resource "azuread_conditional_access_policy" "pass_mfa_all_users" {
  attrs = {
  display_name = "pass-mfa-all-users"
  state = "enabled"
  conditions = [
    {
    client_app_types = ["all"]
    applications = [
      {
      included_applications = ["All"]
      }
    ]
    users = [
      {
      included_users = ["All"]
      }
    ]
    }
  ]
  grant_controls = [
    {
    operator = "OR"
    built_in_controls = ["mfa"]
    }
  ]
  }
}

resource "azuread_conditional_access_policy" "pass_mfa_and_compliant_device" {
  attrs = {
  display_name = "pass-mfa-and-compliant-device"
  state = "enabled"
  conditions = [
    {
    client_app_types = ["all"]
    applications = [
      {
      included_applications = ["All"]
      }
    ]
    users = [
      {
      included_users = ["All"]
      }
    ]
    }
  ]
  grant_controls = [
    {
    operator = "AND"
    built_in_controls = ["mfa", "compliantDevice"]
    }
  ]
  }
}

resource "azuread_conditional_access_policy" "pass_mfa_and_terms_of_use" {
  attrs = {
  display_name = "pass-mfa-and-terms-of-use"
  state = "enabled"
  conditions = [
    {
    client_app_types = ["all"]
    applications = [
      {
      included_applications = ["All"]
      }
    ]
    users = [
      {
      included_users = ["All"]
      }
    ]
    }
  ]
  grant_controls = [
    {
    operator = "AND"
    built_in_controls = ["mfa"]
    terms_of_use = ["44444444-4444-4444-4444-444444444444"]
    }
  ]
  }
}

resource "azuread_conditional_access_policy" "pass_authentication_strength" {
  attrs = {
  display_name = "pass-authentication-strength"
  state = "enabled"
  conditions = [
    {
    client_app_types = ["all"]
    applications = [
      {
      included_applications = ["All"]
      }
    ]
    users = [
      {
      included_users = ["All"]
      }
    ]
    }
  ]
  grant_controls = [
    {
    operator = "OR"
    built_in_controls = []
    authentication_strength_policy_id = "/policies/authenticationStrengthPolicies/00000000-0000-0000-0000-000000000002"
    }
  ]
  }
}

resource "azuread_conditional_access_policy" "ignored_mfa_group_scoped" {
  attrs = {
  display_name = "ignored-mfa-group-scoped"
  state = "disabled"
  conditions = [
    {
    client_app_types = ["all"]
    applications = [
      {
      included_applications = ["All"]
      }
    ]
    users = [
      {
      included_users = []
      included_groups = ["11111111-1111-1111-1111-111111111111"]
      }
    ]
    }
  ]
  grant_controls = [
    {
    operator = "OR"
    built_in_controls = ["mfa"]
    }
  ]
  }
}

resource "azuread_conditional_access_policy" "ignored_block_legacy_auth" {
  attrs = {
  display_name = "ignored-block-legacy-auth"
  state = "enabled"
  conditions = [
    {
    client_app_types = ["exchangeActiveSync", "other"]
    applications = [
      {
      included_applications = ["All"]
      }
    ]
    users = [
      {
      included_users = ["All"]
      }
    ]
    }
  ]
  grant_controls = [
    {
    operator = "OR"
    built_in_controls = ["block"]
    }
  ]
  }
}

resource "azuread_conditional_access_policy" "fail_disabled" {
  expect_failure = true
  attrs = {
  display_name = "fail-disabled"
  state = "disabled"
  conditions = [
    {
    client_app_types = ["all"]
    applications = [
      {
      included_applications = ["All"]
      }
    ]
    users = [
      {
      included_users = ["All"]
      }
    ]
    }
  ]
  grant_controls = [
    {
    operator = "OR"
    built_in_controls = ["mfa"]
    }
  ]
  }
}

resource "azuread_conditional_access_policy" "fail_report_only" {
  expect_failure = true
  attrs = {
  display_name = "fail-report-only"
  state = "enabledForReportingButNotEnforced"
  conditions = [
    {
    client_app_types = ["all"]
    applications = [
      {
      included_applications = ["All"]
      }
    ]
    users = [
      {
      included_users = ["All"]
      }
    ]
    }
  ]
  grant_controls = [
    {
    operator = "OR"
    built_in_controls = ["mfa"]
    }
  ]
  }
}

resource "azuread_conditional_access_policy" "fail_excluded_user" {
  expect_failure = true
  attrs = {
  display_name = "fail-excluded-user"
  state = "enabled"
  conditions = [
    {
    client_app_types = ["all"]
    applications = [
      {
      included_applications = ["All"]
      }
    ]
    users = [
      {
      included_users = ["All"]
      excluded_users = ["22222222-2222-2222-2222-222222222222"]
      }
    ]
    }
  ]
  grant_controls = [
    {
    operator = "OR"
    built_in_controls = ["mfa"]
    }
  ]
  }
}

resource "azuread_conditional_access_policy" "fail_excluded_group" {
  expect_failure = true
  attrs = {
  display_name = "fail-excluded-group"
  state = "enabled"
  conditions = [
    {
    client_app_types = ["all"]
    applications = [
      {
      included_applications = ["All"]
      }
    ]
    users = [
      {
      included_users = ["All"]
      excluded_groups = ["33333333-3333-3333-3333-333333333333"]
      }
    ]
    }
  ]
  grant_controls = [
    {
    operator = "OR"
    built_in_controls = ["mfa"]
    }
  ]
  }
}

resource "azuread_conditional_access_policy" "fail_excluded_role" {
  expect_failure = true
  attrs = {
  display_name = "fail-excluded-role"
  state = "enabled"
  conditions = [
    {
    client_app_types = ["all"]
    applications = [
      {
      included_applications = ["All"]
      }
    ]
    users = [
      {
      included_users = ["All"]
      excluded_roles = ["62e90394-69f5-4237-9190-012177145e10"]
      }
    ]
    }
  ]
  grant_controls = [
    {
    operator = "OR"
    built_in_controls = ["mfa"]
    }
  ]
  }
}

resource "azuread_conditional_access_policy" "fail_excluded_guests" {
  expect_failure = true
  attrs = {
  display_name = "fail-excluded-guests"
  state = "enabled"
  conditions = [
    {
    client_app_types = ["all"]
    applications = [
      {
      included_applications = ["All"]
      }
    ]
    users = [
      {
      included_users = ["All"]
      excluded_guests_or_external_users = [
        {
        guest_or_external_user_types = ["b2bCollaborationGuest"]
        }
      ]
      }
    ]
    }
  ]
  grant_controls = [
    {
    operator = "OR"
    built_in_controls = ["mfa"]
    }
  ]
  }
}

resource "azuread_conditional_access_policy" "fail_single_application" {
  expect_failure = true
  attrs = {
  display_name = "fail-single-application"
  state = "enabled"
  conditions = [
    {
    client_app_types = ["all"]
    applications = [
      {
      included_applications = ["797f4846-ba00-4fd7-ba43-dac1f8f63013"]
      }
    ]
    users = [
      {
      included_users = ["All"]
      }
    ]
    }
  ]
  grant_controls = [
    {
    operator = "OR"
    built_in_controls = ["mfa"]
    }
  ]
  }
}

resource "azuread_conditional_access_policy" "fail_excluded_application" {
  expect_failure = true
  attrs = {
  display_name = "fail-excluded-application"
  state = "enabled"
  conditions = [
    {
    client_app_types = ["all"]
    applications = [
      {
      included_applications = ["All"]
      excluded_applications = ["797f4846-ba00-4fd7-ba43-dac1f8f63013"]
      }
    ]
    users = [
      {
      included_users = ["All"]
      }
    ]
    }
  ]
  grant_controls = [
    {
    operator = "OR"
    built_in_controls = ["mfa"]
    }
  ]
  }
}

resource "azuread_conditional_access_policy" "fail_application_filter" {
  expect_failure = true
  attrs = {
  display_name = "fail-application-filter"
  state = "enabled"
  conditions = [
    {
    client_app_types = ["all"]
    applications = [
      {
      included_applications = ["All"]
      filter = [
        {
        mode = "exclude"
        rule = "CustomSecurityAttribute.Engineering_Project -eq \"Baker\""
        }
      ]
      }
    ]
    users = [
      {
      included_users = ["All"]
      }
    ]
    }
  ]
  grant_controls = [
    {
    operator = "OR"
    built_in_controls = ["mfa"]
    }
  ]
  }
}

resource "azuread_conditional_access_policy" "fail_browser_only" {
  expect_failure = true
  attrs = {
  display_name = "fail-browser-only"
  state = "enabled"
  conditions = [
    {
    client_app_types = ["browser"]
    applications = [
      {
      included_applications = ["All"]
      }
    ]
    users = [
      {
      included_users = ["All"]
      }
    ]
    }
  ]
  grant_controls = [
    {
    operator = "OR"
    built_in_controls = ["mfa"]
    }
  ]
  }
}

resource "azuread_conditional_access_policy" "fail_excluded_trusted_location" {
  expect_failure = true
  attrs = {
  display_name = "fail-excluded-trusted-location"
  state = "enabled"
  conditions = [
    {
    client_app_types = ["all"]
    applications = [
      {
      included_applications = ["All"]
      }
    ]
    users = [
      {
      included_users = ["All"]
      }
    ]
    locations = [
      {
      included_locations = ["All"]
      excluded_locations = ["AllTrusted"]
      }
    ]
    }
  ]
  grant_controls = [
    {
    operator = "OR"
    built_in_controls = ["mfa"]
    }
  ]
  }
}

resource "azuread_conditional_access_policy" "fail_platform_scoped" {
  expect_failure = true
  attrs = {
  display_name = "fail-platform-scoped"
  state = "enabled"
  conditions = [
    {
    client_app_types = ["all"]
    applications = [
      {
      included_applications = ["All"]
      }
    ]
    users = [
      {
      included_users = ["All"]
      }
    ]
    platforms = [
      {
      included_platforms = ["windows"]
      }
    ]
    }
  ]
  grant_controls = [
    {
    operator = "OR"
    built_in_controls = ["mfa"]
    }
  ]
  }
}

resource "azuread_conditional_access_policy" "fail_device_filter" {
  expect_failure = true
  attrs = {
  display_name = "fail-device-filter"
  state = "enabled"
  conditions = [
    {
    client_app_types = ["all"]
    applications = [
      {
      included_applications = ["All"]
      }
    ]
    users = [
      {
      included_users = ["All"]
      }
    ]
    devices = [
      {
      filter = [
        {
        mode = "exclude"
        rule = "device.trustType -eq \"AzureAD\""
        }
      ]
      }
    ]
    }
  ]
  grant_controls = [
    {
    operator = "OR"
    built_in_controls = ["mfa"]
    }
  ]
  }
}

resource "azuread_conditional_access_policy" "fail_sign_in_risk" {
  expect_failure = true
  attrs = {
  display_name = "fail-sign-in-risk"
  state = "enabled"
  conditions = [
    {
    client_app_types = ["all"]
    applications = [
      {
      included_applications = ["All"]
      }
    ]
    users = [
      {
      included_users = ["All"]
      }
    ]
    sign_in_risk_levels = ["high"]
    }
  ]
  grant_controls = [
    {
    operator = "OR"
    built_in_controls = ["mfa"]
    }
  ]
  }
}

resource "azuread_conditional_access_policy" "fail_user_risk" {
  expect_failure = true
  attrs = {
  display_name = "fail-user-risk"
  state = "enabled"
  conditions = [
    {
    client_app_types = ["all"]
    applications = [
      {
      included_applications = ["All"]
      }
    ]
    users = [
      {
      included_users = ["All"]
      }
    ]
    user_risk_levels = ["high"]
    }
  ]
  grant_controls = [
    {
    operator = "OR"
    built_in_controls = ["mfa"]
    }
  ]
  }
}

resource "azuread_conditional_access_policy" "fail_service_principal_risk" {
  expect_failure = true
  attrs = {
  display_name = "fail-service-principal-risk"
  state = "enabled"
  conditions = [
    {
    client_app_types = ["all"]
    applications = [
      {
      included_applications = ["All"]
      }
    ]
    users = [
      {
      included_users = ["All"]
      }
    ]
    service_principal_risk_levels = ["high"]
    }
  ]
  grant_controls = [
    {
    operator = "OR"
    built_in_controls = ["mfa"]
    }
  ]
  }
}

resource "azuread_conditional_access_policy" "fail_insider_risk" {
  expect_failure = true
  attrs = {
  display_name = "fail-insider-risk"
  state = "enabled"
  conditions = [
    {
    client_app_types = ["all"]
    applications = [
      {
      included_applications = ["All"]
      }
    ]
    users = [
      {
      included_users = ["All"]
      }
    ]
    insider_risk_levels = "elevated"
    }
  ]
  grant_controls = [
    {
    operator = "OR"
    built_in_controls = ["mfa"]
    }
  ]
  }
}

resource "azuread_conditional_access_policy" "fail_auth_flow" {
  expect_failure = true
  attrs = {
  display_name = "fail-auth-flow"
  state = "enabled"
  conditions = [
    {
    client_app_types = ["all"]
    applications = [
      {
      included_applications = ["All"]
      }
    ]
    users = [
      {
      included_users = ["All"]
      }
    ]
    authentication_flow_transfer_methods = ["deviceCodeFlow"]
    }
  ]
  grant_controls = [
    {
    operator = "OR"
    built_in_controls = ["mfa"]
    }
  ]
  }
}

resource "azuread_conditional_access_policy" "fail_or_with_compliant_device" {
  expect_failure = true
  attrs = {
  display_name = "fail-or-with-compliant-device"
  state = "enabled"
  conditions = [
    {
    client_app_types = ["all"]
    applications = [
      {
      included_applications = ["All"]
      }
    ]
    users = [
      {
      included_users = ["All"]
      }
    ]
    }
  ]
  grant_controls = [
    {
    operator = "OR"
    built_in_controls = ["mfa", "compliantDevice"]
    }
  ]
  }
}

resource "azuread_conditional_access_policy" "fail_or_with_terms_of_use" {
  expect_failure = true
  attrs = {
  display_name = "fail-or-with-terms-of-use"
  state = "enabled"
  conditions = [
    {
    client_app_types = ["all"]
    applications = [
      {
      included_applications = ["All"]
      }
    ]
    users = [
      {
      included_users = ["All"]
      }
    ]
    }
  ]
  grant_controls = [
    {
    operator = "OR"
    built_in_controls = ["mfa"]
    terms_of_use = ["44444444-4444-4444-4444-444444444444"]
    }
  ]
  }
}

resource "azuread_conditional_access_policy" "fail_or_with_custom_factor" {
  expect_failure = true
  attrs = {
  display_name = "fail-or-with-custom-factor"
  state = "enabled"
  conditions = [
    {
    client_app_types = ["all"]
    applications = [
      {
      included_applications = ["All"]
      }
    ]
    users = [
      {
      included_users = ["All"]
      }
    ]
    }
  ]
  grant_controls = [
    {
    operator = "OR"
    built_in_controls = ["mfa"]
    custom_authentication_factors = ["RequireDuoMfa"]
    }
  ]
  }
}
