policytest {
  targets = ["cis_azure_foundations_v6:7.10.policy.hcl"]
}

resource "azurerm_web_application_firewall_policy" "pass_enabled_policy" {
  attrs = {
    id = "/subscriptions/sub/resourceGroups/rg/providers/Microsoft.Network/applicationGatewayWebApplicationFirewallPolicies/enabled"
    policy_settings = [{ enabled = true }]
  }
}

resource "azurerm_web_application_firewall_policy" "pass_disabled_policy_not_gateway_anchor" {
  attrs = {
    id = "/subscriptions/sub/resourceGroups/rg/providers/Microsoft.Network/applicationGatewayWebApplicationFirewallPolicies/disabled"
    policy_settings = [{ enabled = false }]
  }
}

resource "azurerm_web_application_firewall_policy" "pass_default_enabled_policy" {
  attrs = {
    id = "/subscriptions/sub/resourceGroups/rg/providers/Microsoft.Network/applicationGatewayWebApplicationFirewallPolicies/default"
    policy_settings = [{}]
  }
}

resource "azurerm_web_application_firewall_policy" "pass_null_enabled_policy" {
  attrs = {
    id = "/subscriptions/sub/resourceGroups/rg/providers/Microsoft.Network/applicationGatewayWebApplicationFirewallPolicies/null"
    policy_settings = [{ enabled = null }]
  }
}

resource "azurerm_web_application_firewall_policy" "pass_unconfigured_settings_policy" {
  attrs = {
    id = "/subscriptions/sub/resourceGroups/rg/providers/Microsoft.Network/applicationGatewayWebApplicationFirewallPolicies/no-settings"
  }
}

resource "azurerm_web_application_firewall_policy" "pass_unknown_id_disabled_policy_deferred" {
  attrs = { policy_settings = [{ enabled = false }] }
}

resource "azurerm_web_application_firewall_policy" "pass_same_name_other_rg_disabled_policy" {
  attrs = {
    id = "/subscriptions/sub/resourceGroups/other/providers/Microsoft.Network/applicationGatewayWebApplicationFirewallPolicies/enabled"
    policy_settings = [{ enabled = false }]
  }
}

resource "azurerm_web_application_firewall_policy" "pass_same_name_other_subscription_disabled_policy" {
  attrs = {
    id = "/subscriptions/other/resourceGroups/rg/providers/Microsoft.Network/applicationGatewayWebApplicationFirewallPolicies/enabled"
    policy_settings = [{ enabled = false }]
  }
}

resource "azurerm_application_gateway" "pass_detection_mode_no_added_prevention_requirement" {
  attrs = {
    sku = [{ tier = "WAF_v2" }]
    firewall_policy_id = "/subscriptions/sub/resourceGroups/rg/providers/Microsoft.Network/applicationGatewayWebApplicationFirewallPolicies/detection"
  }
}

resource "azurerm_web_application_firewall_policy" "pass_detection_mode_enabled_policy" {
  attrs = {
    id = "/subscriptions/sub/resourceGroups/rg/providers/Microsoft.Network/applicationGatewayWebApplicationFirewallPolicies/detection"
    policy_settings = [{ enabled = true, mode = "Detection", request_body_check = false }]
  }
}

resource "azurerm_application_gateway" "pass_enabled_linked_policy" {
  attrs = {
    sku = [{ tier = "WAF_v2" }]
    firewall_policy_id = "/subscriptions/sub/resourceGroups/rg/providers/Microsoft.Network/applicationGatewayWebApplicationFirewallPolicies/enabled"
  }
}

resource "azurerm_application_gateway" "pass_external_policy_state_unverified" {
  attrs = {
    sku = [{ tier = "WAF_v2" }]
    firewall_policy_id = "/subscriptions/sub/resourceGroups/rg/providers/Microsoft.Network/applicationGatewayWebApplicationFirewallPolicies/external"
  }
}

resource "azurerm_application_gateway" "pass_default_enabled_linked_policy" {
  attrs = {
    sku = [{ tier = "WAF_v2" }]
    firewall_policy_id = "/subscriptions/sub/resourceGroups/rg/providers/Microsoft.Network/applicationGatewayWebApplicationFirewallPolicies/default"
  }
}

resource "azurerm_application_gateway" "pass_null_enabled_linked_policy_deferred" {
  attrs = {
    sku = [{ tier = "WAF_v2" }]
    firewall_policy_id = "/subscriptions/sub/resourceGroups/rg/providers/Microsoft.Network/applicationGatewayWebApplicationFirewallPolicies/null"
  }
}

resource "azurerm_application_gateway" "pass_no_settings_linked_policy" {
  attrs = {
    sku = [{ tier = "WAF_v2" }]
    firewall_policy_id = "/subscriptions/sub/resourceGroups/rg/providers/Microsoft.Network/applicationGatewayWebApplicationFirewallPolicies/no-settings"
  }
}

resource "azurerm_application_gateway" "pass_mixed_case_reference" {
  attrs = {
    sku = [{ tier = "WAF_v2" }]
    firewall_policy_id = "/SUBSCRIPTIONS/SUB/RESOURCEGROUPS/RG/PROVIDERS/MICROSOFT.NETWORK/APPLICATIONGATEWAYWEBAPPLICATIONFIREWALLPOLICIES/ENABLED"
  }
}

resource "azurerm_application_gateway" "pass_reference_surrounding_whitespace_trailing_slash" {
  attrs = {
    sku = [{ tier = "WAF_v2" }]
    firewall_policy_id = " /subscriptions/sub/resourceGroups/rg/providers/Microsoft.Network/applicationGatewayWebApplicationFirewallPolicies/enabled/ "
  }
}

resource "azurerm_application_gateway" "pass_unknown_reference_omitted_deferred" {
  attrs = { sku = [{ tier = "WAF_v2" }] }
}

resource "azurerm_application_gateway" "pass_unknown_tier_deferred" {
  attrs = {
    sku = [{ tier = null }]
    firewall_policy_id = "/subscriptions/sub/resourceGroups/rg/providers/Microsoft.Network/applicationGatewayWebApplicationFirewallPolicies/enabled"
  }
}

resource "azurerm_application_gateway" "fail_standard_v2_with_policy" {
  expect_failure = true
  attrs = {
    sku = [{ tier = "Standard_v2" }]
    firewall_policy_id = "/subscriptions/sub/resourceGroups/rg/providers/Microsoft.Network/applicationGatewayWebApplicationFirewallPolicies/enabled"
  }
}

resource "azurerm_application_gateway" "fail_basic_with_policy" {
  expect_failure = true
  attrs = {
    sku = [{ tier = "Basic" }]
    firewall_policy_id = "/subscriptions/sub/resourceGroups/rg/providers/Microsoft.Network/applicationGatewayWebApplicationFirewallPolicies/enabled"
  }
}

resource "azurerm_application_gateway" "fail_legacy_waf_tier_with_policy" {
  expect_failure = true
  attrs = {
    sku = [{ tier = "WAF" }]
    firewall_policy_id = "/subscriptions/sub/resourceGroups/rg/providers/Microsoft.Network/applicationGatewayWebApplicationFirewallPolicies/enabled"
  }
}

resource "azurerm_application_gateway" "fail_empty_tier" {
  expect_failure = true
  attrs = {
    sku = [{ tier = "" }]
    firewall_policy_id = "/subscriptions/sub/resourceGroups/rg/providers/Microsoft.Network/applicationGatewayWebApplicationFirewallPolicies/enabled"
  }
}

resource "azurerm_application_gateway" "fail_known_null_reference" {
  expect_failure = true
  attrs = { sku = [{ tier = "WAF_v2" }], firewall_policy_id = null }
}

resource "azurerm_application_gateway" "fail_empty_reference" {
  expect_failure = true
  attrs = { sku = [{ tier = "WAF_v2" }], firewall_policy_id = "" }
}

resource "azurerm_application_gateway" "fail_whitespace_reference" {
  expect_failure = true
  attrs = { sku = [{ tier = "WAF_v2" }], firewall_policy_id = " \t " }
}

resource "azurerm_application_gateway" "fail_malformed_reference" {
  expect_failure = true
  attrs = { sku = [{ tier = "WAF_v2" }], firewall_policy_id = "not-an-arm-id" }
}

resource "azurerm_application_gateway" "fail_wrong_resource_reference" {
  expect_failure = true
  attrs = {
    sku = [{ tier = "WAF_v2" }]
    firewall_policy_id = "/subscriptions/sub/resourceGroups/rg/providers/Microsoft.Network/networkSecurityGroups/nsg"
  }
}

resource "azurerm_application_gateway" "fail_disabled_linked_policy" {
  expect_failure = true
  attrs = {
    sku = [{ tier = "WAF_v2" }]
    firewall_policy_id = "/subscriptions/sub/resourceGroups/rg/providers/Microsoft.Network/applicationGatewayWebApplicationFirewallPolicies/disabled"
  }
}

resource "azurerm_application_gateway" "fail_disabled_linked_policy_mixed_case" {
  expect_failure = true
  attrs = {
    sku = [{ tier = "WAF_v2" }]
    firewall_policy_id = "/SUBSCRIPTIONS/SUB/RESOURCEGROUPS/RG/PROVIDERS/MICROSOFT.NETWORK/APPLICATIONGATEWAYWEBAPPLICATIONFIREWALLPOLICIES/DISABLED"
  }
}

resource "azurerm_application_gateway" "fail_disabled_linked_policy_whitespace_slash" {
  expect_failure = true
  attrs = {
    sku = [{ tier = "WAF_v2" }]
    firewall_policy_id = " /subscriptions/sub/resourceGroups/rg/providers/Microsoft.Network/applicationGatewayWebApplicationFirewallPolicies/disabled/ "
  }
}

resource "azurerm_application_gateway" "fail_inline_only_known_no_policy" {
  expect_failure = true
  attrs = {
    sku = [{ tier = "WAF_v2" }]
    firewall_policy_id = null
    waf_configuration = [{ enabled = true }]
  }
}

resource "azurerm_application_gateway" "fail_listener_only_policy" {
  expect_failure = true
  attrs = {
    sku = [{ tier = "WAF_v2" }]
    firewall_policy_id = null
    http_listener = [{ firewall_policy_id = "/subscriptions/sub/resourceGroups/rg/providers/Microsoft.Network/applicationGatewayWebApplicationFirewallPolicies/enabled" }]
  }
}

resource "azurerm_application_gateway" "fail_path_only_policy" {
  expect_failure = true
  attrs = {
    sku = [{ tier = "WAF_v2" }]
    firewall_policy_id = null
    url_path_map = [{ path_rule = [{ firewall_policy_id = "/subscriptions/sub/resourceGroups/rg/providers/Microsoft.Network/applicationGatewayWebApplicationFirewallPolicies/enabled" }] }]
  }
}

resource "azurerm_application_gateway" "fail_inline_enabled_cannot_override_disabled_policy" {
  expect_failure = true
  attrs = {
    sku = [{ tier = "WAF_v2" }]
    firewall_policy_id = "/subscriptions/sub/resourceGroups/rg/providers/Microsoft.Network/applicationGatewayWebApplicationFirewallPolicies/disabled"
    waf_configuration = [{ enabled = true }]
  }
}

resource "azurerm_resource_group" "pass_unrelated" {
  attrs = { name = "rg-unrelated", location = "eastus" }
}
