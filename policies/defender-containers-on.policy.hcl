resource_policy "azurerm_security_center_subscription_pricing" "8_1_4_1" {
  filter = core::try(attrs.resource_type, null) == "Containers"

  locals {
    tier_raw = core::try(attrs.tier, null)
    tier     = local.tier_raw == null ? "" : local.tier_raw
  }

  enforcement_level = "advisory"

  enforce {
    condition     = local.tier == "Standard"
    error_message = "Microsoft Defender for Containers must be On: azurerm_security_center_subscription_pricing for resource_type=Containers must set tier = \"Standard\"."
  }
}
