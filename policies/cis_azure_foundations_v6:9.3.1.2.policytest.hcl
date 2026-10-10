resource "azurerm_storage_account" "rotation_requires_live_audit" {
  expect_failure = true
  attrs = {
    name                     = "liveaudit"
    account_replication_type = "LRS"
    account_tier             = "Standard"
    location                 = "eastus"
    resource_group_name      = "rg-test"
  }
}

resource "azurerm_storage_account" "schedule_does_not_prove_rotation" {
  expect_failure = true
  attrs = {
    name                     = "scheduleonly"
    account_replication_type = "LRS"
    account_tier             = "Standard"
    location                 = "eastus"
    resource_group_name      = "rg-test"
  }
}

resource "azurerm_key_vault_managed_storage_account" "schedule_only_key1" {
  attrs = {
    name                         = "scheduleonly-key1"
    key_vault_id                 = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-test/providers/Microsoft.KeyVault/vaults/kv"
    storage_account_id           = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-test/providers/Microsoft.Storage/storageAccounts/scheduleonly"
    storage_account_key          = "key1"
    regenerate_key_automatically = true
    regeneration_period          = "P90D"
  }
}

resource "azurerm_storage_account" "key_rotation_disabled_still_needs_review" {
  expect_failure = true
  attrs = {
    name                     = "sharedkeysoff"
    account_replication_type = "LRS"
    account_tier             = "Standard"
    location                 = "eastus"
    resource_group_name      = "rg-test"
    shared_access_key_enabled = false
  }
}

resource "azurerm_key_vault_managed_storage_account" "pass_90_day_schedule" {
  attrs = {
    name                         = "pass90"
    key_vault_id                 = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-test/providers/Microsoft.KeyVault/vaults/kv"
    storage_account_id           = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-test/providers/Microsoft.Storage/storageAccounts/pass90"
    storage_account_key          = "key1"
    regenerate_key_automatically = true
    regeneration_period          = "P90D"
  }
}

resource "azurerm_key_vault_managed_storage_account" "pass_30_day_schedule" {
  attrs = {
    name                         = "pass30"
    key_vault_id                 = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-test/providers/Microsoft.KeyVault/vaults/kv"
    storage_account_id           = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-test/providers/Microsoft.Storage/storageAccounts/pass30"
    storage_account_key          = "key1"
    regenerate_key_automatically = true
    regeneration_period          = "P30D"
  }
}

resource "azurerm_key_vault_managed_storage_account" "pass_12_week_schedule" {
  attrs = {
    name                         = "pass12weeks"
    key_vault_id                 = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-test/providers/Microsoft.KeyVault/vaults/kv"
    storage_account_id           = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-test/providers/Microsoft.Storage/storageAccounts/pass12weeks"
    storage_account_key          = "key1"
    regenerate_key_automatically = true
    regeneration_period          = "P12W"
  }
}

resource "azurerm_key_vault_managed_storage_account" "pass_key2_schedule" {
  attrs = {
    name                         = "passkey2"
    key_vault_id                 = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-test/providers/Microsoft.KeyVault/vaults/kv"
    storage_account_id           = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-test/providers/Microsoft.Storage/storageAccounts/passkey2"
    storage_account_key          = "key2"
    regenerate_key_automatically = true
    regeneration_period          = "P90D"
  }
}

resource "azurerm_key_vault_managed_storage_account" "fail_auto_regeneration_disabled" {
  expect_failure = true
  attrs = {
    name                         = "disabled"
    key_vault_id                 = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-test/providers/Microsoft.KeyVault/vaults/kv"
    storage_account_id           = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-test/providers/Microsoft.Storage/storageAccounts/disabled"
    storage_account_key          = "key1"
    regenerate_key_automatically = false
    regeneration_period          = "P90D"
  }
}

resource "azurerm_key_vault_managed_storage_account" "fail_auto_regeneration_missing" {
  expect_failure = true
  attrs = {
    name                = "missingauto"
    key_vault_id        = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-test/providers/Microsoft.KeyVault/vaults/kv"
    storage_account_id  = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-test/providers/Microsoft.Storage/storageAccounts/missingauto"
    storage_account_key = "key1"
    regeneration_period = "P90D"
  }
}

resource "azurerm_key_vault_managed_storage_account" "fail_auto_regeneration_null" {
  expect_failure = true
  attrs = {
    name                         = "nullauto"
    key_vault_id                 = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-test/providers/Microsoft.KeyVault/vaults/kv"
    storage_account_id           = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-test/providers/Microsoft.Storage/storageAccounts/nullauto"
    storage_account_key          = "key1"
    regenerate_key_automatically = null
    regeneration_period          = "P90D"
  }
}

resource "azurerm_key_vault_managed_storage_account" "fail_91_day_schedule" {
  expect_failure = true
  attrs = {
    name                         = "period91"
    key_vault_id                 = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-test/providers/Microsoft.KeyVault/vaults/kv"
    storage_account_id           = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-test/providers/Microsoft.Storage/storageAccounts/period91"
    storage_account_key          = "key1"
    regenerate_key_automatically = true
    regeneration_period          = "P91D"
  }
}

resource "azurerm_key_vault_managed_storage_account" "fail_3_month_schedule" {
  expect_failure = true
  attrs = {
    name                         = "period3m"
    key_vault_id                 = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-test/providers/Microsoft.KeyVault/vaults/kv"
    storage_account_id           = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-test/providers/Microsoft.Storage/storageAccounts/period3m"
    storage_account_key          = "key1"
    regenerate_key_automatically = true
    regeneration_period          = "P3M"
  }
}

resource "azurerm_key_vault_managed_storage_account" "fail_13_week_schedule" {
  expect_failure = true
  attrs = {
    name                         = "period13w"
    key_vault_id                 = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-test/providers/Microsoft.KeyVault/vaults/kv"
    storage_account_id           = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-test/providers/Microsoft.Storage/storageAccounts/period13w"
    storage_account_key          = "key1"
    regenerate_key_automatically = true
    regeneration_period          = "P13W"
  }
}

resource "azurerm_key_vault_managed_storage_account" "fail_period_missing" {
  expect_failure = true
  attrs = {
    name                         = "missingperiod"
    key_vault_id                 = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-test/providers/Microsoft.KeyVault/vaults/kv"
    storage_account_id           = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-test/providers/Microsoft.Storage/storageAccounts/missingperiod"
    storage_account_key          = "key1"
    regenerate_key_automatically = true
  }
}

resource "azurerm_key_vault_managed_storage_account" "fail_period_empty" {
  expect_failure = true
  attrs = {
    name                         = "emptyperiod"
    key_vault_id                 = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-test/providers/Microsoft.KeyVault/vaults/kv"
    storage_account_id           = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-test/providers/Microsoft.Storage/storageAccounts/emptyperiod"
    storage_account_key          = "key1"
    regenerate_key_automatically = true
    regeneration_period          = ""
  }
}

resource "azurerm_key_vault_managed_storage_account" "fail_invalid_period" {
  expect_failure = true
  attrs = {
    name                         = "invalidperiod"
    key_vault_id                 = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-test/providers/Microsoft.KeyVault/vaults/kv"
    storage_account_id           = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-test/providers/Microsoft.Storage/storageAccounts/invalidperiod"
    storage_account_key          = "key1"
    regenerate_key_automatically = true
    regeneration_period          = "90 days"
  }
}
