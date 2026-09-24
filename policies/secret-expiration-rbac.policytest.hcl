policytest {
  targets = ["secret-expiration-rbac.policy.hcl"]
}

resource "azurerm_key_vault_secret" "pass_future_expiration" {
  attrs = {
    key_vault_id    = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg/providers/Microsoft.KeyVault/vaults/vault-a"
    name            = "secret-with-expiry"
    value           = "s3cr3t"
    expiration_date = "2030-12-31T23:59:59Z"
  }
}

resource "azurerm_key_vault_secret" "pass_past_expiration" {
  attrs = {
    key_vault_id    = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg/providers/Microsoft.KeyVault/vaults/vault-b"
    name            = "secret-past-expiry"
    value           = "s3cr3t"
    expiration_date = "2020-01-01T00:00:00Z"
  }
}

resource "azurerm_key_vault_secret" "fail_expiration_absent" {
  expect_failure = true
  attrs = {
    key_vault_id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg/providers/Microsoft.KeyVault/vaults/vault-c"
    name         = "secret-no-expiry"
    value        = "s3cr3t"
  }
}

resource "azurerm_key_vault_secret" "fail_expiration_null" {
  expect_failure = true
  attrs = {
    key_vault_id    = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg/providers/Microsoft.KeyVault/vaults/vault-d"
    name            = "secret-null-expiry"
    value           = "s3cr3t"
    expiration_date = null
  }
}

resource "azurerm_key_vault_secret" "fail_expiration_empty" {
  expect_failure = true
  attrs = {
    key_vault_id    = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg/providers/Microsoft.KeyVault/vaults/vault-e"
    name            = "secret-empty-expiry"
    value           = "s3cr3t"
    expiration_date = ""
  }
}

resource "azurerm_key_vault_secret" "fail_expiration_whitespace_only" {
  expect_failure = true
  attrs = {
    key_vault_id    = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg/providers/Microsoft.KeyVault/vaults/vault-f"
    name            = "secret-whitespace-expiry"
    value           = "s3cr3t"
    expiration_date = "   "
  }
}
