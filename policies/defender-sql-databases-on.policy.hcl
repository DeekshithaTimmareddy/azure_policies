resource_policy "azurerm_security_center_subscription_pricing" "sql_databases_defender_on" {
    filter = core::try(attrs.resource_type, "") == "SqlServers"

    locals {
        tier_raw = core::try(attrs.tier, null)
        tier     = local.tier_raw == null ? "" : local.tier_raw
    }

    enforcement_level = "advisory"

    enforce {
        condition     = local.tier == "Standard"
        error_message = "Microsoft Defender for Azure SQL Databases must be enabled: azurerm_security_center_subscription_pricing for the 'SqlServers' plan must set tier to 'Standard' (found: '${local.tier}')."
    }
}
