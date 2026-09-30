# Copyright IBM Corp. 2026

# Ensure 'No Public IP' is Set to 'Enabled'

policy {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = ">= 4.0.0, < 6.0.0"
    }
  }
}

input "databricks-no-public-ip-enabled-enforcement-level" {
  type    = string
  default = "advisory"
}

resource_policy "azurerm_databricks_workspace" "no_public_ip_enabled" {
  enforcement_level = input.databricks-no-public-ip-enabled-enforcement-level

  enforce {
    condition     = core::try(attrs.custom_parameters[0].no_public_ip, true) != false
    error_message = "Azure Databricks workspace must have Secure Cluster Connectivity (No Public IP) enabled: custom_parameters.no_public_ip must be true."
  }
}
