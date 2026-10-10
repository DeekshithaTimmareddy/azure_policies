policytest {
  targets = ["cis_azure_foundations_v6:8.1.14.policy.hcl"]
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

resource "azapi_resource" "pass_high_severity_enabled" {
  attrs = {
    type = "Microsoft.Security/securityContacts@2020-01-01-preview"
    name = "default"
    body = {
      properties = {
        alertNotifications = {
          state           = "On"
          minimalSeverity = "High"
        }
      }
    }
  }
}

resource "azapi_resource" "pass_medium_severity_enabled" {
  attrs = {
    type = "Microsoft.Security/securityContacts@2020-01-01-preview"
    name = "default"
    body = {
      properties = {
        alertNotifications = {
          state           = "On"
          minimalSeverity = "Medium"
        }
      }
    }
  }
}

resource "azapi_resource" "pass_low_severity_enabled" {
  attrs = {
    type = "Microsoft.Security/securityContacts@2020-01-01-preview"
    name = "default"
    body = {
      properties = {
        alertNotifications = {
          state           = "On"
          minimalSeverity = "Low"
        }
      }
    }
  }
}

resource "azapi_resource" "fail_notifications_off" {
  expect_failure = true
  attrs = {
    type = "Microsoft.Security/securityContacts@2020-01-01-preview"
    name = "default"
    body = {
      properties = {
        alertNotifications = {
          state           = "Off"
          minimalSeverity = "High"
        }
      }
    }
  }
}

resource "azapi_resource" "fail_severity_missing" {
  expect_failure = true
  attrs = {
    type = "Microsoft.Security/securityContacts@2020-01-01-preview"
    name = "default"
    body = {
      properties = {
        alertNotifications = {
          state = "On"
        }
      }
    }
  }
}

resource "azapi_resource" "fail_severity_invalid" {
  expect_failure = true
  attrs = {
    type = "Microsoft.Security/securityContacts@2020-01-01-preview"
    name = "default"
    body = {
      properties = {
        alertNotifications = {
          state           = "On"
          minimalSeverity = "Informational"
        }
      }
    }
  }
}

resource "azapi_resource" "fail_alert_notifications_missing" {
  expect_failure = true
  attrs = {
    type = "Microsoft.Security/securityContacts@2020-01-01-preview"
    name = "default"
    body = {
      properties = {}
    }
  }
}

resource "azapi_resource" "fail_unsupported_api_version" {
  expect_failure = true
  attrs = {
    type = "Microsoft.Security/securityContacts@2023-12-01-preview"
    name = "default"
    body = {
      properties = {
        notificationsSources = [{
          sourceType      = "Alert"
          minimalSeverity = "High"
        }]
      }
    }
  }
}

resource "azapi_resource" "pass_unrelated_resource_type" {
  attrs = {
    type = "Microsoft.Security/pricings@2020-01-01-preview"
    name = "default"
    body = {
      properties = {}
    }
  }
}

resource "azapi_resource" "pass_non_default_contact" {
  attrs = {
    type = "Microsoft.Security/securityContacts@2020-01-01-preview"
    name = "secondary"
    body = {
      properties = {
        alertNotifications = {
          state           = "Off"
          minimalSeverity = "High"
        }
      }
    }
  }
}
