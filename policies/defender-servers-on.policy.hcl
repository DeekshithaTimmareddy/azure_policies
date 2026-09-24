resource_policy "azurerm_security_center_subscription_pricing" "defender_for_servers_on" {
  locals {
    resource_type_raw = core::try(attrs.resource_type, null)
    resource_type = local.resource_type_raw == null ? "VirtualMachines" : local.resource_type_raw
    tier_raw      = core::try(attrs.tier, null)
  }

  filter = local.resource_type == "VirtualMachines"

  enforcement_level = "advisory"

  enforce {
    condition     = local.tier_raw == "Standard"
    error_message = "Defender for Servers must be On: azurerm_security_center_subscription_pricing for resource_type=VirtualMachines must set tier = \"Standard\"."
  }
}
