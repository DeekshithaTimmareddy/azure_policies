policytest {
  targets = ["key-expiration-rbac.policy.hcl"]
}

resource "azurerm_key_vault_key" "expiry_set_passes" {
  attrs = {
    name            = "key-with-expiry"
    key_type        = "RSA"
    key_opts        = ["sign", "verify"]
    key_vault_id    = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg1/providers/Microsoft.KeyVault/vaults/vault1"
    expiration_date = "2030-01-01T00:00:00Z"
  }
}

resource "azurerm_key_vault_key" "expiry_set_other_passes" {
  attrs = {
    name            = "key-with-other-expiry"
    key_type        = "EC"
    key_opts        = ["sign", "verify"]
    key_vault_id    = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg1/providers/Microsoft.KeyVault/vaults/vault1"
    expiration_date = "2027-06-15T12:30:00Z"
  }
}

resource "azurerm_key_vault_key" "expiry_absent_fails" {
  expect_failure = true
  attrs = {
    name         = "key-no-expiry"
    key_type     = "RSA"
    key_opts     = ["sign", "verify"]
    key_vault_id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg1/providers/Microsoft.KeyVault/vaults/vault1"
  }
}

resource "azurerm_key_vault_key" "expiry_null_fails" {
  expect_failure = true
  attrs = {
    name            = "key-null-expiry"
    key_type        = "RSA"
    key_opts        = ["sign", "verify"]
    key_vault_id    = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg1/providers/Microsoft.KeyVault/vaults/vault1"
    expiration_date = null
  }
}

resource "azurerm_key_vault_key" "expiry_empty_fails" {
  expect_failure = true
  attrs = {
    name            = "key-empty-expiry"
    key_type        = "RSA"
    key_opts        = ["sign", "verify"]
    key_vault_id    = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg1/providers/Microsoft.KeyVault/vaults/vault1"
    expiration_date = ""
  }
}
