# Copyright IBM Corp. 2026

# Ensure that Microsoft Defender CSPM is Enabled

policy {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "= 5.8.0"
    }
  }
}

input "defender-cspm-enabled-enforcement-level" {
  type    = string
  default = "advisory"
}

resource_policy "azurerm_security_center_subscription_pricing" "defender_cspm_on" {
  locals {
    resource_type_raw = core::try(attrs.resource_type, null)
    resource_type     = local.resource_type_raw == null ? "VirtualMachines" : local.resource_type_raw
  }

  filter = local.resource_type == "CloudPosture"

  enforcement_level = input.defender-cspm-enabled-enforcement-level
  enforce {
    condition     = core::try(attrs.tier, "") == "Standard"
    error_message = "Microsoft Defender CSPM (CloudPosture) must be enabled with pricing tier Standard."
  }
}
