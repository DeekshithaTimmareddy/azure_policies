policytest {
  targets = ["key-expiration-access-policy.policy.hcl"]
}

resource "azurerm_key_vault_key" "expiration_set" {
  attrs = {
    name            = "compliant-ec-key"
    key_type        = "EC"
    key_opts        = ["sign", "verify"]
    curve           = "P-256"
    key_vault_id    = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg/providers/Microsoft.KeyVault/vaults/kv1"
    expiration_date = "2035-01-01T00:00:00Z"
  }
}

resource "azurerm_key_vault_key" "expiration_absent" {
  expect_failure = true
  attrs = {
    name         = "noexpiry-ec-key"
    key_type     = "EC"
    key_opts     = ["sign", "verify"]
    curve        = "P-256"
    key_vault_id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg/providers/Microsoft.KeyVault/vaults/kv2"
  }
}

resource "azurerm_key_vault_key" "expiration_null" {
  expect_failure = true
  attrs = {
    name            = "nullexpiry-ec-key"
    key_type        = "EC"
    key_opts        = ["sign", "verify"]
    curve           = "P-256"
    key_vault_id    = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg/providers/Microsoft.KeyVault/vaults/kv3"
    expiration_date = null
  }
}

resource "azurerm_key_vault_key" "expiration_empty" {
  expect_failure = true
  attrs = {
    name            = "emptyexpiry-ec-key"
    key_type        = "EC"
    key_opts        = ["sign", "verify"]
    curve           = "P-256"
    key_vault_id    = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg/providers/Microsoft.KeyVault/vaults/kv4"
    expiration_date = ""
  }
}

resource "azurerm_key_vault_key" "rsa_expiration_set" {
  attrs = {
    name            = "compliant-rsa-key"
    key_type        = "RSA"
    key_size        = 2048
    key_opts        = ["encrypt", "decrypt", "sign", "verify"]
    key_vault_id    = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg/providers/Microsoft.KeyVault/vaults/kv5"
    expiration_date = "2036-06-30T12:00:00Z"
  }
}
