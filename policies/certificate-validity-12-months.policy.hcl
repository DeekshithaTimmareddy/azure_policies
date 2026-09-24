resource_policy "azurerm_key_vault_certificate" "validity_period_max_12_months" {
  enforcement_level = "advisory"

  locals {
    validity_raw = core::try(attrs.certificate_policy[0].x509_certificate_properties[0].validity_in_months, null)
    validity_in_months = local.validity_raw == null ? 12 : local.validity_raw
  }

  enforce {
    condition     = local.validity_in_months <= 12
    error_message = "Key Vault certificate issuance policy validity_in_months must be <= 12 (got ${local.validity_in_months})."
  }
}
