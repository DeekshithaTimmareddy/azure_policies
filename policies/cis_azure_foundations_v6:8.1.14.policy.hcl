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

resource_policy "azurerm_security_center_contact" "alert_severity_unavailable" {
  enforcement_level = "advisory"

  enforce {
    condition     = false
    error_message = "AzureRM azurerm_security_center_contact does not expose alertNotifications.minimalSeverity. Manage the default security contact with azapi_resource to verify alert notification state and severity."
  }
}

resource_policy "azapi_resource" "alert_notifications_enabled" {
  locals {
    resource_type_raw = core::try(attrs.type, null)
    resource_type     = local.resource_type_raw == null ? "" : core::lower(local.resource_type_raw)
    resource_name_raw = core::try(attrs.name, null)
    resource_name     = local.resource_name_raw == null ? "" : core::lower(local.resource_name_raw)
    api_resource      = core::split("@", local.resource_type)[0]
    api_version       = core::try(core::split("@", local.resource_type)[1], "")
    state_raw         = core::try(attrs.body.properties.alertNotifications.state, null)
    state             = local.state_raw == null ? "" : core::lower(local.state_raw)
    severity_raw      = core::try(attrs.body.properties.alertNotifications.minimalSeverity, null)
    severity          = local.severity_raw == null ? "" : core::lower(local.severity_raw)
  }

  filter = local.api_resource == "microsoft.security/securitycontacts" && local.resource_name == "default"

  enforcement_level = "advisory"

  enforce {
    condition     = local.api_version == "2020-01-01-preview" && local.state == "on" && core::contains(["high", "medium", "low"], local.severity)
    error_message = "The default Microsoft.Security/securityContacts resource must use API 2020-01-01-preview with alertNotifications.state On and minimalSeverity set to High, Medium, or Low."
  }
}
