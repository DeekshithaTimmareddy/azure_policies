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
