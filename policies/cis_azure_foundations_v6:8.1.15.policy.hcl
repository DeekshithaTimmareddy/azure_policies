policy {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "= 5.8.0"
    }
    azapi = {
      source  = "Azure/azapi"
      version = "= 2.5.0"
    }
  }
}

resource_policy "azurerm_security_center_contact" "attack_path_notifications_unavailable" {
  enforcement_level = "advisory"

  enforce {
    condition     = false
    error_message = "AzureRM azurerm_security_center_contact does not expose notificationsSources or minimalRiskLevel. Use the AzAPI securityContacts resource to verify attack-path notifications."
  }
}

resource_policy "azapi_resource" "attack_path_notifications_enabled" {
  locals {
    resource_type_raw = core::try(attrs.type, null)
    resource_type     = local.resource_type_raw == null ? "" : core::lower(local.resource_type_raw)
    resource_name_raw = core::try(attrs.name, null)
    resource_name     = local.resource_name_raw == null ? "" : core::lower(local.resource_name_raw)
    api_resource      = core::split("@", local.resource_type)[0]
    api_version       = core::try(core::split("@", local.resource_type)[1], "")
    sources_raw       = core::try(attrs.body.properties.notificationsSources, null)
    sources           = local.sources_raw == null ? [] : local.sources_raw
    attack_sources    = [for source in local.sources : source if core::try(core::lower(source.sourceType), "") == "attackpath"]
    invalid_levels    = [for source in local.attack_sources : source if !core::contains(["critical", "high", "medium", "low"], core::try(core::lower(source.minimalRiskLevel), ""))]
  }

  filter = local.api_resource == "microsoft.security/securitycontacts" && local.resource_name == "default"

  enforcement_level = "advisory"

  enforce {
    condition     = local.api_version == "2023-12-01-preview" && core::length(local.attack_sources) > 0 && core::length(local.invalid_levels) == 0
    error_message = "The default Microsoft.Security/securityContacts resource must use API 2023-12-01-preview and include an AttackPath notification source with minimalRiskLevel Critical, High, Medium, or Low."
  }
}
