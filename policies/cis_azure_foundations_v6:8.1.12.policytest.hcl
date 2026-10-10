policytest {
  targets = ["cis_azure_foundations_v6:8.1.12.policy.hcl"]
}

resource "azurerm_security_center_contact" "fail_unsupported_azure_rm_representation" {
  expect_failure = true
  attrs = {
    name                = "default"
    email               = "security@example.com"
    alert_notifications = true
    alerts_to_admins    = true
  }
}

resource "azapi_resource" "pass_default_contact_owner_enabled" {
  attrs = {
    type = "Microsoft.Security/securityContacts@2023-12-01-preview"
    name = "default"
    body = {
      properties = {
        notificationsByRole = {
          state = "On"
          roles = ["Owner"]
        }
      }
    }
  }
}

resource "azapi_resource" "pass_default_contact_owner_among_roles" {
  attrs = {
    type = "Microsoft.Security/securityContacts@2023-12-01-preview"
    name = "default"
    body = {
      properties = {
        notificationsByRole = {
          state = "On"
          roles = ["Contributor", "Owner"]
        }
      }
    }
  }
}

resource "azapi_resource" "fail_default_contact_role_notifications_off" {
  expect_failure = true
  attrs = {
    type = "Microsoft.Security/securityContacts@2023-12-01-preview"
    name = "default"
    body = {
      properties = {
        notificationsByRole = {
          state = "Off"
          roles = ["Owner"]
        }
      }
    }
  }
}

resource "azapi_resource" "fail_default_contact_owner_missing" {
  expect_failure = true
  attrs = {
    type = "Microsoft.Security/securityContacts@2023-12-01-preview"
    name = "default"
    body = {
      properties = {
        notificationsByRole = {
          state = "On"
          roles = ["Contributor"]
        }
      }
    }
  }
}

resource "azapi_resource" "fail_default_contact_roles_missing" {
  expect_failure = true
  attrs = {
    type = "Microsoft.Security/securityContacts@2023-12-01-preview"
    name = "default"
    body = {
      properties = {
        notificationsByRole = {
          state = "On"
          roles = null
        }
      }
    }
  }
}

resource "azapi_resource" "fail_default_contact_notifications_by_role_missing" {
  expect_failure = true
  attrs = {
    type = "Microsoft.Security/securityContacts@2023-12-01-preview"
    name = "default"
    body = {
      properties = {}
    }
  }
}

resource "azapi_resource" "fail_unsupported_security_contact_api_version" {
  expect_failure = true
  attrs = {
    type = "Microsoft.Security/securityContacts@2020-01-01-preview"
    name = "default"
    body = {
      properties = {
        notificationsByRole = "Owner"
      }
    }
  }
}

resource "azapi_resource" "pass_unrelated_azapi_resource" {
  attrs = {
    type = "Microsoft.Security/pricings@2023-12-01-preview"
    name = "default"
    body = {
      properties = {}
    }
  }
}

resource "azapi_resource" "pass_non_default_contact_name" {
  attrs = {
    type = "Microsoft.Security/securityContacts@2023-12-01-preview"
    name = "secondary"
    body = {
      properties = {
        notificationsByRole = {
          state = "Off"
          roles = []
        }
      }
    }
  }
}
