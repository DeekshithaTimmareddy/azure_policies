# Copyright IBM Corp. 2026

# Ensure That Microsoft Defender for Open-Source Relational Databases Is Set To 'On'

policy {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = ">= 4.0.0, < 6.0.0"
    }
  }
}

input "defender-open-source-relational-databases-on-enforcement-level" {
  type    = string
  default = "advisory"
}

resource_policy "azurerm_security_center_subscription_pricing" "defender_opensource_relational_db_standard" {

    locals {
        resource_type_raw = core::try(attrs.resource_type, null)
        resource_type     = local.resource_type_raw == null ? "" : core::lower(local.resource_type_raw)

        tier_raw = core::try(attrs.tier, null)
        tier     = local.tier_raw == null ? "" : core::lower(local.tier_raw)
    }

    filter = local.resource_type == "opensourcerelationaldatabases"

    enforcement_level = input.defender-open-source-relational-databases-on-enforcement-level

    enforce {
        condition = local.tier == "standard"
        error_message = "Microsoft Defender for open-source relational databases must be enabled: azurerm_security_center_subscription_pricing for resource_type 'OpenSourceRelationalDatabases' must set tier = 'Standard'."
    }
}
