# Copyright IBM Corp. 2026

# CIS Azure Foundations v6.0.0 - 7.6

policy {
    required_providers {
        azurerm = {
            source  = "hashicorp/azurerm"
            version = ">= 4.0.0, < 6.0.0"
        }
    }
}

locals {
    network_watcher_enabled_watchers = [for w in core::getresources("azurerm_network_watcher", {}) : {
        location = core::try(core::lower(core::join("", core::split(" ", core::trimspace(w.location)))), null)
        subscription = core::try(core::regex("^/subscriptions/([^/]+)/", core::lower(w.id))[0], null)
    }]
}

input "network-watcher-enabled-enforcement-level" {
    type = string
    default = "advisory"
}

resource_policy "azurerm_virtual_network" "7_6_region_coverage" {
    enforcement_level = input.network-watcher-enabled-enforcement-level

    locals {
        location = core::try(core::lower(core::join("", core::split(" ", core::trimspace(attrs.location)))), null)
        subscription = core::try(core::regex("^/subscriptions/([^/]+)/", core::lower(attrs.id))[0], null)
        matching_watchers = [
            for w in local.network_watcher_enabled_watchers : w
            if w.location != null && w.location == local.location &&
                (local.subscription == null || w.subscription == null || w.subscription == local.subscription)
        ]
    }

    enforce {
        condition     = local.location == null ? true : (local.location != "" && core::length(local.matching_watchers) > 0)
        error_message = "The virtual network's region must have a Terraform-managed Network Watcher in the same subscription. Declare or import the regional watcher."
    }
}

resource_policy "azurerm_network_watcher" "7_6_watcher_location" {
    enforcement_level = input.network-watcher-enabled-enforcement-level

    locals {
        location = core::try(core::lower(core::join("", core::split(" ", core::trimspace(attrs.location)))), null)
    }

    enforce {
        condition     = local.location == null ? true : local.location != ""
        error_message = "The Network Watcher must have a nonblank Azure region."
    }
}
