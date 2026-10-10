policytest {
  targets = ["cis_azure_foundations_v6:8.1.13.policy.hcl"]
}

resource "azurerm_security_center_contact" "pass_valid_email" {
  attrs = {
    name                = "default"
    email               = "security@contoso.com"
    alert_notifications = true
    alerts_to_admins    = true
  }
}

resource "azurerm_security_center_contact" "pass_multiple_emails" {
  attrs = {
    name                = "default"
    email               = "secops@contoso.com, soc@contoso.com"
    alert_notifications = true
    alerts_to_admins    = true
  }
}

resource "azurerm_security_center_contact" "pass_notifications_off" {
  attrs = {
    name                = "default"
    email               = "security@contoso.com"
    alert_notifications = false
    alerts_to_admins    = false
  }
}

resource "azurerm_security_center_contact" "fail_empty_email" {
  expect_failure = true
  attrs = {
    name                = "default"
    email               = ""
    alert_notifications = true
    alerts_to_admins    = true
  }
}

resource "azurerm_security_center_contact" "fail_whitespace_email" {
  expect_failure = true
  attrs = {
    name                = "default"
    email               = "   "
    alert_notifications = true
    alerts_to_admins    = true
  }
}

resource "azurerm_security_center_contact" "fail_invalid_email" {
  expect_failure = true
  attrs = {
    name                = "default"
    email               = "not-an-email"
    alert_notifications = true
    alerts_to_admins    = true
  }
}

resource "azurerm_security_center_contact" "fail_mixed_valid_and_invalid_emails" {
  expect_failure = true
  attrs = {
    name                = "default"
    email               = "security@contoso.com,invalid-email"
    alert_notifications = true
    alerts_to_admins    = true
  }
}

resource "azurerm_security_center_contact" "fail_trailing_empty_email" {
  expect_failure = true
  attrs = {
    name                = "default"
    email               = "security@contoso.com,"
    alert_notifications = true
    alerts_to_admins    = true
  }
}

resource "azurerm_security_center_contact" "pass_non_default_contact_out_of_scope" {
  attrs = {
    name                = "secondary"
    email               = ""
    alert_notifications = true
    alerts_to_admins    = true
  }
}

resource "azapi_resource" "pass_current_api_multiple_emails" {
  attrs = {
    type = "Microsoft.Security/securityContacts@2023-12-01-preview"
    name = "default"
    body = { properties = { emails = "security@contoso.com, soc@contoso.com" } }
  }
}

resource "azapi_resource" "pass_legacy_api_email" {
  attrs = {
    type = "Microsoft.Security/securityContacts@2020-01-01-preview"
    name = "default"
    body = { properties = { emails = "security@contoso.com" } }
  }
}

resource "azapi_resource" "fail_current_api_missing_email" {
  expect_failure = true
  attrs = {
    type = "Microsoft.Security/securityContacts@2023-12-01-preview"
    name = "default"
    body = { properties = {} }
  }
}

resource "azapi_resource" "fail_current_api_null_email" {
  expect_failure = true
  attrs = {
    type = "Microsoft.Security/securityContacts@2023-12-01-preview"
    name = "default"
    body = { properties = { emails = null } }
  }
}

resource "azapi_resource" "fail_current_api_empty_email" {
  expect_failure = true
  attrs = {
    type = "Microsoft.Security/securityContacts@2023-12-01-preview"
    name = "default"
    body = { properties = { emails = "" } }
  }
}

resource "azapi_resource" "fail_current_api_whitespace_email" {
  expect_failure = true
  attrs = {
    type = "Microsoft.Security/securityContacts@2023-12-01-preview"
    name = "default"
    body = { properties = { emails = "  " } }
  }
}

resource "azapi_resource" "fail_current_api_invalid_email" {
  expect_failure = true
  attrs = {
    type = "Microsoft.Security/securityContacts@2023-12-01-preview"
    name = "default"
    body = { properties = { emails = "not-an-email" } }
  }
}

resource "azapi_resource" "fail_current_api_mixed_emails" {
  expect_failure = true
  attrs = {
    type = "Microsoft.Security/securityContacts@2023-12-01-preview"
    name = "default"
    body = { properties = { emails = "security@contoso.com,invalid-email" } }
  }
}

resource "azapi_resource" "fail_current_api_trailing_empty_email" {
  expect_failure = true
  attrs = {
    type = "Microsoft.Security/securityContacts@2023-12-01-preview"
    name = "default"
    body = { properties = { emails = "security@contoso.com," } }
  }
}

resource "azapi_resource" "fail_unsupported_api_email" {
  expect_failure = true
  attrs = {
    type = "Microsoft.Security/securityContacts@2017-08-01-preview"
    name = "default"
    body = { properties = { emails = "security@contoso.com" } }
  }
}

resource "azapi_resource" "pass_non_default_azapi_contact" {
  attrs = {
    type = "Microsoft.Security/securityContacts@2023-12-01-preview"
    name = "secondary"
    body = { properties = { emails = "" } }
  }
}

resource "azapi_resource" "pass_unrelated_azapi_resource" {
  attrs = {
    type = "Microsoft.Security/pricings@2023-12-01-preview"
    name = "default"
    body = { properties = {} }
  }
}
