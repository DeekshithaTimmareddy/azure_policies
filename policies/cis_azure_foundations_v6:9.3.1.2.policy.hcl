policy {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "= 5.8.0"
    }
  }
}

resource_policy "azurerm_storage_account" "access_key_rotation_requires_live_evidence" {
  enforcement_level = "advisory"

  enforce {
    condition     = false
    error_message = "Terraform configuration does not prove that storage account access keys were successfully regenerated within the last 90 days. Verify successful Microsoft.Storage/storageAccounts/regenerateKey/action events for the account in the Azure Activity Log and review the Last rotated date of each key in the portal."
  }
}

resource_policy "azurerm_key_vault_managed_storage_account" "rotation_schedule_configuration" {
  locals {
    regen_raw  = core::try(attrs.regenerate_key_automatically, null)
    regen      = local.regen_raw == null ? false : local.regen_raw
    period_raw = core::try(attrs.regeneration_period, null)
    period     = local.period_raw == null ? "" : local.period_raw
    period_ok  = core::try(core::regex("^P(0*([1-9]|[1-8][0-9]|90)D|0*([1-9]|1[0-2])W)$", local.period), null) != null
  }

  enforcement_level = "advisory"

  enforce {
    condition     = local.regen == true && local.period_ok
    error_message = "This Key Vault managed storage account does not declare automatic regeneration on a period of at most 90 days. This checks schedule configuration only; it does not verify successful rotation events or both storage account keys."
  }
}
