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

resource_policy "azurerm_storage_account" "key_rotation_reminder_unverifiable" {
  enforcement_level = "advisory"

  enforce {
    condition     = false
    error_message = "AzureRM 5.8.0 does not expose KeyPolicy.KeyExpirationPeriodInDays. An AzureRM storage account alone cannot verify this reminder; use an azapi_resource or azapi_update_resource for the same account with properties.keyPolicy.keyExpirationPeriodInDays, or verify the setting directly in Azure. sas_policy.expiration_period is unrelated."
  }
}

resource_policy "azapi_resource" "key_rotation_reminder_enabled" {
  locals {
    resource_type_raw     = core::try(attrs.type, null)
    resource_type         = local.resource_type_raw == null ? "" : core::lower(local.resource_type_raw)
    api_resource          = core::split("@", local.resource_type)[0]
    expiration_days       = core::try(attrs.body.properties.keyPolicy.keyExpirationPeriodInDays, null)
    expiration_days_valid = core::try(local.expiration_days > 0, false)
  }

  filter = local.api_resource == "microsoft.storage/storageaccounts"

  enforcement_level = "advisory"

  enforce {
    condition     = local.expiration_days_valid
    error_message = "The storage account resource must set properties.keyPolicy.keyExpirationPeriodInDays to a positive number of days. The CIS benchmark prescribes 90 days but allows adjustment to organizational requirements."
  }
}

resource_policy "azapi_update_resource" "key_rotation_reminder_enabled" {
  locals {
    resource_type_raw     = core::try(attrs.type, null)
    resource_type         = local.resource_type_raw == null ? "" : core::lower(local.resource_type_raw)
    api_resource          = core::split("@", local.resource_type)[0]
    expiration_days       = core::try(attrs.body.properties.keyPolicy.keyExpirationPeriodInDays, null)
    expiration_days_valid = core::try(local.expiration_days > 0, false)
  }

  filter = local.api_resource == "microsoft.storage/storageaccounts"

  enforcement_level = "advisory"

  enforce {
    condition     = local.expiration_days_valid
    error_message = "The storage account update must set properties.keyPolicy.keyExpirationPeriodInDays to a positive number of days. The CIS benchmark prescribes 90 days but allows adjustment to organizational requirements."
  }
}
