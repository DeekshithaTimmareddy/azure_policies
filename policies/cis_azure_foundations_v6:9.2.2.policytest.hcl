resource "azurerm_storage_account" "pass_days_7" {
  attrs = {
    name = "passdays7"
    resource_group_name = "rg-test"
    location = "eastus"
    account_tier = "Standard"
    account_replication_type = "LRS"
    blob_properties = [{ container_delete_retention_policy = [{ days = 7 }] }]
  }
}

resource "azurerm_storage_account" "pass_days_365" {
  attrs = {
    name = "passdays365"
    resource_group_name = "rg-test"
    location = "eastus"
    account_tier = "Standard"
    account_replication_type = "LRS"
    blob_properties = [{ container_delete_retention_policy = [{ days = 365 }] }]
  }
}

resource "azurerm_storage_account" "pass_days_30_full" {
  attrs = {
    name = "passdays30full"
    resource_group_name = "rg-test"
    location = "eastus"
    account_tier = "Standard"
    account_replication_type = "LRS"
    blob_properties = [{
      versioning_enabled = true
      delete_retention_policy = [{ days = 14 }]
      container_delete_retention_policy = [{ days = 30 }]
    }]
  }
}

resource "azurerm_storage_account" "pass_days_provider_default" {
  attrs = {
    name                     = "passdefaultdays"
    resource_group_name      = "rg-test"
    location                 = "eastus"
    account_tier             = "Standard"
    account_replication_type = "LRS"
    blob_properties          = [{ container_delete_retention_policy = [{}] }]
  }
}

resource "azurerm_storage_account" "pass_file_storage_excluded" {
  attrs = {
    name                     = "passfilestorage"
    resource_group_name      = "rg-test"
    location                 = "eastus"
    account_tier             = "Premium"
    account_replication_type = "LRS"
    account_kind             = "FileStorage"
  }
}

resource "azurerm_storage_account" "fail_blob_properties_absent" {
  expect_failure = true
  attrs = {
    name = "failblobpropertiesabsent"
    resource_group_name = "rg-test"
    location = "eastus"
    account_tier = "Standard"
    account_replication_type = "LRS"
  }
}

resource "azurerm_storage_account" "fail_blob_properties_null" {
  expect_failure = true
  attrs = {
    name = "failblobpropertiesnull"
    resource_group_name = "rg-test"
    location = "eastus"
    account_tier = "Standard"
    account_replication_type = "LRS"
    blob_properties = null
  }
}

resource "azurerm_storage_account" "fail_blob_properties_empty" {
  expect_failure = true
  attrs = {
    name = "failblobpropertiesempty"
    resource_group_name = "rg-test"
    location = "eastus"
    account_tier = "Standard"
    account_replication_type = "LRS"
    blob_properties = []
  }
}

resource "azurerm_storage_account" "fail_container_policy_absent" {
  expect_failure = true
  attrs = {
    name = "failcontainerpolicyabsen"
    resource_group_name = "rg-test"
    location = "eastus"
    account_tier = "Standard"
    account_replication_type = "LRS"
    blob_properties = [{ delete_retention_policy = [{ days = 7 }] }]
  }
}

resource "azurerm_storage_account" "fail_container_policy_empty" {
  expect_failure = true
  attrs = {
    name = "failcontainerpolicyempty"
    resource_group_name = "rg-test"
    location = "eastus"
    account_tier = "Standard"
    account_replication_type = "LRS"
    blob_properties = [{ container_delete_retention_policy = [] }]
  }
}

resource "azurerm_storage_account" "fail_container_policy_null" {
  expect_failure = true
  attrs = {
    name = "failcontainerpolicynull"
    resource_group_name = "rg-test"
    location = "eastus"
    account_tier = "Standard"
    account_replication_type = "LRS"
    blob_properties = [{ container_delete_retention_policy = null }]
  }
}

resource "azurerm_storage_account" "pass_container_days_null_default" {
  attrs = {
    name = "passcontainerdaysnull"
    resource_group_name = "rg-test"
    location = "eastus"
    account_tier = "Standard"
    account_replication_type = "LRS"
    blob_properties = [{ container_delete_retention_policy = [{ days = null }] }]
  }
}

resource "azurerm_storage_account" "fail_days_six" {
  expect_failure = true
  attrs = {
    name                     = "faildayssix"
    resource_group_name      = "rg-test"
    location                 = "eastus"
    account_tier             = "Standard"
    account_replication_type = "LRS"
    blob_properties          = [{ container_delete_retention_policy = [{ days = 6 }] }]
  }
}

resource "azurerm_storage_account" "fail_days_one" {
  expect_failure = true
  attrs = {
    name                     = "faildaysone"
    resource_group_name      = "rg-test"
    location                 = "eastus"
    account_tier             = "Standard"
    account_replication_type = "LRS"
    blob_properties          = [{ container_delete_retention_policy = [{ days = 1 }] }]
  }
}

resource "azurerm_storage_account" "fail_days_above_provider_range" {
  expect_failure = true
  attrs = {
    name                     = "faildays366"
    resource_group_name      = "rg-test"
    location                 = "eastus"
    account_tier             = "Standard"
    account_replication_type = "LRS"
    blob_properties          = [{ container_delete_retention_policy = [{ days = 366 }] }]
  }
}
