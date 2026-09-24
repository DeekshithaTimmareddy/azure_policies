policytest {
  targets = ["automatic-key-rotation-enabled.policy.hcl"]
}

resource "azurerm_key_vault_key" "pass_time_after_creation" {
  attrs = {
    name         = "key-pass-after-create"
    key_type     = "RSA"
    key_opts     = ["sign", "verify"]
    key_vault_id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg/providers/Microsoft.KeyVault/vaults/vault1"
    rotation_policy = [{
      expire_after = "P2Y"
      automatic = [{
        time_after_creation = "P18M"
      }]
    }]
  }
}

resource "azurerm_key_vault_key" "pass_time_before_expiry" {
  attrs = {
    name         = "key-pass-before-expiry"
    key_type     = "RSA"
    key_opts     = ["sign", "verify"]
    key_vault_id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg/providers/Microsoft.KeyVault/vaults/vault2"
    rotation_policy = [{
      expire_after = "P2Y"
      automatic = [{
        time_before_expiry = "P30D"
      }]
    }]
  }
}

resource "azurerm_key_vault_key" "fail_no_rotation_policy" {
  expect_failure = true
  attrs = {
    name         = "key-fail-no-policy"
    key_type     = "RSA"
    key_opts     = ["sign", "verify"]
    key_vault_id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg/providers/Microsoft.KeyVault/vaults/vault3"
  }
}

resource "azurerm_key_vault_key" "fail_no_automatic" {
  expect_failure = true
  attrs = {
    name         = "key-fail-no-automatic"
    key_type     = "RSA"
    key_opts     = ["sign", "verify"]
    key_vault_id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg/providers/Microsoft.KeyVault/vaults/vault4"
    rotation_policy = [{
      expire_after         = "P2Y"
      notify_before_expiry = "P29D"
    }]
  }
}

resource "azurerm_key_vault_key" "fail_automatic_no_trigger" {
  expect_failure = true
  attrs = {
    name         = "key-fail-empty-automatic"
    key_type     = "RSA"
    key_opts     = ["sign", "verify"]
    key_vault_id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg/providers/Microsoft.KeyVault/vaults/vault5"
    rotation_policy = [{
      expire_after = "P2Y"
      automatic    = [{}]
    }]
  }
}

resource "azurerm_key_vault_key" "fail_automatic_empty_list" {
  expect_failure = true
  attrs = {
    name         = "key-fail-automatic-empty-list"
    key_type     = "RSA"
    key_opts     = ["sign", "verify"]
    key_vault_id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg/providers/Microsoft.KeyVault/vaults/vault6"
    rotation_policy = [{
      expire_after = "P2Y"
      automatic    = []
    }]
  }
}
