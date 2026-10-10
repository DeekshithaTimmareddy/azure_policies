policytest {
  targets = ["cis_azure_foundations_v6:7.13.policy.hcl"]
}

resource "azurerm_application_gateway" "pass_http2_enabled" {
  attrs = { http2_enabled = true }
}

resource "azurerm_application_gateway" "fail_http2_disabled" {
  expect_failure = true
  attrs = { http2_enabled = false }
}

resource "azurerm_application_gateway" "fail_known_null_http2" {
  expect_failure = true
  attrs = { http2_enabled = null }
}

resource "azurerm_application_gateway" "pass_unknown_http2_omitted_deferred" {
  attrs = { name = "unknown-http2" }
}

resource "azurerm_application_gateway" "fail_old_alias_cannot_override_false" {
  expect_failure = true
  attrs = { http2_enabled = false, enable_http2 = true }
}

resource "azurerm_application_gateway" "pass_old_alias_does_not_override_true" {
  attrs = { http2_enabled = true, enable_http2 = false }
}

resource "azurerm_application_gateway" "pass_standard_tier_enabled" {
  attrs = { http2_enabled = true, sku = [{ tier = "Standard_v2" }] }
}

resource "azurerm_application_gateway" "pass_waf_tier_enabled" {
  attrs = { http2_enabled = true, sku = [{ tier = "WAF_v2" }] }
}

resource "azurerm_application_gateway" "fail_http_listener_does_not_exempt_gateway" {
  expect_failure = true
  attrs = { http2_enabled = false, http_listener = [{ protocol = "Http" }] }
}

resource "azurerm_application_gateway" "fail_https_listener_does_not_enable_http2" {
  expect_failure = true
  attrs = { http2_enabled = false, http_listener = [{ protocol = "Https" }] }
}

resource "azurerm_application_gateway" "pass_http_listener_setting_only" {
  attrs = { http2_enabled = true, http_listener = [{ protocol = "Http" }] }
}

resource "azurerm_resource_group" "pass_unrelated" {
  attrs = { name = "rg-unrelated", location = "eastus" }
}
