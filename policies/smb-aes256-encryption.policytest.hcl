# Copyright IBM Corp. 2026

policytest {
  targets = ["smb-aes256-encryption.policy.hcl"]
}

resource "azurerm_storage_account" "pass_aes_256_gcm_only" {
  attrs = {
    name                     = "passaes256"
    resource_group_name      = "validation-resource-group"
    location                 = "eastus"
    account_tier             = "Standard"
    account_replication_type = "LRS"
    share_properties = {
      smb = {
        channel_encryption_type = ["AES-256-GCM"]
      }
    }
  }
}

resource "azurerm_storage_account" "fail_missing_share_properties" {
  expect_failure = true
  attrs = {
    name                     = "failmissingshare"
    resource_group_name      = "validation-resource-group"
    location                 = "eastus"
    account_tier             = "Standard"
    account_replication_type = "LRS"
  }
}

resource "azurerm_storage_account" "fail_missing_smb" {
  expect_failure = true
  attrs = {
    name                     = "failmissingsmb"
    resource_group_name      = "validation-resource-group"
    location                 = "eastus"
    account_tier             = "Standard"
    account_replication_type = "LRS"
    share_properties         = {}
  }
}

resource "azurerm_storage_account" "fail_missing_channel_encryption_type" {
  expect_failure = true
  attrs = {
    name                     = "failmissingchannel"
    resource_group_name      = "validation-resource-group"
    location                 = "eastus"
    account_tier             = "Standard"
    account_replication_type = "LRS"
    share_properties = {
      smb = {}
    }
  }
}

resource "azurerm_storage_account" "fail_empty_channel_encryption_type" {
  expect_failure = true
  attrs = {
    name                     = "failemptychannel"
    resource_group_name      = "validation-resource-group"
    location                 = "eastus"
    account_tier             = "Standard"
    account_replication_type = "LRS"
    share_properties = {
      smb = {
        channel_encryption_type = []
      }
    }
  }
}

resource "azurerm_storage_account" "fail_aes_128_ccm_only" {
  expect_failure = true
  attrs = {
    name                     = "failaes128ccm"
    resource_group_name      = "validation-resource-group"
    location                 = "eastus"
    account_tier             = "Standard"
    account_replication_type = "LRS"
    share_properties = {
      smb = {
        channel_encryption_type = ["AES-128-CCM"]
      }
    }
  }
}

resource "azurerm_storage_account" "fail_aes_128_gcm_only" {
  expect_failure = true
  attrs = {
    name                     = "failaes128gcm"
    resource_group_name      = "validation-resource-group"
    location                 = "eastus"
    account_tier             = "Standard"
    account_replication_type = "LRS"
    share_properties = {
      smb = {
        channel_encryption_type = ["AES-128-GCM"]
      }
    }
  }
}

resource "azurerm_storage_account" "fail_aes_256_with_weaker_types" {
  expect_failure = true
  attrs = {
    name                     = "failmixedtypes"
    resource_group_name      = "validation-resource-group"
    location                 = "eastus"
    account_tier             = "Standard"
    account_replication_type = "LRS"
    share_properties = {
      smb = {
        channel_encryption_type = ["AES-256-GCM", "AES-128-CCM", "AES-128-GCM"]
      }
    }
  }
}

resource "azurerm_storage_account" "fail_null_channel_encryption_type" {
  expect_failure = true
  attrs = {
    name                     = "failnullchannel"
    resource_group_name      = "validation-resource-group"
    location                 = "eastus"
    account_tier             = "Standard"
    account_replication_type = "LRS"
    share_properties = {
      smb = {
        channel_encryption_type = null
      }
    }
  }
}

resource "azurerm_storage_account" "pass_unsupported_kind_blob" {
  attrs = {
    name                     = "passunsupportedblob"
    resource_group_name      = "validation-resource-group"
    location                 = "eastus"
    account_tier             = "Standard"
    account_replication_type = "LRS"
    account_kind             = "BlobStorage"
  }
}

resource "azurerm_storage_account" "pass_unsupported_kind_block_blob" {
  attrs = {
    name                     = "passunsupportedblockblob"
    resource_group_name      = "validation-resource-group"
    location                 = "eastus"
    account_tier             = "Standard"
    account_replication_type = "LRS"
    account_kind             = "BlockBlobStorage"
  }
}
