policy {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "= 5.8.0"
    }
  }
}

resource_policy "azurerm_security_center_subscription_pricing" "defender_for_storage_on" {
  locals {
    resource_type_raw = core::try(attrs.resource_type, null)
    resource_type     = local.resource_type_raw == null ? "VirtualMachines" : local.resource_type_raw
    tier_raw          = core::try(attrs.tier, null)
    tier              = local.tier_raw == null ? "" : local.tier_raw
  }

  filter = core::lower(local.resource_type) == "storageaccounts"

  enforcement_level = "advisory"

  enforce {
    condition     = core::lower(local.tier) == "standard"
    error_message = "Microsoft Defender for Storage must be enabled: azurerm_security_center_subscription_pricing with resource_type 'StorageAccounts' must have tier 'Standard'."
  }
}
