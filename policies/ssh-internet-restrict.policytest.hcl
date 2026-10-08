# Copyright IBM Corp. 2026

policytest {
  targets = ["ssh-internet-restrict.policy.hcl"]
}

resource "azurerm_network_security_group" "fail_nsg_ssh_cidr0" {
  expect_failure = true
  attrs = {
    name = "nsg-fail_nsg_ssh_cidr0"
    location = "eastus"
    resource_group_name = "rg-test"
    security_rule = [
      {
        name = "r1"
        priority = 100
        access = "Allow"
        direction = "Inbound"
        protocol = "Tcp"
        source_port_range = "*"
        destination_port_range = "22"
        destination_port_ranges = []
        source_address_prefix = "0.0.0.0/0"
        source_address_prefixes = []
        destination_address_prefix = "*"
      },
    ]
  }
}

resource "azurerm_network_security_group" "fail_nsg_internet_any_proto" {
  expect_failure = true
  attrs = {
    name = "nsg-fail_nsg_internet_any_proto"
    location = "eastus"
    resource_group_name = "rg-test"
    security_rule = [
      {
        name = "r1"
        priority = 100
        access = "Allow"
        direction = "Inbound"
        protocol = "*"
        source_port_range = "*"
        destination_port_range = "22"
        destination_port_ranges = []
        source_address_prefix = "Internet"
        source_address_prefixes = []
        destination_address_prefix = "*"
      },
    ]
  }
}

resource "azurerm_network_security_group" "fail_nsg_star_source" {
  expect_failure = true
  attrs = {
    name = "nsg-fail_nsg_star_source"
    location = "eastus"
    resource_group_name = "rg-test"
    security_rule = [
      {
        name = "r1"
        priority = 100
        access = "Allow"
        direction = "Inbound"
        protocol = "Tcp"
        source_port_range = "*"
        destination_port_range = "22"
        destination_port_ranges = []
        source_address_prefix = "*"
        source_address_prefixes = []
        destination_address_prefix = "*"
      },
    ]
  }
}

resource "azurerm_network_security_group" "fail_nsg_any_source" {
  expect_failure = true
  attrs = {
    name = "nsg-fail_nsg_any_source"
    location = "eastus"
    resource_group_name = "rg-test"
    security_rule = [
      {
        name = "r1"
        priority = 100
        access = "Allow"
        direction = "Inbound"
        protocol = "Tcp"
        source_port_range = "*"
        destination_port_range = "22"
        destination_port_ranges = []
        source_address_prefix = "Any"
        source_address_prefixes = []
        destination_address_prefix = "*"
      },
    ]
  }
}

resource "azurerm_network_security_group" "fail_nsg_range_incl_22" {
  expect_failure = true
  attrs = {
    name = "nsg-fail_nsg_range_incl_22"
    location = "eastus"
    resource_group_name = "rg-test"
    security_rule = [
      {
        name = "r1"
        priority = 100
        access = "Allow"
        direction = "Inbound"
        protocol = "Tcp"
        source_port_range = "*"
        destination_port_range = "20-25"
        destination_port_ranges = []
        source_address_prefix = "Internet"
        source_address_prefixes = []
        destination_address_prefix = "*"
      },
    ]
  }
}

resource "azurerm_network_security_group" "fail_nsg_port_star" {
  expect_failure = true
  attrs = {
    name = "nsg-fail_nsg_port_star"
    location = "eastus"
    resource_group_name = "rg-test"
    security_rule = [
      {
        name = "r1"
        priority = 100
        access = "Allow"
        direction = "Inbound"
        protocol = "Tcp"
        source_port_range = "*"
        destination_port_range = "*"
        destination_port_ranges = []
        source_address_prefix = "0.0.0.0/0"
        source_address_prefixes = []
        destination_address_prefix = "*"
      },
    ]
  }
}

resource "azurerm_network_security_group" "fail_nsg_port_ranges" {
  expect_failure = true
  attrs = {
    name = "nsg-fail_nsg_port_ranges"
    location = "eastus"
    resource_group_name = "rg-test"
    security_rule = [
      {
        name = "r1"
        priority = 100
        access = "Allow"
        direction = "Inbound"
        protocol = "Tcp"
        source_port_range = "*"
        destination_port_range = null
        destination_port_ranges = ["443", "22"]
        source_address_prefix = "0.0.0.0/0"
        source_address_prefixes = []
        destination_address_prefix = "*"
      },
    ]
  }
}

resource "azurerm_network_security_group" "fail_nsg_port_ranges_range" {
  expect_failure = true
  attrs = {
    name = "nsg-fail_nsg_port_ranges_range"
    location = "eastus"
    resource_group_name = "rg-test"
    security_rule = [
      {
        name = "r1"
        priority = 100
        access = "Allow"
        direction = "Inbound"
        protocol = "Tcp"
        source_port_range = "*"
        destination_port_range = ""
        destination_port_ranges = ["80", "10-30"]
        source_address_prefix = "0.0.0.0/0"
        source_address_prefixes = []
        destination_address_prefix = "*"
      },
    ]
  }
}

resource "azurerm_network_security_group" "fail_nsg_source_prefixes" {
  expect_failure = true
  attrs = {
    name = "nsg-fail_nsg_source_prefixes"
    location = "eastus"
    resource_group_name = "rg-test"
    security_rule = [
      {
        name = "r1"
        priority = 100
        access = "Allow"
        direction = "Inbound"
        protocol = "Tcp"
        source_port_range = "*"
        destination_port_range = "22"
        destination_port_ranges = []
        source_address_prefix = null
        source_address_prefixes = ["10.0.0.0/8", "0.0.0.0/0"]
        destination_address_prefix = "*"
      },
    ]
  }
}

resource "azurerm_network_security_group" "fail_nsg_one_of_two_rules" {
  expect_failure = true
  attrs = {
    name = "nsg-fail_nsg_one_of_two_rules"
    location = "eastus"
    resource_group_name = "rg-test"
    security_rule = [
      {
        name = "r1"
        priority = 100
        access = "Allow"
        direction = "Inbound"
        protocol = "Tcp"
        source_port_range = "*"
        destination_port_range = "443"
        destination_port_ranges = []
        source_address_prefix = "0.0.0.0/0"
        source_address_prefixes = []
        destination_address_prefix = "*"
      },
      {
        name = "r2"
        priority = 110
        access = "Allow"
        direction = "Inbound"
        protocol = "Tcp"
        source_port_range = "*"
        destination_port_range = "22"
        destination_port_ranges = []
        source_address_prefix = "0.0.0.0/0"
        source_address_prefixes = []
        destination_address_prefix = "*"
      },
    ]
  }
}

resource "azurerm_network_security_group" "pass_nsg_empty_range_string_uses_ranges_no_22" {
  attrs = {
    name = "nsg-pass_nsg_empty_range_string_uses_ranges_no_22"
    location = "eastus"
    resource_group_name = "rg-test"
    security_rule = [
      {
        name = "r1"
        priority = 100
        access = "Allow"
        direction = "Inbound"
        protocol = "Tcp"
        source_port_range = "*"
        destination_port_range = ""
        destination_port_ranges = ["80", "443"]
        source_address_prefix = "0.0.0.0/0"
        source_address_prefixes = []
        destination_address_prefix = "*"
      },
    ]
  }
}

resource "azurerm_network_security_group" "pass_nsg_null_range_ranges_no_22" {
  attrs = {
    name = "nsg-pass_nsg_null_range_ranges_no_22"
    location = "eastus"
    resource_group_name = "rg-test"
    security_rule = [
      {
        name = "r1"
        priority = 100
        access = "Allow"
        direction = "Inbound"
        protocol = "Tcp"
        source_port_range = "*"
        destination_port_range = null
        destination_port_ranges = ["80", "443"]
        source_address_prefix = "0.0.0.0/0"
        source_address_prefixes = []
        destination_address_prefix = "*"
      },
    ]
  }
}

resource "azurerm_network_security_group" "pass_nsg_private_source" {
  attrs = {
    name = "nsg-pass_nsg_private_source"
    location = "eastus"
    resource_group_name = "rg-test"
    security_rule = [
      {
        name = "r1"
        priority = 100
        access = "Allow"
        direction = "Inbound"
        protocol = "Tcp"
        source_port_range = "*"
        destination_port_range = "22"
        destination_port_ranges = []
        source_address_prefix = "10.0.0.0/8"
        source_address_prefixes = []
        destination_address_prefix = "*"
      },
    ]
  }
}

resource "azurerm_network_security_group" "pass_nsg_deny" {
  attrs = {
    name = "nsg-pass_nsg_deny"
    location = "eastus"
    resource_group_name = "rg-test"
    security_rule = [
      {
        name = "r1"
        priority = 100
        access = "Deny"
        direction = "Inbound"
        protocol = "Tcp"
        source_port_range = "*"
        destination_port_range = "22"
        destination_port_ranges = []
        source_address_prefix = "0.0.0.0/0"
        source_address_prefixes = []
        destination_address_prefix = "*"
      },
    ]
  }
}

resource "azurerm_network_security_group" "pass_nsg_outbound" {
  attrs = {
    name = "nsg-pass_nsg_outbound"
    location = "eastus"
    resource_group_name = "rg-test"
    security_rule = [
      {
        name = "r1"
        priority = 100
        access = "Allow"
        direction = "Outbound"
        protocol = "Tcp"
        source_port_range = "*"
        destination_port_range = "22"
        destination_port_ranges = []
        source_address_prefix = "0.0.0.0/0"
        source_address_prefixes = []
        destination_address_prefix = "*"
      },
    ]
  }
}

resource "azurerm_network_security_group" "pass_nsg_udp" {
  attrs = {
    name = "nsg-pass_nsg_udp"
    location = "eastus"
    resource_group_name = "rg-test"
    security_rule = [
      {
        name = "r1"
        priority = 100
        access = "Allow"
        direction = "Inbound"
        protocol = "Udp"
        source_port_range = "*"
        destination_port_range = "22"
        destination_port_ranges = []
        source_address_prefix = "0.0.0.0/0"
        source_address_prefixes = []
        destination_address_prefix = "*"
      },
    ]
  }
}

resource "azurerm_network_security_group" "pass_nsg_range_excl_22" {
  attrs = {
    name = "nsg-pass_nsg_range_excl_22"
    location = "eastus"
    resource_group_name = "rg-test"
    security_rule = [
      {
        name = "r1"
        priority = 100
        access = "Allow"
        direction = "Inbound"
        protocol = "Tcp"
        source_port_range = "*"
        destination_port_range = "23-100"
        destination_port_ranges = []
        source_address_prefix = "0.0.0.0/0"
        source_address_prefixes = []
        destination_address_prefix = "*"
      },
    ]
  }
}

resource "azurerm_network_security_group" "pass_nsg_no_rules" {
  attrs = {
    name = "nsg-pass_nsg_no_rules"
    location = "eastus"
    resource_group_name = "rg-test"
    security_rule = [
    ]
  }
}

resource "azurerm_network_security_rule" "fail_rule_ssh_star" {
  expect_failure = true
  attrs = {
    name = "rule-fail_rule_ssh_star"
    resource_group_name = "rg-test"
    network_security_group_name = "nsg-fail_rule_ssh_star"
    priority = 100
    access = "Allow"
    direction = "Inbound"
    protocol = "Tcp"
    source_port_range = "*"
    destination_port_range = "22"
    source_address_prefix = "*"
    destination_address_prefix = "*"
  }
}

resource "azurerm_network_security_rule" "fail_rule_full_range_internet" {
  expect_failure = true
  attrs = {
    name = "rule-fail_rule_full_range_internet"
    resource_group_name = "rg-test"
    network_security_group_name = "nsg-fail_rule_full_range_internet"
    priority = 100
    access = "Allow"
    direction = "Inbound"
    protocol = "*"
    source_port_range = "*"
    destination_port_range = "1-65535"
    source_address_prefix = "Internet"
    destination_address_prefix = "*"
  }
}

resource "azurerm_network_security_rule" "fail_rule_port_ranges_null_range" {
  expect_failure = true
  attrs = {
    name = "rule-fail_rule_port_ranges_null_range"
    resource_group_name = "rg-test"
    network_security_group_name = "nsg-fail_rule_port_ranges_null_range"
    priority = 100
    access = "Allow"
    direction = "Inbound"
    protocol = "Tcp"
    source_port_range = "*"
    destination_port_range = null
    source_address_prefix = "0.0.0.0/0"
    destination_address_prefix = "*"
    destination_port_ranges = ["22"]
  }
}

resource "azurerm_network_security_rule" "fail_rule_source_prefixes" {
  expect_failure = true
  attrs = {
    name = "rule-fail_rule_source_prefixes"
    resource_group_name = "rg-test"
    network_security_group_name = "nsg-fail_rule_source_prefixes"
    priority = 100
    access = "Allow"
    direction = "Inbound"
    protocol = "Tcp"
    source_port_range = "*"
    destination_port_range = "22"
    source_address_prefix = null
    destination_address_prefix = "*"
    source_address_prefixes = ["0.0.0.0/0"]
  }
}

resource "azurerm_network_security_rule" "pass_rule_empty_range_uses_ranges_no_22" {
  attrs = {
    name = "rule-pass_rule_empty_range_uses_ranges_no_22"
    resource_group_name = "rg-test"
    network_security_group_name = "nsg-pass_rule_empty_range_uses_ranges_no_22"
    priority = 100
    access = "Allow"
    direction = "Inbound"
    protocol = "Tcp"
    source_port_range = "*"
    destination_port_range = ""
    source_address_prefix = "0.0.0.0/0"
    destination_address_prefix = "*"
    destination_port_ranges = ["80", "443"]
  }
}

resource "azurerm_network_security_rule" "pass_rule_ssh_private" {
  attrs = {
    name = "rule-pass_rule_ssh_private"
    resource_group_name = "rg-test"
    network_security_group_name = "nsg-pass_rule_ssh_private"
    priority = 100
    access = "Allow"
    direction = "Inbound"
    protocol = "Tcp"
    source_port_range = "*"
    destination_port_range = "22"
    source_address_prefix = "192.168.1.0/24"
    destination_address_prefix = "*"
  }
}

resource "azurerm_network_security_rule" "pass_rule_ssh_deny" {
  attrs = {
    name = "rule-pass_rule_ssh_deny"
    resource_group_name = "rg-test"
    network_security_group_name = "nsg-pass_rule_ssh_deny"
    priority = 100
    access = "Deny"
    direction = "Inbound"
    protocol = "Tcp"
    source_port_range = "*"
    destination_port_range = "22"
    source_address_prefix = "*"
    destination_address_prefix = "*"
  }
}

resource "azurerm_network_security_rule" "pass_rule_https_star" {
  attrs = {
    name = "rule-pass_rule_https_star"
    resource_group_name = "rg-test"
    network_security_group_name = "nsg-pass_rule_https_star"
    priority = 100
    access = "Allow"
    direction = "Inbound"
    protocol = "Tcp"
    source_port_range = "*"
    destination_port_range = "443"
    source_address_prefix = "*"
    destination_address_prefix = "*"
  }
}

resource "azurerm_network_security_rule" "pass_rule_ssh_outbound" {
  attrs = {
    name = "rule-pass_rule_ssh_outbound"
    resource_group_name = "rg-test"
    network_security_group_name = "nsg-pass_rule_ssh_outbound"
    priority = 100
    access = "Allow"
    direction = "Outbound"
    protocol = "Tcp"
    source_port_range = "*"
    destination_port_range = "22"
    source_address_prefix = "*"
    destination_address_prefix = "*"
  }
}

resource "azurerm_network_security_rule" "pass_rule_ssh_udp" {
  attrs = {
    name = "rule-pass_rule_ssh_udp"
    resource_group_name = "rg-test"
    network_security_group_name = "nsg-pass_rule_ssh_udp"
    priority = 100
    access = "Allow"
    direction = "Inbound"
    protocol = "Udp"
    source_port_range = "*"
    destination_port_range = "22"
    source_address_prefix = "Internet"
    destination_address_prefix = "*"
  }
}

resource "azurerm_network_security_group" "fail_nsg_ipv6" {
  expect_failure = true
  attrs = {
    security_rule = [{ access = "Allow", direction = "Inbound", protocol = "Tcp", destination_port_range = "22", source_address_prefix = "::/0" }]
  }
}

resource "azurerm_network_security_group" "fail_nsg_zero_address" {
  expect_failure = true
  attrs = {
    security_rule = [{ access = "Allow", direction = "Inbound", protocol = "Tcp", destination_port_range = "22", source_address_prefix = "0.0.0.0" }]
  }
}

resource "azurerm_network_security_group" "fail_nsg_normalized" {
  expect_failure = true
  attrs = {
    security_rule = [{ access = " allow ", direction = " INBOUND ", protocol = " TCP ", destination_port_range = " 22 ", source_address_prefix = " INTERNET " }]
  }
}

resource "azurerm_network_security_group" "fail_nsg_wildcard_in_port_list" {
  expect_failure = true
  attrs = {
    security_rule = [{ access = "Allow", direction = "Inbound", protocol = "*", destination_port_ranges = ["443", "*"], source_address_prefixes = ["10.0.0.0/8", "::/0"] }]
  }
}

resource "azurerm_network_security_group" "fail_nsg_range_lower_boundary" {
  expect_failure = true
  attrs = {
    security_rule = [{ access = "Allow", direction = "Inbound", protocol = "Tcp", destination_port_range = "22-30", source_address_prefix = "Internet" }]
  }
}

resource "azurerm_network_security_group" "fail_nsg_range_upper_boundary" {
  expect_failure = true
  attrs = {
    security_rule = [{ access = "Allow", direction = "Inbound", protocol = "Tcp", destination_port_range = "1-22", source_address_prefix = "Internet" }]
  }
}

resource "azurerm_network_security_group" "pass_nsg_unknown_rules" {
  attrs = {
    security_rule = null
  }
}

resource "azurerm_network_security_group" "pass_nsg_unknown_port" {
  attrs = {
    security_rule = [{ access = "Allow", direction = "Inbound", protocol = "Tcp", destination_port_range = null, source_address_prefix = "Internet" }]
  }
}

resource "azurerm_network_security_group" "pass_nsg_unknown_source" {
  attrs = {
    security_rule = [{ access = "Allow", direction = "Inbound", protocol = "Tcp", destination_port_range = "22", source_address_prefix = null }]
  }
}

resource "azurerm_network_security_group" "pass_nsg_restricted_public_source" {
  attrs = {
    security_rule = [{ access = "Allow", direction = "Inbound", protocol = "Tcp", destination_port_range = "22", source_address_prefix = "203.0.113.10/32" }]
  }
}

resource "azurerm_network_security_group" "pass_nsg_port_list_no_ssh" {
  attrs = {
    security_rule = [{ access = "Allow", direction = "Inbound", protocol = "Tcp", destination_port_ranges = ["1-21", "23-65535"], source_address_prefix = "Internet" }]
  }
}

resource "azurerm_network_security_rule" "fail_rule_wildcard_port" {
  expect_failure = true
  attrs = {
    access = "Allow"
    direction = "Inbound"
    protocol = "Tcp"
    destination_port_range = "*"
    source_address_prefix = "Internet"
  }
}

resource "azurerm_network_security_rule" "fail_rule_wildcard_port_list" {
  expect_failure = true
  attrs = {
    access = "Allow"
    direction = "Inbound"
    protocol = "*"
    destination_port_ranges = ["443", "*"]
    source_address_prefix = "*"
  }
}

resource "azurerm_network_security_rule" "fail_rule_ipv6" {
  expect_failure = true
  attrs = {
    access = "Allow"
    direction = "Inbound"
    protocol = "Tcp"
    destination_port_range = "22"
    source_address_prefix = "::/0"
  }
}

resource "azurerm_network_security_rule" "fail_rule_zero_address" {
  expect_failure = true
  attrs = {
    access = "Allow"
    direction = "Inbound"
    protocol = "Tcp"
    destination_port_range = "22"
    source_address_prefix = "0.0.0.0"
  }
}

resource "azurerm_network_security_rule" "fail_rule_any_source" {
  expect_failure = true
  attrs = {
    access = "Allow"
    direction = "Inbound"
    protocol = "Tcp"
    destination_port_range = "22"
    source_address_prefix = "Any"
  }
}

resource "azurerm_network_security_rule" "fail_rule_normalized" {
  expect_failure = true
  attrs = {
    access = " allow "
    direction = " INBOUND "
    protocol = " TCP "
    destination_port_range = " 22 "
    source_address_prefix = " INTERNET "
  }
}

resource "azurerm_network_security_rule" "fail_rule_range_lower_boundary" {
  expect_failure = true
  attrs = {
    access = "Allow"
    direction = "Inbound"
    protocol = "Tcp"
    destination_port_range = "22-30"
    source_address_prefix = "Internet"
  }
}

resource "azurerm_network_security_rule" "fail_rule_range_upper_boundary" {
  expect_failure = true
  attrs = {
    access = "Allow"
    direction = "Inbound"
    protocol = "Tcp"
    destination_port_range = "1-22"
    source_address_prefix = "Internet"
  }
}

resource "azurerm_network_security_rule" "fail_rule_mixed_port_and_source_lists" {
  expect_failure = true
  attrs = {
    access = "Allow"
    direction = "Inbound"
    protocol = "Tcp"
    destination_port_ranges = ["443", "20-25"]
    source_address_prefixes = ["10.0.0.0/8", "::/0"]
  }
}

resource "azurerm_network_security_rule" "pass_rule_range_below_ssh" {
  attrs = {
    access = "Allow"
    direction = "Inbound"
    protocol = "Tcp"
    destination_port_range = "1-21"
    source_address_prefix = "Internet"
  }
}

resource "azurerm_network_security_rule" "pass_rule_range_above_ssh" {
  attrs = {
    access = "Allow"
    direction = "Inbound"
    protocol = "Tcp"
    destination_port_range = "23-65535"
    source_address_prefix = "Internet"
  }
}

resource "azurerm_network_security_rule" "pass_rule_unknown_ports" {
  attrs = {
    access = "Allow"
    direction = "Inbound"
    protocol = "Tcp"
    destination_port_range = null
    destination_port_ranges = null
    source_address_prefix = "Internet"
  }
}

resource "azurerm_network_security_rule" "pass_rule_unknown_sources" {
  attrs = {
    access = "Allow"
    direction = "Inbound"
    protocol = "Tcp"
    destination_port_range = "22"
    source_address_prefix = null
    source_address_prefixes = null
  }
}

resource "azurerm_network_security_rule" "pass_rule_virtual_network" {
  attrs = {
    access = "Allow"
    direction = "Inbound"
    protocol = "Tcp"
    destination_port_range = "22"
    source_address_prefix = "VirtualNetwork"
  }
}

resource "azurerm_network_security_rule" "pass_rule_source_asg" {
  attrs = {
    access = "Allow"
    direction = "Inbound"
    protocol = "Tcp"
    destination_port_range = "22"
    source_application_security_group_ids = ["/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-test/providers/Microsoft.Network/applicationSecurityGroups/asg-private"]
  }
}

resource "azurerm_network_security_rule" "pass_rule_restricted_public_source" {
  attrs = {
    access = "Allow"
    direction = "Inbound"
    protocol = "Tcp"
    destination_port_range = "22"
    source_address_prefix = "203.0.113.10/32"
  }
}

resource "azurerm_network_security_rule" "pass_rule_non_tcp_protocol" {
  attrs = {
    access = "Allow"
    direction = "Inbound"
    protocol = "Icmp"
    destination_port_range = "*"
    source_address_prefix = "Internet"
  }
}

resource "azurerm_resource_group" "pass_unrelated_resource" {
  attrs = {
    name = "rg-unrelated"
  }
}
