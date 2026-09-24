resource_policy "azurerm_key_vault_key" "expiration_date_set" {
  enforcement_level = "advisory"

  locals {
    expiration_raw = core::try(attrs.expiration_date, null)
    has_expiration = local.expiration_raw != null && local.expiration_raw != ""
  }

  enforce {
    condition     = local.has_expiration
    error_message = "Key Vault key must have an expiration_date set (keys never expire by default; set an explicit expiration to enforce rotation)."
  }
}
