policy {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "= 5.8.0"
    }
  }
}

resource_policy "azurerm_security_center_subscription_pricing" "defender_cspm_on" {
  locals {
    resource_type_raw = core::try(attrs.resource_type, null)
    resource_type     = local.resource_type_raw == null ? "VirtualMachines" : local.resource_type_raw
  }

  filter = local.resource_type == "CloudPosture"

  enforcement_level = "advisory"

  enforce {
    condition     = core::try(attrs.tier, "") == "Standard"
    error_message = "Microsoft Defender CSPM (CloudPosture) must be enabled with pricing tier Standard."
  }
}
