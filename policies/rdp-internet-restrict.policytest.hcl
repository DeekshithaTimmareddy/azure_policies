# Copyright IBM Corp. 2026

policytest {
  targets = ["rdp-internet-restrict.policy.hcl"]
}

resource "azurerm_network_security_group" "pass_empty_rules" {
  attrs = {
    name                = "pass-empty-rules"
    location            = "East US"
    resource_group_name = "validation-resource-group"
    security_rule       = []
  }
}

resource "azurerm_network_security_group" "pass_null_rules" {
  attrs = {
    name                = "pass-null-rules"
    location            = "East US"
    resource_group_name = "validation-resource-group"
    security_rule       = null
  }
}

resource "azurerm_network_security_group" "pass_private_source" {
  attrs = {
    name                = "pass-private-source"
    location            = "East US"
    resource_group_name = "validation-resource-group"
    security_rule = [{
      name                       = "private-rdp"
      priority                   = 100
      direction                  = "Inbound"
      access                     = "Allow"
      protocol                   = "Tcp"
      source_port_range          = "*"
      destination_port_range     = "3389"
      source_address_prefix      = "10.0.0.0/8"
      destination_address_prefix = "*"
    }]
  }
}

resource "azurerm_network_security_group" "pass_outbound" {
  attrs = {
    name                = "pass-outbound"
    location            = "East US"
    resource_group_name = "validation-resource-group"
    security_rule = [{
      name                       = "outbound-rdp"
      priority                   = 100
      direction                  = "Outbound"
      access                     = "Allow"
      protocol                   = "Tcp"
      source_port_range          = "*"
      destination_port_range     = "3389"
      source_address_prefix      = "*"
      destination_address_prefix = "*"
    }]
  }
}

resource "azurerm_network_security_group" "pass_deny" {
  attrs = {
    name                = "pass-deny"
    location            = "East US"
    resource_group_name = "validation-resource-group"
    security_rule = [{
      name                       = "deny-rdp"
      priority                   = 100
      direction                  = "Inbound"
      access                     = "Deny"
      protocol                   = "Tcp"
      source_port_range          = "*"
      destination_port_range     = "3389"
      source_address_prefix      = "Internet"
      destination_address_prefix = "*"
    }]
  }
}

resource "azurerm_network_security_group" "pass_udp" {
  attrs = {
    name                = "pass-udp"
    location            = "East US"
    resource_group_name = "validation-resource-group"
    security_rule = [{
      name                       = "udp-rdp-port"
      priority                   = 100
      direction                  = "Inbound"
      access                     = "Allow"
      protocol                   = "Udp"
      source_port_range          = "*"
      destination_port_range     = "3389"
      source_address_prefix      = "*"
      destination_address_prefix = "*"
    }]
  }
}

resource "azurerm_network_security_group" "pass_range_outside_3389" {
  attrs = {
    name                = "pass-range-outside-3389"
    location            = "East US"
    resource_group_name = "validation-resource-group"
    security_rule = [{
      name                       = "higher-ports"
      priority                   = 100
      direction                  = "Inbound"
      access                     = "Allow"
      protocol                   = "Tcp"
      source_port_range          = "*"
      destination_port_range     = "3390-3400"
      source_address_prefix      = "0.0.0.0/0"
      destination_address_prefix = "*"
    }]
  }
}

resource "azurerm_network_security_group" "fail_exact_rdp" {
  expect_failure = true
  attrs = {
    name                = "fail-exact-rdp"
    location            = "East US"
    resource_group_name = "validation-resource-group"
    security_rule = [{
      name                       = "public-rdp"
      priority                   = 100
      direction                  = "Inbound"
      access                     = "Allow"
      protocol                   = "Tcp"
      source_port_range          = "*"
      destination_port_range     = "3389"
      source_address_prefix      = "0.0.0.0/0"
      destination_address_prefix = "*"
    }]
  }
}

resource "azurerm_network_security_group" "fail_singular_range" {
  expect_failure = true
  attrs = {
    name                = "fail-singular-range"
    location            = "East US"
    resource_group_name = "validation-resource-group"
    security_rule = [{
      name                       = "public-rdp-range"
      priority                   = 100
      direction                  = "Inbound"
      access                     = "Allow"
      protocol                   = "*"
      source_port_range          = "*"
      destination_port_range     = "3380-3390"
      source_address_prefix      = "Internet"
      destination_address_prefix = "*"
    }]
  }
}

# Optional singular attributes are omitted to verify safe missing-attribute access.
resource "azurerm_network_security_group" "fail_plural_attributes" {
  expect_failure = true
  attrs = {
    name                = "fail-plural-attributes"
    location            = "East US"
    resource_group_name = "validation-resource-group"
    security_rule = [{
      name                         = "public-rdp-plural"
      priority                     = 100
      direction                    = "Inbound"
      access                       = "Allow"
      protocol                     = "Tcp"
      source_port_range            = "*"
      destination_port_ranges      = ["22", "3389"]
      source_address_prefixes      = ["10.0.0.0/8", "*"]
      destination_address_prefixes = ["*"]
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
      name                         = "public-rdp-boundary"
      priority                     = 100
      direction                    = "Inbound"
      access                       = "Allow"
      protocol                     = "Tcp"
      source_port_range            = "*"
      destination_port_range       = "3389-3389"
      source_address_prefixes      = ["Internet"]
      destination_address_prefixes = ["*"]
    }]
  }
}

# FAIL: destination_port_range = "*" opens all ports including 3389 from internet.
resource "azurerm_network_security_group" "fail_wildcard_destination_port" {
  expect_failure = true
  attrs = {
    name                = "fail-wildcard-port"
    location            = "East US"
    resource_group_name = "validation-resource-group"
    security_rule = [{
      name                       = "public-all-ports"
      priority                   = 100
      direction                  = "Inbound"
      access                     = "Allow"
      protocol                   = "Tcp"
      source_port_range          = "*"
      destination_port_range     = "*"
      source_address_prefix      = "0.0.0.0/0"
      destination_address_prefix = "*"
    }]
  }
}

resource "azurerm_network_security_group" "fail_wildcard_source_prefix" {
  expect_failure = true
  attrs = {
    name                = "fail-wildcard-source"
    location            = "East US"
    resource_group_name = "validation-resource-group"
    security_rule = [{
      name                       = "public-rdp-wildcard-source"
      priority                   = 100
      direction                  = "Inbound"
      access                     = "Allow"
      protocol                   = "Tcp"
      source_port_range          = "*"
      destination_port_range     = "3389"
      source_address_prefix      = "*"
      destination_address_prefix = "*"
    }]
  }
}

resource "azurerm_network_security_group" "fail_null_source_prefixes" {
  expect_failure = true
  attrs = {
    name                = "fail-null-source-prefixes"
    location            = "East US"
    resource_group_name = "validation-resource-group"
    security_rule = [{
      name                       = "public-rdp-null-prefixes"
      priority                   = 100
      direction                  = "Inbound"
      access                     = "Allow"
      protocol                   = "Tcp"
      destination_port_range     = "3389"
      source_address_prefix      = "0.0.0.0/0"
      source_address_prefixes    = null
      destination_address_prefix = "*"
    }]
  }
}

resource "azurerm_network_security_group" "fail_null_destination_port_ranges" {
  expect_failure = true
  attrs = {
    name                = "fail-null-dest-ranges"
    location            = "East US"
    resource_group_name = "validation-resource-group"
    security_rule = [{
      name                       = "public-rdp-null-ranges"
      priority                   = 100
      direction                  = "Inbound"
      access                     = "Allow"
      protocol                   = "Tcp"
      destination_port_range     = "3389"
      destination_port_ranges    = null
      source_address_prefix      = "Internet"
      destination_address_prefix = "*"
    }]
  }
}

resource "azurerm_network_security_group" "fail_ipv6_unrestricted_source" {
  expect_failure = true
  attrs = {
    name                = "fail-ipv6-source"
    location            = "East US"
    resource_group_name = "validation-resource-group"
    security_rule = [{
      name                       = "public-rdp-ipv6"
      priority                   = 100
      direction                  = "Inbound"
      access                     = "Allow"
      protocol                   = "Tcp"
      destination_port_range     = "3389"
      source_address_prefix      = "::/0"
      destination_address_prefix = "*"
    }]
  }
}

resource "azurerm_network_security_rule" "fail_standalone_rdp_internet" {
  expect_failure = true
  attrs = {
    direction               = "Inbound"
    access                  = "Allow"
    protocol                = "Tcp"
    destination_port_range  = "3389"
    source_address_prefix   = "0.0.0.0/0"
  }
}

resource "azurerm_network_security_rule" "fail_standalone_rdp_ipv6" {
  expect_failure = true
  attrs = {
    direction               = "Inbound"
    access                  = "Allow"
    protocol                = "Tcp"
    destination_port_range  = "3389"
    source_address_prefix   = "::/0"
  }
}

resource "azurerm_network_security_rule" "pass_standalone_outbound_rdp" {
  attrs = {
    direction               = "Outbound"
    access                  = "Allow"
    protocol                = "Tcp"
    destination_port_range  = "3389"
    source_address_prefix   = "Internet"
  }
}

resource "azurerm_network_security_rule" "pass_standalone_private_source" {
  attrs = {
    direction               = "Inbound"
    access                  = "Allow"
    protocol                = "Tcp"
    destination_port_range  = "3389"
    source_address_prefix   = "10.0.0.0/8"
  }
}

resource "azurerm_network_security_rule" "pass_standalone_deny" {
  attrs = {
    direction               = "Inbound"
    access                  = "Deny"
    protocol                = "Tcp"
    destination_port_range  = "3389"
    source_address_prefix   = "Internet"
  }
}
