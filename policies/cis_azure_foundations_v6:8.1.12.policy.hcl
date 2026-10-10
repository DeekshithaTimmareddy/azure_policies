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

resource_policy "azurerm_security_center_contact" "security_alerts_to_owners" {
  enforcement_level = "advisory"

  enforce {
    condition     = false
    error_message = "AzureRM azurerm_security_center_contact does not expose notificationsByRole.roles, so Owner-role compliance cannot be verified. Manage the default security contact with azapi_resource to validate the required role."
  }
}

resource_policy "azapi_resource" "security_contact_owner_role" {
  locals {
    resource_type_raw = core::try(attrs.type, null)
    resource_type     = local.resource_type_raw == null ? "" : core::lower(local.resource_type_raw)
    resource_name_raw = core::try(attrs.name, null)
    resource_name     = local.resource_name_raw == null ? "" : core::lower(local.resource_name_raw)
    api_resource  = core::split("@", local.resource_type)[0]
    api_version   = core::try(core::split("@", local.resource_type)[1], "")
    role_state_raw = core::try(attrs.body.properties.notificationsByRole.state, null)
    role_state     = local.role_state_raw == null ? "" : local.role_state_raw
    roles_raw     = core::try(attrs.body.properties.notificationsByRole.roles, null)
    roles         = local.roles_raw == null ? [] : local.roles_raw
  }

  filter = local.api_resource == "microsoft.security/securitycontacts" && local.resource_name == "default"

  enforcement_level = "advisory"

  enforce {
    condition     = local.api_version == "2023-12-01-preview" && core::lower(local.role_state) == "on" && core::contains(local.roles, "Owner")
    error_message = "The default Microsoft.Security/securityContacts resource must use API 2023-12-01-preview and set notificationsByRole.state to On with Owner in notificationsByRole.roles."
  }
}
