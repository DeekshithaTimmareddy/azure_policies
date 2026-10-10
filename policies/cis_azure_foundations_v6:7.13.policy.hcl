policy {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = ">= 4.0.0, < 6.0.0"
    }
  }
}

resource_policy "azurerm_application_gateway" "7_13" {
  enforcement_level = "advisory"

  locals {
    http2_enabled = core::try(attrs.http2_enabled == null ? false : attrs.http2_enabled, null)
  }

  enforce {
    condition     = local.http2_enabled == null ? true : local.http2_enabled == true
    error_message = "The Application Gateway must enable HTTP2 with http2_enabled = true. AzureRM defaults this setting to false."
  }
}
