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

    # Normalize each rule so a field that is present-but-null (not merely
    # absent) is safely coerced to a usable default before iteration --
    # core::try(value, default) does not replace an explicit null.
    normalized_rules = [for rule in local.security_rules : {
      direction                = core::try(rule.direction, "")
      access                   = core::try(rule.access, "")
      protocol                 = core::try(rule.protocol, "")
      source_address_prefix    = core::try(rule.source_address_prefix, "")
      source_address_prefixes  = core::try(rule.source_address_prefixes, null) != null ? rule.source_address_prefixes : []
      destination_port_range   = core::try(rule.destination_port_range, "")
      destination_port_ranges  = core::try(rule.destination_port_ranges, null) != null ? rule.destination_port_ranges : []
    }]

    inbound_allow_rdp_protocol_rules = [for rule in local.normalized_rules : rule if rule.direction == "Inbound" && rule.access == "Allow" && core::contains(["Tcp", "*"], rule.protocol)]

    internet_source_rules = [for rule in local.inbound_allow_rdp_protocol_rules : rule if core::contains(["0.0.0.0/0", "::/0", "Internet", "*"], rule.source_address_prefix) || core::length([for source in rule.source_address_prefixes : source if core::contains(["0.0.0.0/0", "::/0", "Internet", "*"], source)]) > 0]

    violating_rules = [for rule in local.internet_source_rules : rule if core::contains(["3389", "*"], rule.destination_port_range) || (core::try(core::parseint(core::try(core::split("-", rule.destination_port_range)[0], ""), 10), -1) <= 3389 && core::try(core::parseint(core::try(core::split("-", rule.destination_port_range)[1], ""), 10), -1) >= 3389) || core::length([for port_range in rule.destination_port_ranges : port_range if core::contains(["3389", "*"], port_range) || (core::try(core::parseint(core::try(core::split("-", port_range)[0], ""), 10), -1) <= 3389 && core::try(core::parseint(core::try(core::split("-", port_range)[1], ""), 10), -1) >= 3389)]) > 0]
  }

  enforcement_level = input.rdp-internet-restrict-enforcement-level
  enforce {
    condition     = core::length(local.violating_rules) == 0
    error_message = "Network security groups must not allow inbound TCP RDP access on port 3389 from 0.0.0.0/0, ::/0, Internet, or any source. Remove or narrowly restrict the offending inline security rule."
  }
}

resource_policy "azurerm_network_security_rule" "restrict_rdp_from_internet_standalone" {
  locals {
    direction        = core::try(attrs.direction, "")
    access           = core::try(attrs.access, "")
    protocol         = core::try(attrs.protocol, "")
    source_prefix    = core::try(attrs.source_address_prefix, "")
    source_prefixes  = core::try(attrs.source_address_prefixes, null) != null ? attrs.source_address_prefixes : []
    dest_port_range  = core::try(attrs.destination_port_range, "")
    dest_port_ranges = core::try(attrs.destination_port_ranges, null) != null ? attrs.destination_port_ranges : []

    is_inbound_allow_tcp = local.direction == "Inbound" && local.access == "Allow" && core::contains(["Tcp", "*"], local.protocol)
    is_internet_source   = core::contains(["0.0.0.0/0", "::/0", "Internet", "*"], local.source_prefix) || core::length([for source in local.source_prefixes : source if core::contains(["0.0.0.0/0", "::/0", "Internet", "*"], source)]) > 0
    is_rdp_port          = core::contains(["3389", "*"], local.dest_port_range) || (core::try(core::parseint(core::try(core::split("-", local.dest_port_range)[0], ""), 10), -1) <= 3389 && core::try(core::parseint(core::try(core::split("-", local.dest_port_range)[1], ""), 10), -1) >= 3389) || core::length([for port_range in local.dest_port_ranges : port_range if core::contains(["3389", "*"], port_range) || (core::try(core::parseint(core::try(core::split("-", port_range)[0], ""), 10), -1) <= 3389 && core::try(core::parseint(core::try(core::split("-", port_range)[1], ""), 10), -1) >= 3389)]) > 0
  }

  enforcement_level = input.rdp-internet-restrict-enforcement-level
  enforce {
    condition     = !(local.is_inbound_allow_tcp && local.is_internet_source && local.is_rdp_port)
    error_message = "Standalone network security rules must not allow inbound TCP RDP access on port 3389 from 0.0.0.0/0, ::/0, Internet, or any source."
  }
}
