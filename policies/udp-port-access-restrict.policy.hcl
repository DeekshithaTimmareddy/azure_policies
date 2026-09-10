# Copyright IBM Corp. 2026

# Ensure that UDP Port Access from the Internet is Evaluated and Restricted

policy {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = ">= 4.0.0, < 6.0.0"
    }
  }
}

input "udp-port-access-restrict-enforcement-level" {
  type    = string
  default = "advisory"
}

resource_policy "azurerm_network_security_group" "restrict_internet_udp_ports" {
  locals {
    restricted_ports        = [53, 123, 161, 389, 1900]
    restricted_port_strings = ["53", "123", "161", "389", "1900"]
    security_rules_raw      = core::try(attrs.security_rule, null)
    security_rules          = local.security_rules_raw != null ? local.security_rules_raw : []
    inbound_udp_allow_rules = [for rule in local.security_rules : rule if core::try(rule.direction, "") == "Inbound" && core::try(rule.access, "") == "Allow" && (core::try(rule.protocol, "") == "Udp" || core::try(rule.protocol, "") == "*")]
    internet_exposed_rules = [for rule in local.inbound_udp_allow_rules : rule
      if core::contains(["0.0.0.0/0", "Internet", "*"], core::try(rule.source_address_prefix, ""))
      || core::length([for prefix in core::try(rule.source_address_prefixes, []) : prefix if core::contains(["0.0.0.0/0", "Internet", "*"], prefix)]) > 0
    ]
    violating_rules         = [for rule in local.internet_exposed_rules : rule if (core::try(rule.destination_port_range, null) != null ? core::try(rule.destination_port_range, "") : "") == "*" || core::contains(local.restricted_port_strings, core::try(rule.destination_port_range, null) != null ? core::try(rule.destination_port_range, "") : "") || (core::try(core::regex("^\\d+-\\d+$", core::try(rule.destination_port_range, "")), null) != null && core::length([for restricted_port in local.restricted_ports : restricted_port if core::try(core::parseint(core::try(core::split("-", core::try(rule.destination_port_range, ""))[0], ""), 10), -1) <= restricted_port && core::try(core::parseint(core::try(core::split("-", core::try(rule.destination_port_range, ""))[1], ""), 10), -1) >= restricted_port]) > 0) || core::length([for port_spec in (core::try(rule.destination_port_ranges, null) != null ? core::try(rule.destination_port_ranges, []) : []) : port_spec if port_spec == "*" || core::contains(local.restricted_port_strings, port_spec) || (core::try(core::regex("^\\d+-\\d+$", port_spec), null) != null && core::length([for restricted_port in local.restricted_ports : restricted_port if core::try(core::parseint(core::try(core::split("-", port_spec)[0], ""), 10), -1) <= restricted_port && core::try(core::parseint(core::try(core::split("-", port_spec)[1], ""), 10), -1) >= restricted_port]) > 0)]) > 0]
  }

  enforcement_level = input.udp-port-access-restrict-enforcement-level
  enforce {
    condition     = core::length(local.violating_rules) == 0
    error_message = "Network security group rules must not allow Internet-level UDP access to ports 53, 123, 161, 389, or 1900. Remove the rule or restrict its protocol, source, destination ports, or access."
  }
}

resource_policy "azurerm_network_security_rule" "restrict_internet_udp_ports_standalone" {
  locals {
    restricted_ports        = [53, 123, 161, 389, 1900]
    restricted_port_strings = ["53", "123", "161", "389", "1900"]
    direction               = core::try(attrs.direction, "")
    access                  = core::try(attrs.access, "")
    protocol                = core::try(attrs.protocol, "")
    is_inbound_udp_allow    = local.direction == "Inbound" && local.access == "Allow" && (local.protocol == "Udp" || local.protocol == "*")
    source_prefix           = core::try(attrs.source_address_prefix, "")
    source_prefixes         = core::try(attrs.source_address_prefixes, null) != null ? core::try(attrs.source_address_prefixes, []) : []
    is_internet_source      = core::contains(["0.0.0.0/0", "Internet", "*"], local.source_prefix) || core::try(core::length([for prefix in local.source_prefixes : prefix if core::contains(["0.0.0.0/0", "Internet", "*"], prefix)]), 0) > 0
    dest_port_range  = core::try(attrs.destination_port_range, "")
    dest_port_ranges = core::try(attrs.destination_port_ranges, null) != null ? core::try(attrs.destination_port_ranges, []) : []
    is_violating_port       = local.dest_port_range == "*" || core::contains(local.restricted_port_strings, local.dest_port_range) || (core::try(core::regex("^\\d+-\\d+$", local.dest_port_range), null) != null && core::length([for restricted_port in local.restricted_ports : restricted_port if core::try(core::parseint(core::try(core::split("-", local.dest_port_range)[0], ""), 10), -1) <= restricted_port && core::try(core::parseint(core::try(core::split("-", local.dest_port_range)[1], ""), 10), -1) >= restricted_port]) > 0) || core::try(core::length([for port_spec in local.dest_port_ranges : port_spec if port_spec == "*" || core::contains(local.restricted_port_strings, port_spec) || (core::try(core::regex("^\\d+-\\d+$", port_spec), null) != null && core::length([for restricted_port in local.restricted_ports : restricted_port if core::try(core::parseint(core::try(core::split("-", port_spec)[0], ""), 10), -1) <= restricted_port && core::try(core::parseint(core::try(core::split("-", port_spec)[1], ""), 10), -1) >= restricted_port]) > 0)]), 0) > 0
  }

  enforcement_level = input.udp-port-access-restrict-enforcement-level
  enforce {
    condition     = !(local.is_inbound_udp_allow && local.is_internet_source && local.is_violating_port)
    error_message = "Standalone network security rules must not allow Internet-level UDP access to ports 53, 123, 161, 389, or 1900. Remove the rule or restrict its protocol, source, destination ports, or access."
  }
}
