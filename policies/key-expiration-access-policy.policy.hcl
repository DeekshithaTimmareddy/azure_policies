resource_policy "azurerm_key_vault_key" "8_3_2" {
  enforcement_level = "advisory"

  locals {
    expiration_raw = core::try(attrs.expiration_date, null)
    expiration     = local.expiration_raw == null ? "" : local.expiration_raw
    has_expiration = local.expiration != ""
  }

  enforce {
    condition     = local.has_expiration
    error_message = "Key Vault key must have an expiration date set (expiration_date); by default keys never expire."
  }
}
