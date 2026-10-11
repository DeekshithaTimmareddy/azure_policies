# Copyright IBM Corp. 2026

# Ensure that HTTP2 is Enabled on Application Gateway

policy {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = ">= 4.0.0, < 6.0.0"
    }
  }
}

input "application-gateway-http2-enabled-enforcement-level" {
  type    = string
  default = "advisory"
}

resource_policy "azurerm_application_gateway" "application_gateway_http2_enabled" {
  locals {
    http2_enabled = core::try(attrs.http2_enabled == null ? false : attrs.http2_enabled, null)
  }

  enforcement_level = input.application-gateway-http2-enabled-enforcement-level
  enforce {
    condition     = local.http2_enabled == null ? true : local.http2_enabled == true
    error_message = "The Application Gateway must enable HTTP2 with http2_enabled = true. AzureRM defaults this setting to false."
  }
}
