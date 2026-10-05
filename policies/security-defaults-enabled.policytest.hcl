# Copyright IBM Corp. 2026

policytest {
  targets = ["security-defaults-enabled.policy.hcl"]
}

resource "msgraph_update_resource" "security_defaults_enabled" {
  attrs = {
  url = "policies/identitySecurityDefaultsEnforcementPolicy"
  body = {
    isEnabled = true
  }
  }
}

resource "msgraph_update_resource" "security_defaults_enabled_with_leading_slash" {
  attrs = {
  url = "/policies/identitySecurityDefaultsEnforcementPolicy"
  body = {
    isEnabled = true
  }
  }
}

resource "msgraph_update_resource" "security_defaults_disabled" {
  expect_failure = true
  attrs = {
  url = "policies/identitySecurityDefaultsEnforcementPolicy"
  body = {
    isEnabled = false
  }
  }
}

resource "msgraph_update_resource" "security_defaults_disabled_with_trailing_slash" {
  expect_failure = true
  attrs = {
  url = "policies/identitySecurityDefaultsEnforcementPolicy/"
  body = {
    isEnabled = false
  }
  }
}

resource "msgraph_update_resource" "security_defaults_disabled_mixed_case" {
  expect_failure = true
  attrs = {
  url = "Policies/IdentitySecurityDefaultsEnforcementPolicy"
  body = {
    isEnabled = false
  }
  }
}

resource "msgraph_update_resource" "security_defaults_string_true" {
  expect_failure = true
  attrs = {
  url = "policies/identitySecurityDefaultsEnforcementPolicy"
  body = {
    isEnabled = "true"
  }
  }
}

resource "msgraph_update_resource" "security_defaults_missing_enabled_flag" {
  expect_failure = true
  attrs = {
  url  = "policies/identitySecurityDefaultsEnforcementPolicy"
  body = {}
  }
}

resource "msgraph_update_resource" "security_defaults_null_enabled_flag" {
  expect_failure = true
  attrs = {
  url = "policies/identitySecurityDefaultsEnforcementPolicy"
  body = {
    isEnabled = null
  }
  }
}

resource "msgraph_update_resource" "security_defaults_disabled_beta_api" {
  expect_failure = true
  attrs = {
  url         = "policies/identitySecurityDefaultsEnforcementPolicy"
  api_version = "beta"
  body = {
    isEnabled = false
  }
  }
}

resource "msgraph_update_resource" "unrelated_graph_resource" {
  attrs = {
  url = "policies/authorizationPolicy"
  body = {
    isEnabled = false
  }
  }
}
