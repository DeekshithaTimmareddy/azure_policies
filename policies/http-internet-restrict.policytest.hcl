# Copyright IBM Corp. 2026

policytest {
  targets = ["http-internet-restrict.policy.hcl"]
}

resource "azurerm_network_security_group" "pass_security_rule_omitted" {
  attrs = {
    name                = "no-inline-rules"
    location            = "eastus"
    resource_group_name = "example-resource-group"
  }
}

resource "azurerm_network_security_group" "pass_security_rules_empty" {
  attrs = {
    name                = "empty-inline-rules"
    location            = "eastus"
    resource_group_name = "example-resource-group"
    security_rule       = []
  }
}

resource "azurerm_network_security_group" "pass_security_rules_null" {
  attrs = {
    name                = "null-inline-rules"
    location            = "eastus"
    resource_group_name = "example-resource-group"
    security_rule       = null
  }
}

resource "azurerm_network_security_group" "fail_https_from_any_ipv4" {
  expect_failure = true
  attrs = {
    name                = "public-https"
    location            = "eastus"
    resource_group_name = "example-resource-group"
    security_rule = [{
      name                       = "allow-public-https"
      priority                   = 100
      direction                  = "Inbound"
      access                     = "Allow"
      protocol                   = "Tcp"
      source_port_range          = "*"
      destination_port_range     = "443"
      destination_port_ranges    = []
      source_address_prefix      = "0.0.0.0/0"
      source_address_prefixes    = []
      destination_address_prefix = "*"
    }]
  }
}

resource "azurerm_network_security_group" "fail_range_includes_http" {
  expect_failure = true
  attrs = {
    name                = "public-http-range"
    location            = "eastus"
    resource_group_name = "example-resource-group"
    security_rule = [{
      name                       = "allow-public-http-range"
      priority                   = 110
      direction                  = "Inbound"
      access                     = "Allow"
      protocol                   = "*"
      source_port_range          = "*"
      destination_port_range     = "70-90"
      destination_port_ranges    = []
      source_address_prefix      = "Internet"
      source_address_prefixes    = []
      destination_address_prefix = "*"
    }]
  }
}

resource "azurerm_network_security_group" "fail_plural_ports_and_sources" {
  expect_failure = true
  attrs = {
    name                = "public-https-plural"
    location            = "eastus"
    resource_group_name = "example-resource-group"
    security_rule = [{
      name                       = "allow-public-https-plural"
      priority                   = 120
      direction                  = "Inbound"
      access                     = "Allow"
      protocol                   = "Tcp"
      source_port_range          = "*"
      destination_port_range     = null
      destination_port_ranges    = ["22", "443"]
      source_address_prefix      = null
      source_address_prefixes    = ["10.0.0.0/8", "*"]
      destination_address_prefix = "*"
    }]
  }
}

resource "azurerm_network_security_group" "pass_narrow_https_source" {
  attrs = {
    name                = "private-https"
    location            = "eastus"
    resource_group_name = "example-resource-group"
    security_rule = [{
      name                       = "allow-private-https"
      priority                   = 130
      direction                  = "Inbound"
      access                     = "Allow"
      protocol                   = "Tcp"
      source_port_range          = "*"
      destination_port_range     = "443"
      destination_port_ranges    = []
      source_address_prefix      = "10.0.0.0/24"
      source_address_prefixes    = []
      destination_address_prefix = "*"
    }]
  }
}

resource "azurerm_network_security_group" "pass_outbound_http" {
  attrs = {
    name                = "outbound-http"
    location            = "eastus"
    resource_group_name = "example-resource-group"
    security_rule = [{
      name                       = "allow-outbound-http"
      priority                   = 140
      direction                  = "Outbound"
      access                     = "Allow"
      protocol                   = "Tcp"
      source_port_range          = "*"
      destination_port_range     = "80"
      destination_port_ranges    = []
      source_address_prefix      = "*"
      source_address_prefixes    = []
      destination_address_prefix = "*"
    }]
  }
}

resource "azurerm_network_security_group" "pass_inbound_udp_http" {
  attrs = {
    name                = "udp-http"
    location            = "eastus"
    resource_group_name = "example-resource-group"
    security_rule = [{
      name                       = "allow-udp-http"
      priority                   = 150
      direction                  = "Inbound"
      access                     = "Allow"
      protocol                   = "Udp"
      source_port_range          = "*"
      destination_port_range     = "80"
      destination_port_ranges    = []
      source_address_prefix      = "*"
      source_address_prefixes    = []
      destination_address_prefix = "*"
    }]
  }
}

resource "azurerm_network_security_group" "pass_inbound_deny_https" {
  attrs = {
    name                = "deny-https"
    location            = "eastus"
    resource_group_name = "example-resource-group"
    security_rule = [{
      name                       = "deny-public-https"
      priority                   = 160
      direction                  = "Inbound"
      access                     = "Deny"
      protocol                   = "Tcp"
      source_port_range          = "*"
      destination_port_range     = "443"
      destination_port_ranges    = []
      source_address_prefix      = "*"
      source_address_prefixes    = []
      destination_address_prefix = "*"
    }]
  }
}

resource "azurerm_network_security_group" "fail_wildcard_destination_port" {
  expect_failure = true
  attrs = {
    name                = "wildcard-port-http"
    location            = "eastus"
    resource_group_name = "example-resource-group"
    security_rule = [{
      name                       = "allow-all-ports"
      priority                   = 170
      direction                  = "Inbound"
      access                     = "Allow"
      protocol                   = "Tcp"
      source_port_range          = "*"
      destination_port_range     = "*"
      destination_port_ranges    = []
      source_address_prefix      = "0.0.0.0/0"
      source_address_prefixes    = []
      destination_address_prefix = "*"
    }]
  }
}

resource "azurerm_network_security_group" "fail_wildcard_source_prefix" {
  expect_failure = true
  attrs = {
    name                = "wildcard-source-https"
    location            = "eastus"
    resource_group_name = "example-resource-group"
    security_rule = [{
      name                       = "allow-wildcard-source-https"
      priority                   = 180
      direction                  = "Inbound"
      access                     = "Allow"
      protocol                   = "Tcp"
      source_port_range          = "*"
      destination_port_range     = "443"
      destination_port_ranges    = []
      source_address_prefix      = "*"
      source_address_prefixes    = []
      destination_address_prefix = "*"
    }]
  }
}
