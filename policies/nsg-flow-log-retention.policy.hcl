# Copyright IBM Corp. 2026

# CIS Azure Foundations v6.0.0 - 7.5

policy {
    required_providers {
        azurerm = {
            source  = "hashicorp/azurerm"
            version = ">= 4.11.0, < 6.0.0"
        }
    }
}

input "nsg-flow-log-retention-enforcement-level" {
    type = string
    default = "advisory"
}

resource_policy "azurerm_network_watcher_flow_log" "7_5" {
    filter = core::try(
        core::regex("^/subscriptions/[^/]+/resourcegroups/[^/]+/providers/microsoft\\.network/networksecuritygroups/[^/]+$", core::lower(core::trimspace(attrs.target_resource_id))),
        null
    ) != null

    enforcement_level = input.nsg-flow-log-retention-enforcement-level

    locals {
        enabled = core::try(attrs.enabled, null)
        days    = core::try(attrs.retention_policy[0].days, null)
        days_ok = local.days == null ? true : (local.days == 0 || local.days >= 90)
    }

    enforce {
        condition     = local.enabled != false
        error_message = "The NSG flow log must be enabled."
    }

    enforce {
        condition     = local.days_ok
        error_message = "The NSG flow log retention must be 0 days (indefinite) or at least 90 days."
    }
}
