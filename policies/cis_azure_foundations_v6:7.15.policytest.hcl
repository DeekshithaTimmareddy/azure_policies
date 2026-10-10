policytest {
  targets = ["cis_azure_foundations_v6:7.15.policy.hcl"]
}

resource "azurerm_application_gateway" "pass_standard_gateway_out_of_scope" {
  attrs = {
    sku = [{ name = "Standard_v2", tier = "Standard_v2" }]
  }
}

resource "azurerm_application_gateway" "pass_legacy_waf_v1_out_of_scope" {
  attrs = {
    sku = [{ name = "WAF_v2", tier = "WAF" }]
  }
}

resource "azurerm_web_application_firewall_policy" "pass_bot_only_policy" {
  attrs = {
    id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg/providers/Microsoft.Network/ApplicationGatewayWebApplicationFirewallPolicies/bot-only"
    managed_rules = [{ managed_rule_set = [{ type = "Microsoft_BotManagerRuleSet", version = "1.0" }] }]
  }
}

resource "azurerm_application_gateway" "pass_bot_only" {
  attrs = {
    sku               = [{ name = "WAF_v2", tier = "WAF_v2" }]
    firewall_policy_id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg/providers/Microsoft.Network/ApplicationGatewayWebApplicationFirewallPolicies/bot-only"
  }
}

resource "azurerm_web_application_firewall_policy" "pass_owasp_and_bot_policy" {
  attrs = {
    id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg/providers/Microsoft.Network/ApplicationGatewayWebApplicationFirewallPolicies/owasp-and-bot"
    managed_rules = [{ managed_rule_set = [{ type = "OWASP", version = "3.2" }, { type = "Microsoft_BotManagerRuleSet", version = "1.0" }] }]
  }
}

resource "azurerm_application_gateway" "pass_owasp_and_bot" {
  attrs = {
    sku               = [{ name = "WAF_v2", tier = "WAF_v2" }]
    firewall_policy_id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg/providers/Microsoft.Network/ApplicationGatewayWebApplicationFirewallPolicies/owasp-and-bot"
  }
}

resource "azurerm_web_application_firewall_policy" "pass_knownbadbots_enabled_policy" {
  attrs = {
    id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg/providers/Microsoft.Network/ApplicationGatewayWebApplicationFirewallPolicies/knownbad-enabled"
    managed_rules = [{ managed_rule_set = [{ type = "Microsoft_BotManagerRuleSet", version = "1.0", rule_group_override = [{ rule_group_name = "KnownBadBots", rule = [{ id = "Bot100100", enabled = true }] }] }] }]
  }
}

resource "azurerm_application_gateway" "pass_knownbadbots_enabled" {
  attrs = {
    sku               = [{ name = "WAF_v2", tier = "WAF_v2" }]
    firewall_policy_id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg/providers/Microsoft.Network/ApplicationGatewayWebApplicationFirewallPolicies/knownbad-enabled"
  }
}

resource "azurerm_web_application_firewall_policy" "pass_goodbots_disabled_policy" {
  attrs = {
    id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg/providers/Microsoft.Network/ApplicationGatewayWebApplicationFirewallPolicies/goodbots-disabled"
    managed_rules = [{ managed_rule_set = [{ type = "Microsoft_BotManagerRuleSet", version = "1.0", rule_group_override = [{ rule_group_name = "GoodBots", rule = [{ id = "Bot200100", enabled = false }] }] }] }]
  }
}

resource "azurerm_application_gateway" "pass_goodbots_disabled" {
  attrs = {
    sku               = [{ name = "WAF_v2", tier = "WAF_v2" }]
    firewall_policy_id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg/providers/Microsoft.Network/ApplicationGatewayWebApplicationFirewallPolicies/goodbots-disabled"
  }
}

resource "azurerm_web_application_firewall_policy" "fail_owasp_only_policy" {
  attrs = {
    id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg/providers/Microsoft.Network/ApplicationGatewayWebApplicationFirewallPolicies/owasp-only"
    managed_rules = [{ managed_rule_set = [{ type = "OWASP", version = "3.2" }] }]
  }
}

resource "azurerm_application_gateway" "fail_owasp_only" {
  expect_failure = true
  attrs = {
    sku               = [{ name = "WAF_v2", tier = "WAF_v2" }]
    firewall_policy_id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg/providers/Microsoft.Network/ApplicationGatewayWebApplicationFirewallPolicies/owasp-only"
  }
}

resource "azurerm_web_application_firewall_policy" "fail_knownbadbots_disabled_policy" {
  attrs = {
    id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg/providers/Microsoft.Network/ApplicationGatewayWebApplicationFirewallPolicies/knownbad-disabled"
    managed_rules = [{ managed_rule_set = [{ type = "Microsoft_BotManagerRuleSet", version = "1.0", rule_group_override = [{ rule_group_name = "KnownBadBots", rule = [{ id = "Bot100100", enabled = true }, { id = "Bot100200", enabled = false }] }] }] }]
  }
}

resource "azurerm_application_gateway" "fail_knownbadbots_disabled" {
  expect_failure = true
  attrs = {
    sku               = [{ name = "WAF_v2", tier = "WAF_v2" }]
    firewall_policy_id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg/providers/Microsoft.Network/ApplicationGatewayWebApplicationFirewallPolicies/knownbad-disabled"
  }
}

resource "azurerm_web_application_firewall_policy" "fail_knownbadbots_default_disabled_policy" {
  attrs = {
    id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg/providers/Microsoft.Network/ApplicationGatewayWebApplicationFirewallPolicies/knownbad-default-disabled"
    managed_rules = [{ managed_rule_set = [{ type = "Microsoft_BotManagerRuleSet", version = "1.0", rule_group_override = [{ rule_group_name = "KnownBadBots", rule = [{ id = "Bot100100" }] }] }] }]
  }
}

resource "azurerm_application_gateway" "fail_knownbadbots_default_disabled" {
  expect_failure = true
  attrs = {
    sku               = [{ name = "WAF_v2", tier = "WAF_v2" }]
    firewall_policy_id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg/providers/Microsoft.Network/ApplicationGatewayWebApplicationFirewallPolicies/knownbad-default-disabled"
  }
}

resource "azurerm_web_application_firewall_policy" "fail_knownbadbots_null_disabled_policy" {
  attrs = {
    id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg/providers/Microsoft.Network/ApplicationGatewayWebApplicationFirewallPolicies/knownbad-null-disabled"
    managed_rules = [{ managed_rule_set = [{ type = "Microsoft_BotManagerRuleSet", version = "1.0", rule_group_override = [{ rule_group_name = "KnownBadBots", rule = [{ id = "Bot100100", enabled = null }] }] }] }]
  }
}

resource "azurerm_application_gateway" "fail_knownbadbots_null_disabled" {
  expect_failure = true
  attrs = {
    sku               = [{ name = "WAF_v2", tier = "WAF_v2" }]
    firewall_policy_id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg/providers/Microsoft.Network/ApplicationGatewayWebApplicationFirewallPolicies/knownbad-null-disabled"
  }
}

resource "azurerm_web_application_firewall_policy" "fail_managed_rule_set_type_default_policy" {
  attrs = {
    id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg/providers/Microsoft.Network/ApplicationGatewayWebApplicationFirewallPolicies/type-defaults-owasp"
    managed_rules = [{ managed_rule_set = [{ version = "3.2" }] }]
  }
}

resource "azurerm_application_gateway" "fail_managed_rule_set_type_default" {
  expect_failure = true
  attrs = {
    sku               = [{ name = "WAF_v2", tier = "WAF_v2" }]
    firewall_policy_id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg/providers/Microsoft.Network/ApplicationGatewayWebApplicationFirewallPolicies/type-defaults-owasp"
  }
}

resource "azurerm_application_gateway" "pass_deferred_no_policy_link" {
  attrs = {
    sku = [{ name = "WAF_v2", tier = "WAF_v2" }]
  }
}

resource "azurerm_application_gateway" "pass_deferred_external_policy" {
  attrs = {
    sku               = [{ name = "WAF_v2", tier = "WAF_v2" }]
    firewall_policy_id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/external/providers/Microsoft.Network/ApplicationGatewayWebApplicationFirewallPolicies/not-in-plan"
  }
}

resource "azurerm_application_gateway" "fail_inline_waf_without_bot_policy" {
  expect_failure = true
  attrs = {
    sku = [{ name = "WAF_v2", tier = "WAF_v2" }]
    waf_configuration = [{ enabled = true, firewall_mode = "Prevention", rule_set_type = "OWASP", rule_set_version = "3.2" }]
  }
}
