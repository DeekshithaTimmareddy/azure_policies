# Copyright IBM Corp. 2026

policytest {
  targets = ["udp-port-access-restrict.policy.hcl"]
}

resource "azurerm_network_security_group" "pass_no_inline_rules" {
  attrs = {
    name                = "pass-no-inline-rules"
    location            = "East US"
    resource_group_name = "validation-resource-group"
    security_rule       = []
  }
}

resource "azurerm_network_security_group" "fail_udp_port_53_from_anywhere" {
  expect_failure = true
  attrs = {
    name                = "fail-udp-port-53"
    location            = "East US"
    resource_group_name = "validation-resource-group"
    security_rule = [{
      name                       = "dns-from-internet"
      priority                   = 100
      direction                  = "Inbound"
      access                     = "Allow"
      protocol                   = "Udp"
      source_port_range          = "*"
      destination_port_range     = "53"
      source_address_prefix      = "0.0.0.0/0"
      destination_address_prefix = "*"
    }]
  }
}

# The optional singular source and destination attributes are deliberately
# omitted while their plural alternatives provide a valid, violating rule.
resource "azurerm_network_security_group" "fail_any_protocol_plural_range" {
  expect_failure = true
  attrs = {
    name                = "fail-any-protocol-plural-range"
    location            = "East US"
    resource_group_name = "validation-resource-group"
    security_rule = [{
      name                         = "ntp-range-from-internet"
      priority                     = 110
      direction                    = "Inbound"
      access                       = "Allow"
      protocol                     = "*"
      source_port_range            = "*"
      destination_port_ranges      = ["120-125", "443"]
      source_address_prefixes      = ["10.0.0.0/8", "Internet"]
      destination_address_prefixes = ["*"]
    }]
  }
}

resource "azurerm_network_security_group" "fail_range_lower_boundary_1900" {
  expect_failure = true
  attrs = {
    name                = "fail-range-lower-boundary"
    location            = "East US"
    resource_group_name = "validation-resource-group"
    security_rule = [{
      name                       = "ssdp-range-from-anywhere"
      priority                   = 120
      direction                  = "Inbound"
      access                     = "Allow"
      protocol                   = "Udp"
      source_port_range          = "*"
      destination_port_range     = "1900-2000"
      source_address_prefix      = "*"
      destination_address_prefix = "*"
    }]
  }
}

resource "azurerm_network_security_group" "pass_deny_rule" {
  attrs = {
    name                = "pass-deny-rule"
    location            = "East US"
    resource_group_name = "validation-resource-group"
    security_rule = [{
      name                       = "deny-snmp"
      priority                   = 130
      direction                  = "Inbound"
      access                     = "Deny"
      protocol                   = "Udp"
      source_port_range          = "*"
      destination_port_range     = "161"
      source_address_prefix      = "Internet"
      destination_address_prefix = "*"
    }]
  }
}

resource "azurerm_network_security_group" "pass_outbound_rule" {
  attrs = {
    name                = "pass-outbound-rule"
    location            = "East US"
    resource_group_name = "validation-resource-group"
    security_rule = [{
      name                       = "outbound-ldap"
      priority                   = 140
      direction                  = "Outbound"
      access                     = "Allow"
      protocol                   = "Udp"
      source_port_range          = "*"
      destination_port_range     = "389"
      source_address_prefix      = "Internet"
      destination_address_prefix = "*"
    }]
  }
}

resource "azurerm_network_security_group" "pass_tcp_rule" {
  attrs = {
    name                = "pass-tcp-rule"
    location            = "East US"
    resource_group_name = "validation-resource-group"
    security_rule = [{
      name                       = "tcp-dns"
      priority                   = 150
      direction                  = "Inbound"
      access                     = "Allow"
      protocol                   = "Tcp"
      source_port_range          = "*"
      destination_port_range     = "53"
      source_address_prefix      = "Internet"
      destination_address_prefix = "*"
    }]
  }
}

resource "azurerm_network_security_group" "pass_unrestricted_port" {
  attrs = {
    name                = "pass-unrestricted-port"
    location            = "East US"
    resource_group_name = "validation-resource-group"
    security_rule = [{
      name                       = "https-udp"
      priority                   = 160
      direction                  = "Inbound"
      access                     = "Allow"
      protocol                   = "Udp"
      source_port_range          = "*"
      destination_port_range     = "443"
      source_address_prefix      = "Internet"
      destination_address_prefix = "*"
    }]
  }
}

resource "azurerm_network_security_group" "pass_private_source" {
  attrs = {
    name                = "pass-private-source"
    location            = "East US"
    resource_group_name = "validation-resource-group"
    security_rule = [{
      name                       = "private-dns"
      priority                   = 170
      direction                  = "Inbound"
      access                     = "Allow"
      protocol                   = "Udp"
      source_port_range          = "*"
      destination_port_range     = "53"
      source_address_prefix      = "10.0.0.0/8"
      destination_address_prefix = "*"
    }]
  }
}

# security_rule uses the policy's two-step null normalization and is therefore
# expected to behave like an empty collection.
resource "azurerm_network_security_group" "pass_null_inline_rules" {
  attrs = {
    name                = "pass-null-inline-rules"
    location            = "East US"
    resource_group_name = "validation-resource-group"
    security_rule       = null
  }
}

resource "azurerm_network_security_group" "fail_wildcard_destination_port" {
  expect_failure = true
  attrs = {
    name                = "fail-wildcard-destination-port"
    location            = "East US"
    resource_group_name = "validation-resource-group"
    security_rule = [{
      name                       = "all-udp-from-internet"
      priority                   = 180
      direction                  = "Inbound"
      access                     = "Allow"
      protocol                   = "Udp"
      source_port_range          = "*"
      destination_port_range     = "*"
      source_address_prefix      = "Internet"
      destination_address_prefix = "*"
    }]
  }
}

resource "azurerm_network_security_group" "fail_wildcard_source_prefix" {
  expect_failure = true
  attrs = {
    name                = "fail-wildcard-source-prefix"
    location            = "East US"
    resource_group_name = "validation-resource-group"
    security_rule = [{
      name                       = "udp-dns-wildcard-source"
      priority                   = 190
      direction                  = "Inbound"
      access                     = "Allow"
      protocol                   = "Udp"
      source_port_range          = "*"
      destination_port_range     = "53"
      source_address_prefix      = "*"
      destination_address_prefix = "*"
    }]
  }
}

resource "azurerm_network_security_group" "fail_singular_range_covers_port" {
  expect_failure = true
  attrs = {
    name                = "fail-singular-range-covers-port"
    location            = "East US"
    resource_group_name = "validation-resource-group"
    security_rule = [{
      name                       = "udp-range-covers-dns"
      priority                   = 220
      direction                  = "Inbound"
      access                     = "Allow"
      protocol                   = "Udp"
      source_port_range          = "*"
      destination_port_range     = "50-100"
      source_address_prefix      = "0.0.0.0/0"
      destination_address_prefix = "*"
    }]
  }
}

resource "azurerm_network_security_group" "fail_inclusive_boundary" {
  expect_failure = true
  attrs = {
    name                = "fail-inclusive-boundary"
    location            = "East US"
    resource_group_name = "validation-resource-group"
    security_rule = [{
      name                       = "udp-dns-range-boundary"
      priority                   = 230
      direction                  = "Inbound"
      access                     = "Allow"
      protocol                   = "Udp"
      source_port_range          = "*"
      destination_port_range     = "53-53"
      source_address_prefix      = "0.0.0.0/0"
      destination_address_prefix = "*"
    }]
  }
}

resource "azurerm_network_security_group" "pass_range_outside_restricted_ports" {
  attrs = {
    name                = "pass-range-outside-restricted-ports"
    location            = "East US"
    resource_group_name = "validation-resource-group"
    security_rule = [{
      name                       = "udp-non-restricted-range"
      priority                   = 240
      direction                  = "Inbound"
      access                     = "Allow"
      protocol                   = "Udp"
      source_port_range          = "*"
      destination_port_range     = "2000-3000"
      source_address_prefix      = "0.0.0.0/0"
      destination_address_prefix = "*"
    }]
  }
}

resource "azurerm_network_security_group" "pass_service_tag_port_range" {
  attrs = {
    name                = "pass-service-tag-port-range"
    location            = "East US"
    resource_group_name = "validation-resource-group"
    security_rule = [{
      name                       = "udp-https-service-tag"
      priority                   = 250
      direction                  = "Inbound"
      access                     = "Allow"
      protocol                   = "Udp"
      source_port_range          = "*"
      destination_port_range     = "Https"
      source_address_prefix      = "0.0.0.0/0"
      destination_address_prefix = "*"
    }]
  }
}
