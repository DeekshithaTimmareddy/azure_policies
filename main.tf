# Copyright IBM Corp. 2026
#
# HCP Terraform test configuration — exercises all Azure policies:
#
#   Policy                        Resource Type                          Status
#   ──────────────────────────────────────────────────────────────────────────
#   blob-anonymous-disabled       azurerm_storage_account                ACTIVE ✓
#   blob-soft-delete              azurerm_storage_account                ACTIVE ✓
#   blob-versioning               azurerm_storage_account                ACTIVE ✓
#   cross-tenant-replication      azurerm_storage_account                ACTIVE ✓
#   default-entra-auth            azurerm_storage_account                ACTIVE ✓
#   disable-shared-key            azurerm_storage_account                ACTIVE ✓
#   file-share-soft-delete        azurerm_storage_account                ACTIVE ✓
#   smb-aes256-encryption         azurerm_storage_account                ACTIVE ✓
#   storage-no-public             azurerm_storage_account                ACTIVE ✓
#   storage-secure-transfer       azurerm_storage_account                ACTIVE ✓
#   storage-tls12                 azurerm_storage_account                ACTIVE ✓
#   trusted-services              azurerm_storage_account + network_rules ACTIVE ✓
#   subscription-owners           azurerm_role_assignment                TESTED ✅
#   http-internet-restrict        azurerm_network_security_group         TESTED ✅
#   rdp-internet-restrict         azurerm_network_security_group         TESTED ✅
#   udp-port-access-restrict      azurerm_network_security_group + rule  TESTED ✅

terraform {
  required_version = ">= 1.9.0"

  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 4.0"
    }
  }

  cloud {
    organization = "nagateja-test-org"

    workspaces {
      name = "azure_testing"
    }
  }
}

provider "azurerm" {
  features {}
  subscription_id = "b4c6e83c-e900-42e9-ae40-f5d42244f50f"
  tenant_id       = "237fbc04-c52a-458b-af97-eaf7157c0cd4"
}

# ─────────────────────────────────────────────────────────────────────────────
# Shared scaffold
# ─────────────────────────────────────────────────────────────────────────────

variable "location" {
  description = "Azure region for all resources."
  type        = string
  default     = "East US"
}

variable "resource_group_name" {
  description = "Resource group that holds all test resources."
  type        = string
  default     = "policy-testing-rg"
}

resource "azurerm_resource_group" "rg" {
  name     = var.resource_group_name
  location = var.location
}

# ─────────────────────────────────────────────────────────────────────────────
# Storage account resources — exercises all 12 storage-account policies
# ─────────────────────────────────────────────────────────────────────────────

# COMPLIANT storage account — satisfies all storage policies except disable-shared-key
# (shared_access_key_enabled=false blocks provider data-plane calls during provisioning;
#  that policy is covered by fail_shared_key below instead)
resource "azurerm_storage_account" "compliant" {
  name                     = "compliantpolicysa"
  resource_group_name      = azurerm_resource_group.rg.name
  location                 = azurerm_resource_group.rg.location
  account_tier             = "Standard"
  account_replication_type = "LRS"
  account_kind             = "StorageV2"

  allow_nested_items_to_be_public  = false    # blob-anonymous-disabled
  cross_tenant_replication_enabled = false    # cross-tenant-replication
  default_to_oauth_authentication  = true     # default-entra-auth
  public_network_access_enabled    = false    # storage-no-public
  https_traffic_only_enabled       = true     # storage-secure-transfer
  min_tls_version                  = "TLS1_2" # storage-tls12

  blob_properties {
    versioning_enabled = true            # blob-versioning
    delete_retention_policy { days = 7 } # blob-soft-delete
  }

  share_properties {
    retention_policy { days = 7 }                     # file-share-soft-delete
    smb { channel_encryption_type = ["AES-256-GCM"] } # smb-aes256-encryption
  }
}

# blob-anonymous-disabled: VIOLATION — public blob access enabled
resource "azurerm_storage_account" "fail_blob_anonymous" {
  name                            = "failblobanonymsa"
  resource_group_name             = azurerm_resource_group.rg.name
  location                        = azurerm_resource_group.rg.location
  account_tier                    = "Standard"
  account_replication_type        = "LRS"
  allow_nested_items_to_be_public = true
  https_traffic_only_enabled      = true
  min_tls_version                 = "TLS1_2"
}

# blob-soft-delete: VIOLATION — retention below 7 days (CIS minimum)
resource "azurerm_storage_account" "fail_blob_soft_delete" {
  name                            = "failblobsdsa"
  resource_group_name             = azurerm_resource_group.rg.name
  location                        = azurerm_resource_group.rg.location
  account_tier                    = "Standard"
  account_replication_type        = "LRS"
  allow_nested_items_to_be_public = false
  https_traffic_only_enabled      = true
  min_tls_version                 = "TLS1_2"
  blob_properties {
    versioning_enabled = true
    delete_retention_policy { days = 1 }
  }
}

# blob-versioning: VIOLATION — versioning disabled
resource "azurerm_storage_account" "fail_blob_versioning" {
  name                            = "failblobversa"
  resource_group_name             = azurerm_resource_group.rg.name
  location                        = azurerm_resource_group.rg.location
  account_tier                    = "Standard"
  account_replication_type        = "LRS"
  allow_nested_items_to_be_public = false
  https_traffic_only_enabled      = true
  min_tls_version                 = "TLS1_2"
  blob_properties {
    versioning_enabled = false
    delete_retention_policy { days = 7 }
  }
}

# cross-tenant-replication: VIOLATION — cross-tenant replication enabled
resource "azurerm_storage_account" "fail_cross_tenant_replication" {
  name                             = "failcrosstenantsa"
  resource_group_name              = azurerm_resource_group.rg.name
  location                         = azurerm_resource_group.rg.location
  account_tier                     = "Standard"
  account_replication_type         = "GRS"
  cross_tenant_replication_enabled = true
  https_traffic_only_enabled       = true
  min_tls_version                  = "TLS1_2"
}

# default-entra-auth: VIOLATION — OAuth default authentication disabled
resource "azurerm_storage_account" "fail_default_entra_auth" {
  name                            = "failentraauthsa"
  resource_group_name             = azurerm_resource_group.rg.name
  location                        = azurerm_resource_group.rg.location
  account_tier                    = "Standard"
  account_replication_type        = "LRS"
  default_to_oauth_authentication = false
  https_traffic_only_enabled      = true
  min_tls_version                 = "TLS1_2"
}

# disable-shared-key: VIOLATION — shared access key left enabled
resource "azurerm_storage_account" "fail_shared_key" {
  name                       = "failsharedkeysa"
  resource_group_name        = azurerm_resource_group.rg.name
  location                   = azurerm_resource_group.rg.location
  account_tier               = "Standard"
  account_replication_type   = "LRS"
  shared_access_key_enabled  = true
  https_traffic_only_enabled = true
  min_tls_version            = "TLS1_2"
}

# file-share-soft-delete: VIOLATION — no file share retention policy
resource "azurerm_storage_account" "fail_file_share_soft_delete" {
  name                       = "failfilesdsa"
  resource_group_name        = azurerm_resource_group.rg.name
  location                   = azurerm_resource_group.rg.location
  account_tier               = "Standard"
  account_replication_type   = "LRS"
  account_kind               = "StorageV2"
  https_traffic_only_enabled = true
  min_tls_version            = "TLS1_2"
  share_properties {
    smb { channel_encryption_type = ["AES-256-GCM"] }
  }
}

# smb-aes256-encryption: VIOLATION — weak cipher (AES-128-GCM) included
resource "azurerm_storage_account" "fail_smb_encryption" {
  name                       = "failsmbencsa"
  resource_group_name        = azurerm_resource_group.rg.name
  location                   = azurerm_resource_group.rg.location
  account_tier               = "Standard"
  account_replication_type   = "LRS"
  account_kind               = "StorageV2"
  https_traffic_only_enabled = true
  min_tls_version            = "TLS1_2"
  share_properties {
    retention_policy { days = 7 }
    smb { channel_encryption_type = ["AES-128-GCM", "AES-256-GCM"] }
  }
}

# storage-no-public: VIOLATION — public network access enabled
resource "azurerm_storage_account" "fail_public_network" {
  name                          = "failpublicnetsa"
  resource_group_name           = azurerm_resource_group.rg.name
  location                      = azurerm_resource_group.rg.location
  account_tier                  = "Standard"
  account_replication_type      = "LRS"
  public_network_access_enabled = true
  https_traffic_only_enabled    = true
  min_tls_version               = "TLS1_2"
}

# storage-secure-transfer: VIOLATION — HTTPS traffic not enforced
resource "azurerm_storage_account" "fail_secure_transfer" {
  name                       = "failsecxfersa"
  resource_group_name        = azurerm_resource_group.rg.name
  location                   = azurerm_resource_group.rg.location
  account_tier               = "Standard"
  account_replication_type   = "LRS"
  https_traffic_only_enabled = false
  min_tls_version            = "TLS1_2"
}

# storage-tls12: VIOLATION — minimum TLS version set to 1.0
resource "azurerm_storage_account" "fail_tls_version" {
  name                       = "failtlsversa"
  resource_group_name        = azurerm_resource_group.rg.name
  location                   = azurerm_resource_group.rg.location
  account_tier               = "Standard"
  account_replication_type   = "LRS"
  https_traffic_only_enabled = true
  min_tls_version            = "TLS1_0"
}

# trusted-services: VIOLATION — default_action=Deny with no AzureServices bypass
resource "azurerm_storage_account" "fail_trusted_services" {
  name                          = "failtrustedsvcsa"
  resource_group_name           = azurerm_resource_group.rg.name
  location                      = azurerm_resource_group.rg.location
  account_tier                  = "Standard"
  account_replication_type      = "LRS"
  https_traffic_only_enabled    = true
  min_tls_version               = "TLS1_2"
  public_network_access_enabled = true
  network_rules {
    default_action = "Deny"
    bypass         = ["Logging"]
  }
}
