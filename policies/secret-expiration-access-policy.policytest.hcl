policytest {
  targets = ["secret-expiration-access-policy.policy.hcl"]
}

resource "azurerm_key_vault_access_policy" "ap_vault_pass" {
  skip = true
  attrs = {
    key_vault_id = "/subscriptions/s/resourceGroups/rg/providers/Microsoft.KeyVault/vaults/vault-pass"
    object_id    = "00000000-0000-0000-0000-000000000001"
    tenant_id    = "00000000-0000-0000-0000-000000000000"
  }
}

resource "azurerm_key_vault_access_policy" "ap_vault_absent" {
  skip = true
  attrs = {
    key_vault_id = "/subscriptions/s/resourceGroups/rg/providers/Microsoft.KeyVault/vaults/vault-absent"
    object_id    = "00000000-0000-0000-0000-000000000002"
    tenant_id    = "00000000-0000-0000-0000-000000000000"
  }
}

resource "azurerm_key_vault_access_policy" "ap_vault_null" {
  skip = true
  attrs = {
    key_vault_id = "/subscriptions/s/resourceGroups/rg/providers/Microsoft.KeyVault/vaults/vault-null"
    object_id    = "00000000-0000-0000-0000-000000000003"
    tenant_id    = "00000000-0000-0000-0000-000000000000"
  }
}

resource "azurerm_key_vault_access_policy" "ap_vault_empty" {
  skip = true
  attrs = {
    key_vault_id = "/subscriptions/s/resourceGroups/rg/providers/Microsoft.KeyVault/vaults/vault-empty"
    object_id    = "00000000-0000-0000-0000-000000000004"
    tenant_id    = "00000000-0000-0000-0000-000000000000"
  }
}

resource "azurerm_key_vault_secret" "in_scope_with_expiration" {
  attrs = {
    name            = "secret-pass"
    value           = "s3cr3t"
    key_vault_id    = "/subscriptions/s/resourceGroups/rg/providers/Microsoft.KeyVault/vaults/vault-pass"
    expiration_date = "2030-12-31T23:59:59Z"
  }
}

resource "azurerm_key_vault_secret" "in_scope_expiration_absent" {
  expect_failure = true
  attrs = {
    name         = "secret-absent"
    value        = "s3cr3t"
    key_vault_id = "/subscriptions/s/resourceGroups/rg/providers/Microsoft.KeyVault/vaults/vault-absent"
  }
}

resource "azurerm_key_vault_secret" "in_scope_expiration_null" {
  expect_failure = true
  attrs = {
    name            = "secret-null"
    value           = "s3cr3t"
    key_vault_id    = "/subscriptions/s/resourceGroups/rg/providers/Microsoft.KeyVault/vaults/vault-null"
    expiration_date = null
  }
}

resource "azurerm_key_vault_secret" "in_scope_expiration_empty" {
  expect_failure = true
  attrs = {
    name            = "secret-empty"
    value           = "s3cr3t"
    key_vault_id    = "/subscriptions/s/resourceGroups/rg/providers/Microsoft.KeyVault/vaults/vault-empty"
    expiration_date = ""
  }
}

resource "azurerm_key_vault_secret" "out_of_scope_no_access_policy" {
  attrs = {
    name         = "secret-rbac"
    value        = "s3cr3t"
    key_vault_id = "/subscriptions/s/resourceGroups/rg/providers/Microsoft.KeyVault/vaults/vault-rbac-no-ap"
  }
}
