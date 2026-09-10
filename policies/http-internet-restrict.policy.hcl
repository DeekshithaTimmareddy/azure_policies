# Copyright IBM Corp. 2026

# Ensure that HTTP(S) Access from the Internet is Evaluated and Restricted

policy {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = ">= 4.0.0, < 6.0.0"
    }
  }
}

input "http-internet-restrict-enforcement-level" {
  type    = string
  default = "advisory"
}

resource_policy "azurerm_network_security_group" "restrict_internet_http_https_access" {
  locals {
    security_rules_raw = core::try(attrs.security_rule, null)
    security_rules     = local.security_rules_raw != null ? local.security_rules_raw : []
    normalized_rules = [for rule in local.security_rules : {
      direction               = core::try(rule.direction, null) != null ? rule.direction : ""
      access                  = core::try(rule.access, null) != null ? rule.access : ""
      protocol                = core::try(rule.protocol, null) != null ? rule.protocol : ""
      destination_port_range  = core::try(rule.destination_port_range, null) != null ? rule.destination_port_range : ""
      destination_port_ranges = core::try(rule.destination_port_ranges, null) != null ? rule.destination_port_ranges : []
      source_address_prefix   = core::try(rule.source_address_prefix, null) != null ? rule.source_address_prefix : ""
      source_address_prefixes = core::try(rule.source_address_prefixes, null) != null ? rule.source_address_prefixes : []
    }]
    inbound_allow_tcp_rules   = [for rule in local.normalized_rules : rule if rule.direction == "Inbound" && rule.access == "Allow" && core::contains(["Tcp", "*"], rule.protocol)]
    violations_single_port    = [for rule in local.inbound_allow_tcp_rules : rule if (core::contains(["80", "443", "*"], rule.destination_port_range) || (core::length(core::split("-", rule.destination_port_range)) == 2 && core::try(core::parseint(core::split("-", rule.destination_port_range)[0], 10), -1) <= 80 && core::try(core::parseint(core::split("-", rule.destination_port_range)[1], 10), -1) >= 80) || (core::length(core::split("-", rule.destination_port_range)) == 2 && core::try(core::parseint(core::split("-", rule.destination_port_range)[0], 10), -1) <= 443 && core::try(core::parseint(core::split("-", rule.destination_port_range)[1], 10), -1) >= 443)) && (core::contains(["0.0.0.0/0", "Internet", "*"], rule.source_address_prefix) || core::length([for source in rule.source_address_prefixes : source if core::contains(["0.0.0.0/0", "Internet", "*"], source)]) > 0)]
    violations_multiple_ports = [for rule in local.inbound_allow_tcp_rules : rule if core::length([for port in rule.destination_port_ranges : port if core::contains(["80", "443", "*"], port) || (core::length(core::split("-", port)) == 2 && core::try(core::parseint(core::split("-", port)[0], 10), -1) <= 80 && core::try(core::parseint(core::split("-", port)[1], 10), -1) >= 80) || (core::length(core::split("-", port)) == 2 && core::try(core::parseint(core::split("-", port)[0], 10), -1) <= 443 && core::try(core::parseint(core::split("-", port)[1], 10), -1) >= 443)]) > 0 && (core::contains(["0.0.0.0/0", "Internet", "*"], rule.source_address_prefix) || core::length([for source in rule.source_address_prefixes : source if core::contains(["0.0.0.0/0", "Internet", "*"], source)]) > 0)]
  }

  enforcement_level = input.http-internet-restrict-enforcement-level
  enforce {
    condition     = core::length(local.violations_single_port) == 0 && core::length(local.violations_multiple_ports) == 0
    error_message = "Network security groups must not allow inbound HTTP or HTTPS traffic from Internet-level sources. Remove the rule or narrow its source address prefixes."
  }
}
