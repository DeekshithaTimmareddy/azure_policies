resource_policy "azurerm_key_vault" "purge_protection_enabled" {
    locals {
        purge_protection_raw = core::try(attrs.purge_protection_enabled, null)
        purge_protection = local.purge_protection_raw == null ? false : local.purge_protection_raw
    }

    enforcement_level = "advisory"

    enforce {
        condition     = local.purge_protection == true
        error_message = "Key vault must have purge protection enabled (purge_protection_enabled = true) to keep the vault and its objects recoverable after deletion."
    }
}
