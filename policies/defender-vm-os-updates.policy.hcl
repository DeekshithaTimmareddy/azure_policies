resource_policy "azurerm_security_center_subscription_pricing" "8_1_10" {
    locals {
        resource_type_raw = core::try(attrs.resource_type, null)
        resource_type     = local.resource_type_raw == null ? "VirtualMachines" : local.resource_type_raw

        tier_raw = core::try(attrs.tier, null)
        tier     = local.tier_raw == null ? "" : local.tier_raw
    }

    filter = local.resource_type == "VirtualMachines"

    enforcement_level = "advisory"

    enforce {
        condition     = local.tier == "Standard"
        error_message = "Microsoft Defender for Cloud must enable the Standard plan for VirtualMachines (tier = \"Standard\") so VM operating systems are checked for updates. Found tier: \"${local.tier}\"."
    }
}
