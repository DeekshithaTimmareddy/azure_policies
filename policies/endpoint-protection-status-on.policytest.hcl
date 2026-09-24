policytest {
  targets = ["endpoint-protection-status-on.policy.hcl"]
}

resource "azurerm_security_center_setting" "wdatp_enabled" {
  attrs = {
    setting_name = "WDATP"
    enabled      = true
  }
}

resource "azurerm_security_center_setting" "wdatp_disabled" {
  expect_failure = true
  attrs = {
    setting_name = "WDATP"
    enabled      = false
  }
}

resource "azurerm_security_center_setting" "wdatp_unified_enabled" {
  attrs = {
    setting_name = "WDATP_UNIFIED_SOLUTION"
    enabled      = true
  }
}

resource "azurerm_security_center_setting" "wdatp_unified_disabled" {
  expect_failure = true
  attrs = {
    setting_name = "WDATP_UNIFIED_SOLUTION"
    enabled      = false
  }
}

resource "azurerm_security_center_setting" "mcas_disabled" {
  attrs = {
    setting_name = "MCAS"
    enabled      = false
  }
}

resource "azurerm_security_center_setting" "sentinel_disabled" {
  attrs = {
    setting_name = "Sentinel"
    enabled      = false
  }
}

resource "azurerm_security_center_setting" "current_disabled" {
  attrs = {
    setting_name = "current"
    enabled      = false
  }
}

resource "azurerm_security_center_setting" "setting_name_null_out_of_scope" {
  attrs = {
    setting_name = null
    enabled      = false
  }
}
