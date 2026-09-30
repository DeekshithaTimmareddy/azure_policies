# Copyright IBM Corp. 2026

# Ensure Microsoft Defender for APIs is Set to 'On'

policy {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = ">= 4.0.0, < 6.0.0"
    }
  }
}

input "defender-apis-on-enforcement-level" {
  type    = string
  default = "advisory"
}

resource_policy "azurerm_security_center_subscription_pricing" "defender_for_apis_on" {
    filter = core::try(attrs.resource_type, null) == "Api"

    locals {
        tier_raw = core::try(attrs.tier, null)
        tier = local.tier_raw == null ? "" : local.tier_raw
    }

    enforcement_level = input.defender-apis-on-enforcement-level

    enforce {
        condition = local.tier == "Standard"
        error_message = "Microsoft Defender for APIs must be enabled: azurerm_security_center_subscription_pricing for the 'Api' plan must set tier = \"Standard\" (got: \"${local.tier}\")."
    }
}
