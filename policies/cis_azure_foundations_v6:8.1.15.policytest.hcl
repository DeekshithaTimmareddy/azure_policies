policytest {
  targets = ["cis_azure_foundations_v6:8.1.15.policy.hcl"]
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

resource "azapi_resource" "pass_attack_path_critical" {
  attrs = {
    type = "Microsoft.Security/securityContacts@2023-12-01-preview"
    name = "default"
    body = {
      properties = {
        notificationsSources = [{
          sourceType       = "AttackPath"
          minimalRiskLevel = "Critical"
        }]
      }
    }
  }
}

resource "azapi_resource" "pass_attack_path_high" {
  attrs = {
    type = "Microsoft.Security/securityContacts@2023-12-01-preview"
    name = "default"
    body = {
      properties = {
        notificationsSources = [{
          sourceType       = "AttackPath"
          minimalRiskLevel = "High"
        }]
      }
    }
  }
}

resource "azapi_resource" "pass_attack_path_medium" {
  attrs = {
    type = "Microsoft.Security/securityContacts@2023-12-01-preview"
    name = "default"
    body = {
      properties = {
        notificationsSources = [{
          sourceType       = "AttackPath"
          minimalRiskLevel = "Medium"
        }]
      }
    }
  }
}

resource "azapi_resource" "pass_attack_path_low" {
  attrs = {
    type = "Microsoft.Security/securityContacts@2023-12-01-preview"
    name = "default"
    body = {
      properties = {
        notificationsSources = [{
          sourceType       = "AttackPath"
          minimalRiskLevel = "Low"
        }]
      }
    }
  }
}

resource "azapi_resource" "pass_alert_and_attack_path_sources" {
  attrs = {
    type = "Microsoft.Security/securityContacts@2023-12-01-preview"
    name = "default"
    body = {
      properties = {
        notificationsSources = [
          {
            sourceType      = "Alert"
            minimalSeverity = "High"
          },
          {
            sourceType       = "AttackPath"
            minimalRiskLevel = "High"
          }
        ]
      }
    }
  }
}

resource "azapi_resource" "fail_attack_path_source_missing" {
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

resource "azapi_resource" "fail_notifications_sources_missing" {
  expect_failure = true
  attrs = {
    type = "Microsoft.Security/securityContacts@2023-12-01-preview"
    name = "default"
    body = {
      properties = {}
    }
  }
}

resource "azapi_resource" "fail_attack_path_risk_missing" {
  expect_failure = true
  attrs = {
    type = "Microsoft.Security/securityContacts@2023-12-01-preview"
    name = "default"
    body = {
      properties = {
        notificationsSources = [{
          sourceType = "AttackPath"
        }]
      }
    }
  }
}

resource "azapi_resource" "fail_attack_path_risk_invalid" {
  expect_failure = true
  attrs = {
    type = "Microsoft.Security/securityContacts@2023-12-01-preview"
    name = "default"
    body = {
      properties = {
        notificationsSources = [{
          sourceType       = "AttackPath"
          minimalRiskLevel = "Informational"
        }]
      }
    }
  }
}

resource "azapi_resource" "fail_duplicate_attack_path_with_invalid_level" {
  expect_failure = true
  attrs = {
    type = "Microsoft.Security/securityContacts@2023-12-01-preview"
    name = "default"
    body = {
      properties = {
        notificationsSources = [
          {
            sourceType       = "AttackPath"
            minimalRiskLevel = "High"
          },
          {
            sourceType       = "AttackPath"
            minimalRiskLevel = "Informational"
          }
        ]
      }
    }
  }
}

resource "azapi_resource" "fail_unsupported_api_version" {
  expect_failure = true
  attrs = {
    type = "Microsoft.Security/securityContacts@2020-01-01-preview"
    name = "default"
    body = {
      properties = {
        notificationsSources = [{
          sourceType       = "AttackPath"
          minimalRiskLevel = "High"
        }]
      }
    }
  }
}

resource "azapi_resource" "pass_unrelated_resource_type" {
  attrs = {
    type = "Microsoft.Security/pricings@2023-12-01-preview"
    name = "default"
    body = {
      properties = {}
    }
  }
}

resource "azapi_resource" "pass_non_default_contact" {
  attrs = {
    type = "Microsoft.Security/securityContacts@2023-12-01-preview"
    name = "secondary"
    body = {
      properties = {
        notificationsSources = []
      }
    }
  }
}
