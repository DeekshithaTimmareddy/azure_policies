# Copyright IBM Corp. 2026

# Ensure That Microsoft Defender for Azure Cosmos DB Is Set To 'On'

policy {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = ">= 4.0.0, < 6.0.0"
    }
  }
}

input "defender-cosmosdb-on-enforcement-level" {
  type    = string
  default = "advisory"
}

resource_policy "azurerm_security_center_subscription_pricing" "cosmosdb_defender_on" {
    locals {
        tier_raw = core::try(attrs.tier, null)
        tier = local.tier_raw == null ? "" : local.tier_raw
    }

    filter = core::try(attrs.resource_type, null) == "CosmosDbs"

    enforcement_level = input.defender-cosmosdb-on-enforcement-level

    enforce {
        condition = local.tier == "Standard"
        error_message = "Microsoft Defender for Azure Cosmos DB must be enabled: azurerm_security_center_subscription_pricing for resource_type 'CosmosDbs' must have tier = 'Standard' (got '${local.tier}')."
    }
}
