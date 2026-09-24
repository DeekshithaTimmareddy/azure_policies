policytest {
  targets = ["private-endpoints-used.policy.hcl"]
}

resource "azurerm_key_vault" "vault_with_pe" {
  attrs = {
    name = "kv-with-pe"
    id   = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg1/providers/Microsoft.KeyVault/vaults/kv-with-pe"
  }
}

resource "azurerm_private_endpoint" "pe_for_with_pe" {
  skip = true
  attrs = {
    name = "pe-with-pe"
    private_service_connection = [{
      name                           = "psc-with-pe"
      is_manual_connection           = false
      private_connection_resource_id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg1/providers/Microsoft.KeyVault/vaults/kv-with-pe"
      subresource_names              = ["vault"]
    }]
  }
}

resource "azurerm_key_vault" "vault_no_pe" {
  expect_failure = true
  attrs = {
    name = "kv-no-pe"
    id   = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg2/providers/Microsoft.KeyVault/vaults/kv-no-pe"
  }
}

resource "azurerm_key_vault" "vault_pe_elsewhere" {
  expect_failure = true
  attrs = {
    name = "kv-pe-elsewhere"
    id   = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg3/providers/Microsoft.KeyVault/vaults/kv-pe-elsewhere"
  }
}

resource "azurerm_private_endpoint" "pe_elsewhere" {
  skip = true
  attrs = {
    name = "pe-elsewhere"
    private_service_connection = [{
      name                           = "psc-elsewhere"
      is_manual_connection           = false
      private_connection_resource_id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg3/providers/Microsoft.Storage/storageAccounts/somestorage"
      subresource_names              = ["blob"]
    }]
  }
}

resource "azurerm_key_vault" "vault_first" {
  attrs = {
    name = "kv-first"
    id   = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg4/providers/Microsoft.KeyVault/vaults/kv-first"
  }
}

resource "azurerm_key_vault" "vault_second" {
  expect_failure = true
  attrs = {
    name = "kv-second"
    id   = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg4/providers/Microsoft.KeyVault/vaults/kv-second"
  }
}

resource "azurerm_private_endpoint" "pe_for_first" {
  skip = true
  attrs = {
    name = "pe-first"
    private_service_connection = [{
      name                           = "psc-first"
      is_manual_connection           = false
      private_connection_resource_id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg4/providers/Microsoft.KeyVault/vaults/kv-first"
      subresource_names              = ["vault"]
    }]
  }
}

resource "azurerm_key_vault" "vault_substring_victim" {
  expect_failure = true
  attrs = {
    name = "kv-sub"
    id   = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg5/providers/Microsoft.KeyVault/vaults/kv-sub"
  }
}

resource "azurerm_private_endpoint" "pe_substring" {
  skip = true
  attrs = {
    name = "pe-substring"
    private_service_connection = [{
      name                           = "psc-substring"
      is_manual_connection           = false
      private_connection_resource_id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg5/providers/Microsoft.KeyVault/vaults/kv-sub-extended"
      subresource_names              = ["vault"]
    }]
  }
}

resource "azurerm_key_vault" "vault_pe_other_subresource_label" {
  attrs = {
    name = "kv-other-sub"
    id   = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg6/providers/Microsoft.KeyVault/vaults/kv-other-sub"
  }
}

resource "azurerm_private_endpoint" "pe_other_subresource" {
  skip = true
  attrs = {
    name = "pe-other-sub"
    private_service_connection = [{
      name                           = "psc-other-sub"
      is_manual_connection           = false
      private_connection_resource_id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg6/providers/Microsoft.KeyVault/vaults/kv-other-sub"
      subresource_names              = ["registry"]
    }]
  }
}

resource "azurerm_key_vault" "vault_pe_no_subresource" {
  attrs = {
    name = "kv-no-sub"
    id   = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg7/providers/Microsoft.KeyVault/vaults/kv-no-sub"
  }
}

resource "azurerm_private_endpoint" "pe_no_subresource" {
  skip = true
  attrs = {
    name = "pe-no-sub"
    private_service_connection = [{
      name                           = "psc-no-sub"
      is_manual_connection           = false
      private_connection_resource_id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg7/providers/Microsoft.KeyVault/vaults/kv-no-sub"
    }]
  }
}

resource "azurerm_key_vault" "vault_pe_empty_subresource" {
  attrs = {
    name = "kv-empty-sub"
    id   = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg8/providers/Microsoft.KeyVault/vaults/kv-empty-sub"
  }
}

resource "azurerm_private_endpoint" "pe_empty_subresource" {
  skip = true
  attrs = {
    name = "pe-empty-sub"
    private_service_connection = [{
      name                           = "psc-empty-sub"
      is_manual_connection           = false
      private_connection_resource_id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg8/providers/Microsoft.KeyVault/vaults/kv-empty-sub"
      subresource_names              = []
    }]
  }
}
