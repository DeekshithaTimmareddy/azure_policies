resource_policy "azurerm_security_center_subscription_pricing" "defender_for_key_vault_on" {
    filter = core::try(attrs.resource_type, null) == "KeyVaults"

    locals {
        tier_raw = core::try(attrs.tier, null)
        tier     = local.tier_raw == null ? "" : local.tier_raw
    }

    enforcement_level = "advisory"

    enforce {
        condition     = local.tier == "Standard"
        error_message = "Microsoft Defender for Key Vault must be enabled: azurerm_security_center_subscription_pricing for resource_type 'KeyVaults' must set tier = \"Standard\" (got \"${local.tier}\")."
    }
}
