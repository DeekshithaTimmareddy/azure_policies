resource_policy "azurerm_security_center_subscription_pricing" "defender_for_sql_on_machines_on" {
  filter = core::try(attrs.resource_type, "") == "SqlServerVirtualMachines"

  locals {
    tier_raw = core::try(attrs.tier, null)
    tier     = local.tier_raw == null ? "" : local.tier_raw
  }

  enforcement_level = "advisory"

  enforce {
    condition     = local.tier == "Standard"
    error_message = "Microsoft Defender for SQL servers on machines must be set to 'On': azurerm_security_center_subscription_pricing for resource_type 'SqlServerVirtualMachines' must have tier = 'Standard' (found: '${local.tier}')."
  }
}
