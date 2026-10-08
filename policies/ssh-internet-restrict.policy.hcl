# Copyright IBM Corp. 2026

# CIS Azure Foundations v6.0.0 - 7.2

policy {
    required_providers {
        azurerm = {
            source  = "hashicorp/azurerm"
            version = ">= 4.0.0, < 6.0.0"
        }
    }
}

input "ssh-internet-restrict-enforcement-level" {
    type = string
    default = "advisory"
}

resource_policy "azurerm_network_security_group" "7_2_inline" {
    enforcement_level = input.ssh-internet-restrict-enforcement-level

    locals {
        rules = [for r in core::try([for rule in attrs.security_rule : rule], []) : {
            access    = core::try(core::lower(core::trimspace(r.access)), "")
            direction = core::try(core::lower(core::trimspace(r.direction)), "")
            protocol  = core::try(core::lower(core::trimspace(r.protocol)), "")
            ports = core::concat(
                [for p in [core::try(core::trimspace(r.destination_port_range), "")] : p if p != ""],
                core::try([for p in r.destination_port_ranges : core::trimspace(p) if p != null], [])
            )
            sources = core::concat(
                [for s in [core::try(core::lower(core::trimspace(r.source_address_prefix)), "")] : s if s != ""],
                core::try([for s in r.source_address_prefixes : core::lower(core::trimspace(s)) if s != null], [])
            )
        }]

        candidates = [for r in local.rules : r if r.access == "allow" && r.direction == "inbound" && core::contains(["tcp", "*"], r.protocol)]
        internet_rules = [
            for r in local.candidates : r
            if core::length([for s in r.sources : s if core::contains(["*", "0.0.0.0", "internet", "any"], s) || core::endswith(s, "/0")]) > 0
        ]
        violating_rules = [
            for r in local.internet_rules : r
            if core::length([
                for p in r.ports : p
                if p == "*" ? true : core::try(
                    core::parseint(core::split("-", p)[0], 10) <= 22 &&
                    core::parseint(core::split("-", p)[core::length(core::split("-", p)) - 1], 10) >= 22,
                    false
                )
            ]) > 0
        ]
    }

    enforce {
        condition     = core::length(local.violating_rules) == 0
        error_message = "The network security group must not contain inbound Allow TCP or any-protocol rules permitting port 22 from Internet, Any, *, 0.0.0.0 or a /0 source. Remove or narrowly restrict the offending inline rule."
    }
}

resource_policy "azurerm_network_security_rule" "7_2_standalone" {
    enforcement_level = input.ssh-internet-restrict-enforcement-level

    locals {
        access    = core::try(core::lower(core::trimspace(attrs.access)), "")
        direction = core::try(core::lower(core::trimspace(attrs.direction)), "")
        protocol  = core::try(core::lower(core::trimspace(attrs.protocol)), "")
        ports = core::concat(
            [for p in [core::try(core::trimspace(attrs.destination_port_range), "")] : p if p != ""],
            core::try([for p in attrs.destination_port_ranges : core::trimspace(p) if p != null], [])
        )
        sources = core::concat(
            [for s in [core::try(core::lower(core::trimspace(attrs.source_address_prefix)), "")] : s if s != ""],
            core::try([for s in attrs.source_address_prefixes : core::lower(core::trimspace(s)) if s != null], [])
        )

        is_candidate = local.access == "allow" && local.direction == "inbound" && core::contains(["tcp", "*"], local.protocol)
        from_internet = core::length([for s in local.sources : s if core::contains(["*", "0.0.0.0", "internet", "any"], s) || core::endswith(s, "/0")]) > 0
        includes_ssh = core::length([
            for p in local.ports : p
            if p == "*" ? true : core::try(
                core::parseint(core::split("-", p)[0], 10) <= 22 &&
                core::parseint(core::split("-", p)[core::length(core::split("-", p)) - 1], 10) >= 22,
                false
            )
        ]) > 0
    }

    enforce {
        condition     = !(local.is_candidate && local.from_internet && local.includes_ssh)
        error_message = "The network security rule must not allow inbound TCP or any-protocol port 22 from Internet, Any, *, 0.0.0.0 or a /0 source. Remove or narrowly restrict the source."
    }
}
