# Copyright IBM Corp. 2026

# Ensure that RDP Access from the Internet is Evaluated and Restricted

policy {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = ">= 4.0.0, < 6.0.0"
    }
  }
}

input "rdp-internet-restrict-enforcement-level" {
  type    = string
  default = "advisory"
}

resource_policy "azurerm_network_security_group" "restrict_rdp_from_internet" {
  locals {
    security_rules_raw = core::try(attrs.security_rule, null)
    security_rules     = local.security_rules_raw != null ? local.security_rules_raw : []

    inbound_allow_rdp_protocol_rules = [for rule in local.security_rules : rule if core::try(rule.direction, "") == "Inbound" && core::try(rule.access, "") == "Allow" && core::contains(["Tcp", "*"], core::try(rule.protocol, ""))]

    internet_source_rules = [for rule in local.inbound_allow_rdp_protocol_rules : rule if core::contains(["0.0.0.0/0", "Internet", "*"], core::try(rule.source_address_prefix, "")) || core::length([for source in core::try(rule.source_address_prefixes, []) : source if core::contains(["0.0.0.0/0", "Internet", "*"], source)]) > 0]

    violating_rules = [for rule in local.internet_source_rules : rule if core::contains(["3389", "*"], core::try(rule.destination_port_range, "")) || (core::try(core::parseint(core::try(core::split("-", core::try(rule.destination_port_range, ""))[0], ""), 10), -1) <= 3389 && core::try(core::parseint(core::try(core::split("-", core::try(rule.destination_port_range, ""))[1], ""), 10), -1) >= 3389) || core::length([for port_range in (core::try(rule.destination_port_ranges, null) != null ? core::try(rule.destination_port_ranges, []) : []) : port_range if core::contains(["3389", "*"], port_range) || (core::try(core::parseint(core::try(core::split("-", port_range)[0], ""), 10), -1) <= 3389 && core::try(core::parseint(core::try(core::split("-", port_range)[1], ""), 10), -1) >= 3389)]) > 0]
  }

  enforcement_level = input.rdp-internet-restrict-enforcement-level
  enforce {
    condition     = core::length(local.violating_rules) == 0
    error_message = "Network security groups must not allow inbound TCP RDP access on port 3389 from 0.0.0.0/0, Internet, or any source. Remove or narrowly restrict the offending inline security rule."
  }
}
