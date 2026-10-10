policytest {
  targets = ["cis_azure_foundations_v6:9.3.2.1.policy.hcl"]
}

resource "azurerm_storage_account" "pass_sa_with_pe" {
  attrs = {
    id                       = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg1/providers/Microsoft.Storage/storageAccounts/sapass1"
    name                     = "sapass1"
    location                 = "eastus"
    resource_group_name      = "rg1"
    account_tier             = "Standard"
    account_replication_type = "LRS"
  }
}

resource "azurerm_private_endpoint" "pe_sapass1" {
  attrs = {
    name                = "pe_sapass1"
    location            = "eastus"
    resource_group_name = "rg1"
    subnet_id           = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg1/providers/Microsoft.Network/virtualNetworks/vnet1/subnets/snet1"
    private_service_connection = [
      {
        name                           = "psc-pe_sapass1-0"
        is_manual_connection           = false
        private_connection_resource_id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg1/providers/Microsoft.Storage/storageAccounts/sapass1"
        subresource_names              = ["blob"]
      }
    ]
  }
}

resource "azurerm_storage_account" "pass_sa_one_of_two_pe" {
  attrs = {
    id                       = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg1/providers/Microsoft.Storage/storageAccounts/sapass2"
    name                     = "sapass2"
    location                 = "eastus"
    resource_group_name      = "rg1"
    account_tier             = "Standard"
    account_replication_type = "LRS"
  }
}

resource "azurerm_private_endpoint" "pe_sapass2" {
  attrs = {
    name                = "pe_sapass2"
    location            = "eastus"
    resource_group_name = "rg1"
    subnet_id           = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg1/providers/Microsoft.Network/virtualNetworks/vnet1/subnets/snet1"
    private_service_connection = [
      {
        name                           = "psc-pe_sapass2-0"
        is_manual_connection           = false
        private_connection_resource_id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg1/providers/Microsoft.Storage/storageAccounts/sapass2"
        subresource_names              = ["blob"]
      }
    ]
  }
}

resource "azurerm_private_endpoint" "pe_unrelated" {
  attrs = {
    name                = "pe_unrelated"
    location            = "eastus"
    resource_group_name = "rg1"
    subnet_id           = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg1/providers/Microsoft.Network/virtualNetworks/vnet1/subnets/snet1"
    private_service_connection = [
      {
        name                           = "psc-pe_unrelated-0"
        is_manual_connection           = false
        private_connection_resource_id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg1/providers/Microsoft.Storage/storageAccounts/sanotdeclared9"
        subresource_names              = ["blob"]
      }
    ]
  }
}

resource "azurerm_storage_account" "pass_sa_pe_file_subresource" {
  attrs = {
    id                       = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg1/providers/Microsoft.Storage/storageAccounts/sapass3"
    name                     = "sapass3"
    location                 = "eastus"
    resource_group_name      = "rg1"
    account_tier             = "Standard"
    account_replication_type = "LRS"
  }
}

resource "azurerm_private_endpoint" "pe_sapass3_file" {
  attrs = {
    name                = "pe_sapass3_file"
    location            = "eastus"
    resource_group_name = "rg1"
    subnet_id           = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg1/providers/Microsoft.Network/virtualNetworks/vnet1/subnets/snet1"
    private_service_connection = [
      {
        name                           = "psc-pe_sapass3_file"
        is_manual_connection           = false
        private_connection_resource_id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg1/providers/Microsoft.Storage/storageAccounts/sapass3"
        subresource_names              = ["file"]
      }
    ]
  }
}

resource "azurerm_storage_account" "fail_sa_no_pe" {
  expect_failure = true
  attrs = {
    id                       = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg1/providers/Microsoft.Storage/storageAccounts/sanope1"
    name                     = "sanope1"
    location                 = "eastus"
    resource_group_name      = "rg1"
    account_tier             = "Standard"
    account_replication_type = "LRS"
  }
}

resource "azurerm_storage_account" "fail_sa_pe_targets_other" {
  expect_failure = true
  attrs = {
    id                       = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg1/providers/Microsoft.Storage/storageAccounts/sanope2"
    name                     = "sanope2"
    location                 = "eastus"
    resource_group_name      = "rg1"
    account_tier             = "Standard"
    account_replication_type = "LRS"
  }
}

resource "azurerm_private_endpoint" "pe_sanope2other" {
  attrs = {
    name                = "pe_sanope2other"
    location            = "eastus"
    resource_group_name = "rg1"
    subnet_id           = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg1/providers/Microsoft.Network/virtualNetworks/vnet1/subnets/snet1"
    private_service_connection = [
      {
        name                           = "psc-pe_sanope2other-0"
        is_manual_connection           = false
        private_connection_resource_id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg1/providers/Microsoft.Storage/storageAccounts/sanope2other"
        subresource_names              = ["blob"]
      }
    ]
  }
}

resource "azurerm_storage_account" "fail_sa_public_disabled_no_pe" {
  expect_failure = true
  attrs = {
    id                       = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg1/providers/Microsoft.Storage/storageAccounts/sanope3"
    name                     = "sanope3"
    location                 = "eastus"
    resource_group_name      = "rg1"
    account_tier             = "Standard"
    account_replication_type = "LRS"
    public_network_access_enabled = false
  }
}

resource "azurerm_storage_account" "fail_sa_pe_alias_only" {
  expect_failure = true
  attrs = {
    id                       = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg1/providers/Microsoft.Storage/storageAccounts/sanope4"
    name                     = "sanope4"
    location                 = "eastus"
    resource_group_name      = "rg1"
    account_tier             = "Standard"
    account_replication_type = "LRS"
  }
}

resource "azurerm_private_endpoint" "pe_sanope4_alias" {
  attrs = {
    name                = "pe_sanope4_alias"
    location            = "eastus"
    resource_group_name = "rg1"
    subnet_id           = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg1/providers/Microsoft.Network/virtualNetworks/vnet1/subnets/snet1"
    private_service_connection = [
      {
        name                              = "psc-pe_sanope4_alias"
        is_manual_connection              = true
        private_connection_resource_alias = "otherservice.00000000-0000-0000-0000-000000000000.eastus.azure.privatelinkservice"
        request_message                   = "please approve"
      }
    ]
  }
}

resource "azurerm_storage_account" "pass_sa_mixed_case_id" {
  attrs = {
    id                       = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg1/providers/Microsoft.Storage/storageAccounts/samixedcase"
    name                     = "samixedcase"
    location                 = "eastus"
    resource_group_name      = "rg1"
    account_tier             = "Standard"
    account_replication_type = "LRS"
  }
}

resource "azurerm_private_endpoint" "pe_samixedcase" {
  attrs = {
    name                = "pe_samixedcase"
    location            = "eastus"
    resource_group_name = "rg1"
    subnet_id            = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg1/providers/Microsoft.Network/virtualNetworks/vnet1/subnets/snet1"
    private_service_connection = [
      {
        name                           = "psc-mixedcase"
        is_manual_connection           = false
        private_connection_resource_id = "/SUBSCRIPTIONS/00000000-0000-0000-0000-000000000000/RESOURCEGROUPS/RG1/PROVIDERS/MICROSOFT.STORAGE/STORAGEACCOUNTS/SAMIXEDCASE"
        subresource_names              = ["blob"]
      }
    ]
  }
}

resource "azurerm_storage_account" "fail_sa_manual_connection" {
  expect_failure = true
  attrs = {
    id                       = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg1/providers/Microsoft.Storage/storageAccounts/samanual"
    name                     = "samanual"
    location                 = "eastus"
    resource_group_name      = "rg1"
    account_tier             = "Standard"
    account_replication_type = "LRS"
  }
}

resource "azurerm_private_endpoint" "pe_samanual" {
  attrs = {
    name                = "pe_samanual"
    location            = "eastus"
    resource_group_name = "rg1"
    subnet_id            = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg1/providers/Microsoft.Network/virtualNetworks/vnet1/subnets/snet1"
    private_service_connection = [
      {
        name                           = "psc-manual"
        is_manual_connection           = true
        private_connection_resource_id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg1/providers/Microsoft.Storage/storageAccounts/samanual"
        subresource_names              = ["blob"]
      }
    ]
  }
}

resource "azurerm_storage_account" "fail_sa_same_name_other_resource_group" {
  expect_failure = true
  attrs = {
    id                       = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg1/providers/Microsoft.Storage/storageAccounts/duplicate"
    name                     = "duplicate"
    location                 = "eastus"
    resource_group_name      = "rg1"
    account_tier             = "Standard"
    account_replication_type = "LRS"
  }
}

resource "azurerm_private_endpoint" "pe_duplicate_other_resource_group" {
  attrs = {
    name                = "pe_duplicate_other_resource_group"
    location            = "eastus"
    resource_group_name = "rg1"
    subnet_id            = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg1/providers/Microsoft.Network/virtualNetworks/vnet1/subnets/snet1"
    private_service_connection = [
      {
        name                           = "psc-duplicate-other-rg"
        is_manual_connection           = false
        private_connection_resource_id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg2/providers/Microsoft.Storage/storageAccounts/duplicate"
        subresource_names              = ["blob"]
      }
    ]
  }
}
