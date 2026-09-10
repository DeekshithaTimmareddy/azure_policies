# Copyright IBM Corp. 2026

# Ensure that 'Default to Microsoft Entra authorization in the Azure portal' is Set to 'Enabled'

policy {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = ">= 4.0.0, < 6.0.0"
    }
  }
}

input "default-entra-auth-enforcement-level" {
  type    = string
  default = "advisory"
}

resource_policy "azurerm_storage_account" "default_entra_authorization_enabled" {
  locals {
    default_to_oauth_authentication_raw = core::try(attrs.default_to_oauth_authentication, null)
    default_to_oauth_authentication     = local.default_to_oauth_authentication_raw == null ? false : local.default_to_oauth_authentication_raw
  }

  enforcement_level = input.default-entra-auth-enforcement-level
  enforce {
    condition     = local.default_to_oauth_authentication == true
    error_message = "Storage accounts must set default_to_oauth_authentication to true to default Azure portal access to Microsoft Entra authorization."
  }
}
