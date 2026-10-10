resource "azurerm_storage_account" "fail_reminder_not_exposed_without_sas_policy" {
  expect_failure = true
  attrs = {
    name                     = "failreminderabsent"
    account_replication_type = "LRS"
    account_tier             = "Standard"
    location                 = "eastus"
    resource_group_name      = "rg-test"
  }
}

resource "azurerm_storage_account" "fail_reminder_not_exposed_with_sas_policy" {
  expect_failure = true
  attrs = {
    name                     = "failsasperiod"
    account_replication_type = "LRS"
    account_tier             = "Standard"
    location                 = "eastus"
    resource_group_name      = "rg-test"
    sas_policy = [{
      expiration_period = "90.00:00:00"
      expiration_action = "Log"
    }]
  }
}

resource "azurerm_storage_account" "fail_reminder_not_exposed_with_different_sas_period" {
  expect_failure = true
  attrs = {
    name                     = "failsasperiod30"
    account_replication_type = "LRS"
    account_tier             = "Standard"
    location                 = "eastus"
    resource_group_name      = "rg-test"
    sas_policy = [{
      expiration_period = "30.00:00:00"
      expiration_action = "Log"
    }]
  }
}

resource "azapi_update_resource" "pass_recommended_90_day_reminder" {
  attrs = {
    type       = "Microsoft.Storage/storageAccounts@2023-05-01"
    resource_id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-test/providers/Microsoft.Storage/storageAccounts/rotation90"
    body = {
      properties = {
        keyPolicy = {
          keyExpirationPeriodInDays = 90
        }
      }
    }
  }
}

resource "azapi_update_resource" "pass_organization_adjusted_reminder" {
  attrs = {
    type       = "Microsoft.Storage/storageAccounts@2023-05-01"
    resource_id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-test/providers/Microsoft.Storage/storageAccounts/rotation30"
    body = {
      properties = {
        keyPolicy = {
          keyExpirationPeriodInDays = 30
        }
      }
    }
  }
}

resource "azapi_resource" "pass_full_resource_90_day_reminder" {
  attrs = {
    type = "Microsoft.Storage/storageAccounts@2023-05-01"
    name = "rotation90"
    body = {
      properties = {
        keyPolicy = {
          keyExpirationPeriodInDays = 90
        }
      }
    }
  }
}

resource "azapi_resource" "pass_full_resource_organization_adjusted_reminder" {
  attrs = {
    type = "Microsoft.Storage/storageAccounts@2023-05-01"
    name = "rotation30"
    body = {
      properties = {
        keyPolicy = {
          keyExpirationPeriodInDays = 30
        }
      }
    }
  }
}

resource "azapi_resource" "fail_full_resource_key_policy_missing" {
  expect_failure = true
  attrs = {
    type = "Microsoft.Storage/storageAccounts@2023-05-01"
    name = "nokeypolicy"
    body = {
      properties = {}
    }
  }
}

resource "azapi_resource" "fail_full_resource_expiration_days_zero" {
  expect_failure = true
  attrs = {
    type = "Microsoft.Storage/storageAccounts@2023-05-01"
    name = "zerodays"
    body = {
      properties = {
        keyPolicy = {
          keyExpirationPeriodInDays = 0
        }
      }
    }
  }
}

resource "azapi_update_resource" "fail_key_policy_missing" {
  expect_failure = true
  attrs = {
    type       = "Microsoft.Storage/storageAccounts@2023-05-01"
    resource_id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-test/providers/Microsoft.Storage/storageAccounts/nokeypolicy"
    body = {
      properties = {}
    }
  }
}

resource "azapi_update_resource" "fail_expiration_days_missing" {
  expect_failure = true
  attrs = {
    type       = "Microsoft.Storage/storageAccounts@2023-05-01"
    resource_id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-test/providers/Microsoft.Storage/storageAccounts/nodays"
    body = {
      properties = {
        keyPolicy = {}
      }
    }
  }
}

resource "azapi_update_resource" "fail_expiration_days_zero" {
  expect_failure = true
  attrs = {
    type       = "Microsoft.Storage/storageAccounts@2023-05-01"
    resource_id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-test/providers/Microsoft.Storage/storageAccounts/zerodays"
    body = {
      properties = {
        keyPolicy = {
          keyExpirationPeriodInDays = 0
        }
      }
    }
  }
}

resource "azapi_update_resource" "fail_sas_policy_is_not_key_policy" {
  expect_failure = true
  attrs = {
    type       = "Microsoft.Storage/storageAccounts@2023-05-01"
    resource_id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-test/providers/Microsoft.Storage/storageAccounts/sasonly"
    body = {
      properties = {
        sasPolicy = {
          expirationPeriod = "90.00:00:00"
          expirationAction = "Log"
        }
      }
    }
  }
}

resource "azapi_update_resource" "pass_unrelated_resource_type_is_out_of_scope" {
  attrs = {
    type       = "Microsoft.Storage/storageAccounts/blobServices@2023-05-01"
    resource_id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-test/providers/Microsoft.Storage/storageAccounts/unrelated/blobServices/default"
    body = {
      properties = {
        keyPolicy = {
          keyExpirationPeriodInDays = 90
        }
      }
    }
  }
}

resource "azapi_resource" "pass_unrelated_resource_type_is_out_of_scope" {
  attrs = {
    type = "Microsoft.Storage/storageAccounts/blobServices@2023-05-01"
    name = "default"
    body = {
      properties = {
        keyPolicy = {
          keyExpirationPeriodInDays = 90
        }
      }
    }
  }
}

resource "azapi_update_resource" "pass_supported_newer_api_version" {
  attrs = {
    type       = "Microsoft.Storage/storageAccounts@2025-06-01"
    resource_id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-test/providers/Microsoft.Storage/storageAccounts/newerapi"
    body = {
      properties = {
        keyPolicy = {
          keyExpirationPeriodInDays = 90
        }
      }
    }
  }
}
