resource_policy "azurerm_key_vault_secret" "expiration_date_set_rbac" {
  enforcement_level = "advisory"

  enforce {
    condition     = core::try(attrs.expiration_date, null) != null && core::try(core::regex("\\S", core::try(attrs.expiration_date, "")), null) != null
    error_message = "Key Vault secret must have an expiration date set (expiration_date must be a non-empty, non-whitespace value)."
  }
}
