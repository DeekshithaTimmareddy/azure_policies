# Copyright IBM Corp. 2026

# CIS Azure Foundations v6.0.0 - 7.8

policy {
    required_providers {
        azurerm = {
            source  = "hashicorp/azurerm"
            version = ">= 4.11.0, < 6.0.0"
        }
    }
}

input "vnet-flow-log-retention-enforcement-level" {
    type = string
    default = "advisory"
}

resource_policy "azurerm_network_watcher_flow_log" "7_8" {
    filter = core::try(
        core::regex("^/subscriptions/[^/]+/resourcegroups/[^/]+/providers/microsoft\\.network/virtualnetworks/[^/]+$", core::lower(core::trimspace(attrs.target_resource_id))),
        null
    ) != null

    enforcement_level = input.vnet-flow-log-retention-enforcement-level

    locals {
        days = core::try(attrs.retention_policy[0].days, null)
    }

    enforce {
        condition     = local.days == null ? true : (local.days == 0 || local.days >= 90)
        error_message = "The virtual network flow log retention must be 0 days (indefinite) or at least 90 days."
    }
}
