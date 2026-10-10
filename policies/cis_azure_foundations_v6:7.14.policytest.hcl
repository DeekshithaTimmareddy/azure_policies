policytest {
  targets = ["cis_azure_foundations_v6:7.14.policy.hcl"]
}

resource "azurerm_web_application_firewall_policy" "pass-waf-true" {

  attrs = {
    id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg/providers/Microsoft.Network/ApplicationGatewayWebApplicationFirewallPolicies/pass-waf-true"
    location = "eastus"
    name = "pass-waf-true"
    resource_group_name = "rg"
    managed_rules = [{ managed_rule_set = [{ type = "OWASP", version = "3.2" }] }]
    policy_settings = [{ enabled = true, mode = "Prevention", request_body_check = true }]
  }
}
resource "azurerm_web_application_firewall_policy" "pass_unattached_waf_false" {
  attrs = {
    id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg/providers/Microsoft.Network/ApplicationGatewayWebApplicationFirewallPolicies/fail-waf-false"
    location = "eastus"
    name = "pass_unattached_waf_false"
    resource_group_name = "rg"
    managed_rules = [{ managed_rule_set = [{ type = "OWASP", version = "3.2" }] }]
    policy_settings = [{ enabled = true, mode = "Prevention", request_body_check = false }]
  }
}
resource "azurerm_web_application_firewall_policy" "pass-waf-absent" {

  attrs = {
    id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg/providers/Microsoft.Network/ApplicationGatewayWebApplicationFirewallPolicies/pass-waf-absent"
    location = "eastus"
    name = "pass-waf-absent"
    resource_group_name = "rg"
    managed_rules = [{ managed_rule_set = [{ type = "OWASP", version = "3.2" }] }]
    policy_settings = [{ enabled = true, mode = "Prevention" }]
  }
}
resource "azurerm_web_application_firewall_policy" "pass-waf-null" {

  attrs = {
    id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg/providers/Microsoft.Network/ApplicationGatewayWebApplicationFirewallPolicies/pass-waf-null"
    location = "eastus"
    name = "pass-waf-null"
    resource_group_name = "rg"
    managed_rules = [{ managed_rule_set = [{ type = "OWASP", version = "3.2" }] }]
    policy_settings = [{ enabled = true, mode = "Prevention", request_body_check = null }]
  }
}
resource "azurerm_web_application_firewall_policy" "pass-waf-no-settings" {

  attrs = {
    id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg/providers/Microsoft.Network/ApplicationGatewayWebApplicationFirewallPolicies/pass-waf-no-settings"
    location = "eastus"
    name = "pass-waf-no-settings"
    resource_group_name = "rg"
    managed_rules = [{ managed_rule_set = [{ type = "OWASP", version = "3.2" }] }]

  }
}
resource "azurerm_application_gateway" "pass_gw_inline_true" {

  attrs = {
    location = "eastus"
    name = "pass_gw_inline_true"
    resource_group_name = "rg"
    backend_address_pool = [{ name = "pool" }]
    backend_http_settings = [{ name = "hs", port = 80, protocol = "Http", cookie_based_affinity = "Disabled" }]
    frontend_ip_configuration = [{ name = "fe" }]
    frontend_port = [{ name = "fp", port = 80 }]
    gateway_ip_configuration = [{ name = "gw", subnet_id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg/providers/Microsoft.Network/virtualNetworks/vnet/subnets/sn" }]
    http_listener = [{ name = "l", frontend_ip_configuration_name = "fe", frontend_port_name = "fp", protocol = "Http" }]
    request_routing_rule = [{ name = "r", http_listener_name = "l", rule_type = "Basic", priority = 10 }]
    sku = [{ name = "WAF_v2", tier = "WAF_v2", capacity = 2 }]
    waf_configuration = [{ enabled = true, firewall_mode = "Prevention", rule_set_type = "OWASP", rule_set_version = "3.2", request_body_check = true }]
  }
}
resource "azurerm_application_gateway" "fail_gw_inline_false" {
  expect_failure = true
  attrs = {
    location = "eastus"
    name = "fail_gw_inline_false"
    resource_group_name = "rg"
    backend_address_pool = [{ name = "pool" }]
    backend_http_settings = [{ name = "hs", port = 80, protocol = "Http", cookie_based_affinity = "Disabled" }]
    frontend_ip_configuration = [{ name = "fe" }]
    frontend_port = [{ name = "fp", port = 80 }]
    gateway_ip_configuration = [{ name = "gw", subnet_id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg/providers/Microsoft.Network/virtualNetworks/vnet/subnets/sn" }]
    http_listener = [{ name = "l", frontend_ip_configuration_name = "fe", frontend_port_name = "fp", protocol = "Http" }]
    request_routing_rule = [{ name = "r", http_listener_name = "l", rule_type = "Basic", priority = 10 }]
    sku = [{ name = "WAF_v2", tier = "WAF_v2", capacity = 2 }]
    waf_configuration = [{ enabled = true, firewall_mode = "Prevention", rule_set_type = "OWASP", rule_set_version = "3.2", request_body_check = false }]
  }
}
resource "azurerm_application_gateway" "pass_gw_inline_absent" {

  attrs = {
    location = "eastus"
    name = "pass_gw_inline_absent"
    resource_group_name = "rg"
    backend_address_pool = [{ name = "pool" }]
    backend_http_settings = [{ name = "hs", port = 80, protocol = "Http", cookie_based_affinity = "Disabled" }]
    frontend_ip_configuration = [{ name = "fe" }]
    frontend_port = [{ name = "fp", port = 80 }]
    gateway_ip_configuration = [{ name = "gw", subnet_id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg/providers/Microsoft.Network/virtualNetworks/vnet/subnets/sn" }]
    http_listener = [{ name = "l", frontend_ip_configuration_name = "fe", frontend_port_name = "fp", protocol = "Http" }]
    request_routing_rule = [{ name = "r", http_listener_name = "l", rule_type = "Basic", priority = 10 }]
    sku = [{ name = "WAF_v2", tier = "WAF_v2", capacity = 2 }]
    waf_configuration = [{ enabled = true, firewall_mode = "Prevention", rule_set_type = "OWASP", rule_set_version = "3.2" }]
  }
}
resource "azurerm_application_gateway" "pass_gw_inline_null" {

  attrs = {
    location = "eastus"
    name = "pass_gw_inline_null"
    resource_group_name = "rg"
    backend_address_pool = [{ name = "pool" }]
    backend_http_settings = [{ name = "hs", port = 80, protocol = "Http", cookie_based_affinity = "Disabled" }]
    frontend_ip_configuration = [{ name = "fe" }]
    frontend_port = [{ name = "fp", port = 80 }]
    gateway_ip_configuration = [{ name = "gw", subnet_id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg/providers/Microsoft.Network/virtualNetworks/vnet/subnets/sn" }]
    http_listener = [{ name = "l", frontend_ip_configuration_name = "fe", frontend_port_name = "fp", protocol = "Http" }]
    request_routing_rule = [{ name = "r", http_listener_name = "l", rule_type = "Basic", priority = 10 }]
    sku = [{ name = "WAF_v2", tier = "WAF_v2", capacity = 2 }]
    waf_configuration = [{ enabled = true, firewall_mode = "Prevention", rule_set_type = "OWASP", rule_set_version = "3.2", request_body_check = null }]
  }
}
resource "azurerm_web_application_firewall_policy" "waf-linked-ok" {

  attrs = {
    id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg/providers/Microsoft.Network/ApplicationGatewayWebApplicationFirewallPolicies/waf-linked-ok"
    location = "eastus"
    name = "waf-linked-ok"
    resource_group_name = "rg"
    managed_rules = [{ managed_rule_set = [{ type = "OWASP", version = "3.2" }] }]
    policy_settings = [{ enabled = true, mode = "Prevention", request_body_check = true }]
  }
}
resource "azurerm_application_gateway" "pass_gw_linked_ok" {

  attrs = {
    location = "eastus"
    name = "pass_gw_linked_ok"
    resource_group_name = "rg"
    backend_address_pool = [{ name = "pool" }]
    backend_http_settings = [{ name = "hs", port = 80, protocol = "Http", cookie_based_affinity = "Disabled" }]
    frontend_ip_configuration = [{ name = "fe" }]
    frontend_port = [{ name = "fp", port = 80 }]
    gateway_ip_configuration = [{ name = "gw", subnet_id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg/providers/Microsoft.Network/virtualNetworks/vnet/subnets/sn" }]
    http_listener = [{ name = "l", frontend_ip_configuration_name = "fe", frontend_port_name = "fp", protocol = "Http" }]
    request_routing_rule = [{ name = "r", http_listener_name = "l", rule_type = "Basic", priority = 10 }]
    sku = [{ name = "WAF_v2", tier = "WAF_v2", capacity = 2 }]
    firewall_policy_id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg/providers/Microsoft.Network/ApplicationGatewayWebApplicationFirewallPolicies/waf-linked-ok"
  }
}
resource "azurerm_web_application_firewall_policy" "waf-linked-bad" {
  attrs = {
    id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg/providers/Microsoft.Network/ApplicationGatewayWebApplicationFirewallPolicies/waf-linked-bad"
    location = "eastus"
    name = "waf-linked-bad"
    resource_group_name = "rg"
    managed_rules = [{ managed_rule_set = [{ type = "OWASP", version = "3.2" }] }]
    policy_settings = [{ enabled = true, mode = "Prevention", request_body_check = false }]
  }
}
resource "azurerm_application_gateway" "fail_gw_linked_bad" {
  expect_failure = true
  attrs = {
    location = "eastus"
    name = "fail_gw_linked_bad"
    resource_group_name = "rg"
    backend_address_pool = [{ name = "pool" }]
    backend_http_settings = [{ name = "hs", port = 80, protocol = "Http", cookie_based_affinity = "Disabled" }]
    frontend_ip_configuration = [{ name = "fe" }]
    frontend_port = [{ name = "fp", port = 80 }]
    gateway_ip_configuration = [{ name = "gw", subnet_id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg/providers/Microsoft.Network/virtualNetworks/vnet/subnets/sn" }]
    http_listener = [{ name = "l", frontend_ip_configuration_name = "fe", frontend_port_name = "fp", protocol = "Http" }]
    request_routing_rule = [{ name = "r", http_listener_name = "l", rule_type = "Basic", priority = 10 }]
    sku = [{ name = "WAF_v2", tier = "WAF_v2", capacity = 2 }]
    firewall_policy_id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg/providers/Microsoft.Network/ApplicationGatewayWebApplicationFirewallPolicies/waf-linked-bad"
  }
}
resource "azurerm_web_application_firewall_policy" "waf-linked-absent" {

  attrs = {
    id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg/providers/Microsoft.Network/ApplicationGatewayWebApplicationFirewallPolicies/waf-linked-absent"
    location = "eastus"
    name = "waf-linked-absent"
    resource_group_name = "rg"
    managed_rules = [{ managed_rule_set = [{ type = "OWASP", version = "3.2" }] }]
    policy_settings = [{ enabled = true, mode = "Prevention" }]
  }
}
resource "azurerm_application_gateway" "pass_gw_linked_absent" {

  attrs = {
    location = "eastus"
    name = "pass_gw_linked_absent"
    resource_group_name = "rg"
    backend_address_pool = [{ name = "pool" }]
    backend_http_settings = [{ name = "hs", port = 80, protocol = "Http", cookie_based_affinity = "Disabled" }]
    frontend_ip_configuration = [{ name = "fe" }]
    frontend_port = [{ name = "fp", port = 80 }]
    gateway_ip_configuration = [{ name = "gw", subnet_id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg/providers/Microsoft.Network/virtualNetworks/vnet/subnets/sn" }]
    http_listener = [{ name = "l", frontend_ip_configuration_name = "fe", frontend_port_name = "fp", protocol = "Http" }]
    request_routing_rule = [{ name = "r", http_listener_name = "l", rule_type = "Basic", priority = 10 }]
    sku = [{ name = "WAF_v2", tier = "WAF_v2", capacity = 2 }]
    firewall_policy_id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg/providers/Microsoft.Network/ApplicationGatewayWebApplicationFirewallPolicies/waf-linked-absent"
  }
}
resource "azurerm_application_gateway" "pass_gw_no_waf" {

  attrs = {
    location = "eastus"
    name = "pass_gw_no_waf"
    resource_group_name = "rg"
    backend_address_pool = [{ name = "pool" }]
    backend_http_settings = [{ name = "hs", port = 80, protocol = "Http", cookie_based_affinity = "Disabled" }]
    frontend_ip_configuration = [{ name = "fe" }]
    frontend_port = [{ name = "fp", port = 80 }]
    gateway_ip_configuration = [{ name = "gw", subnet_id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg/providers/Microsoft.Network/virtualNetworks/vnet/subnets/sn" }]
    http_listener = [{ name = "l", frontend_ip_configuration_name = "fe", frontend_port_name = "fp", protocol = "Http" }]
    request_routing_rule = [{ name = "r", http_listener_name = "l", rule_type = "Basic", priority = 10 }]
    sku = [{ name = "WAF_v2", tier = "WAF_v2", capacity = 2 }]

  }
}
# Generated by Terraform Policy Agent 0.1.4
