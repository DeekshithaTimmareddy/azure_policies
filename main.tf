# Copyright IBM Corp. 2026
#
# HCP Terraform test configuration — exercises all Azure policies:
#
#   Policy                        Resource Type                          Status
#   ──────────────────────────────────────────────────────────────────────────
#   blob-anonymous-disabled       azurerm_storage_account                commented
#   blob-soft-delete              azurerm_storage_account                commented
#   blob-versioning               azurerm_storage_account                commented
#   cross-tenant-replication      azurerm_storage_account                commented
#   default-entra-auth            azurerm_storage_account                commented
#   disable-shared-key            azurerm_storage_account                commented
#   file-share-soft-delete        azurerm_storage_account                commented
#   smb-aes256-encryption         azurerm_storage_account                commented
#   storage-no-public             azurerm_storage_account                commented
#   storage-secure-transfer       azurerm_storage_account                commented
#   storage-tls12                 azurerm_storage_account                commented
#   trusted-services              azurerm_storage_account + network_rules commented
#   subscription-owners           azurerm_role_assignment                verified ✅ (destroyed after test)
#   http-internet-restrict        azurerm_network_security_group         commented
#   rdp-internet-restrict         azurerm_network_security_group         commented
#   udp-port-access-restrict      azurerm_network_security_group + rule  commented

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
# COMMENTED OUT -- Storage account resources (all storage-account policies)
# Uncomment this section when testing storage-account policies again.
# ─────────────────────────────────────────────────────────────────────────────

#
# variable "location" {
#   description = "Azure region for all resources."
#   type        = string
#   default     = "East US"
# }
#
# variable "resource_group_name" {
#   description = "Resource group that holds all test resources."
#   type        = string
#   default     = "policy-testing-rg"
# }
#
# resource "azurerm_resource_group" "rg" {
#   name     = var.resource_group_name
#   location = var.location
# }
#
# # ─────────────────────────────────────────────────────────────────────────────
# # Storage account resources — exercises all 12 storage-account policies
# # ─────────────────────────────────────────────────────────────────────────────
#
# # COMPLIANT storage account — satisfies all storage policies except disable-shared-key
# # (shared_access_key_enabled=false blocks provider data-plane calls during provisioning;
# #  that policy is covered by fail_shared_key below instead)
# resource "azurerm_storage_account" "compliant" {
#   name                     = "compliantpolicysa"
#   resource_group_name      = azurerm_resource_group.rg.name
#   location                 = azurerm_resource_group.rg.location
#   account_tier             = "Standard"
#   account_replication_type = "LRS"
#   account_kind             = "StorageV2"
#
#   allow_nested_items_to_be_public  = false    # blob-anonymous-disabled
#   cross_tenant_replication_enabled = false    # cross-tenant-replication
#   default_to_oauth_authentication  = true     # default-entra-auth
#   public_network_access_enabled    = false    # storage-no-public
#   https_traffic_only_enabled       = true     # storage-secure-transfer
#   min_tls_version                  = "TLS1_2" # storage-tls12
#
#   blob_properties {
#     versioning_enabled = true            # blob-versioning
#     delete_retention_policy { days = 7 } # blob-soft-delete
#   }
#
#   share_properties {
#     retention_policy { days = 7 }                     # file-share-soft-delete
#     smb { channel_encryption_type = ["AES-256-GCM"] } # smb-aes256-encryption
#   }
# }
#
# # blob-anonymous-disabled: VIOLATION — public blob access enabled
# resource "azurerm_storage_account" "fail_blob_anonymous" {
#   name                            = "failblobanonymsa"
#   resource_group_name             = azurerm_resource_group.rg.name
#   location                        = azurerm_resource_group.rg.location
#   account_tier                    = "Standard"
#   account_replication_type        = "LRS"
#   allow_nested_items_to_be_public = true
#   https_traffic_only_enabled      = true
#   min_tls_version                 = "TLS1_2"
# }
#
# # blob-soft-delete: VIOLATION — retention below 7 days (CIS minimum)
# resource "azurerm_storage_account" "fail_blob_soft_delete" {
#   name                            = "failblobsdsa"
#   resource_group_name             = azurerm_resource_group.rg.name
#   location                        = azurerm_resource_group.rg.location
#   account_tier                    = "Standard"
#   account_replication_type        = "LRS"
#   allow_nested_items_to_be_public = false
#   https_traffic_only_enabled      = true
#   min_tls_version                 = "TLS1_2"
#   blob_properties {
#     versioning_enabled = true
#     delete_retention_policy { days = 1 }
#   }
# }
#
# # blob-versioning: VIOLATION — versioning disabled
# resource "azurerm_storage_account" "fail_blob_versioning" {
#   name                            = "failblobversa"
#   resource_group_name             = azurerm_resource_group.rg.name
#   location                        = azurerm_resource_group.rg.location
#   account_tier                    = "Standard"
#   account_replication_type        = "LRS"
#   allow_nested_items_to_be_public = false
#   https_traffic_only_enabled      = true
#   min_tls_version                 = "TLS1_2"
#   blob_properties {
#     versioning_enabled = false
#     delete_retention_policy { days = 7 }
#   }
# }
#
# # cross-tenant-replication: VIOLATION — cross-tenant replication enabled
# resource "azurerm_storage_account" "fail_cross_tenant_replication" {
#   name                             = "failcrosstenantsa"
#   resource_group_name              = azurerm_resource_group.rg.name
#   location                         = azurerm_resource_group.rg.location
#   account_tier                     = "Standard"
#   account_replication_type         = "GRS"
#   cross_tenant_replication_enabled = true
#   https_traffic_only_enabled       = true
#   min_tls_version                  = "TLS1_2"
# }
#
# # default-entra-auth: VIOLATION — OAuth default authentication disabled
# resource "azurerm_storage_account" "fail_default_entra_auth" {
#   name                            = "failentraauthsa"
#   resource_group_name             = azurerm_resource_group.rg.name
#   location                        = azurerm_resource_group.rg.location
#   account_tier                    = "Standard"
#   account_replication_type        = "LRS"
#   default_to_oauth_authentication = false
#   https_traffic_only_enabled      = true
#   min_tls_version                 = "TLS1_2"
# }
#
# # disable-shared-key: VIOLATION — shared access key left enabled
# resource "azurerm_storage_account" "fail_shared_key" {
#   name                       = "failsharedkeysa"
#   resource_group_name        = azurerm_resource_group.rg.name
#   location                   = azurerm_resource_group.rg.location
#   account_tier               = "Standard"
#   account_replication_type   = "LRS"
#   shared_access_key_enabled  = true
#   https_traffic_only_enabled = true
#   min_tls_version            = "TLS1_2"
# }
#
# # file-share-soft-delete: VIOLATION — no file share retention policy
# resource "azurerm_storage_account" "fail_file_share_soft_delete" {
#   name                       = "failfilesdsa"
#   resource_group_name        = azurerm_resource_group.rg.name
#   location                   = azurerm_resource_group.rg.location
#   account_tier               = "Standard"
#   account_replication_type   = "LRS"
#   account_kind               = "StorageV2"
#   https_traffic_only_enabled = true
#   min_tls_version            = "TLS1_2"
#   share_properties {
#     smb { channel_encryption_type = ["AES-256-GCM"] }
#   }
# }
#
# # smb-aes256-encryption: VIOLATION — weak cipher (AES-128-GCM) included
# resource "azurerm_storage_account" "fail_smb_encryption" {
#   name                       = "failsmbencsa"
#   resource_group_name        = azurerm_resource_group.rg.name
#   location                   = azurerm_resource_group.rg.location
#   account_tier               = "Standard"
#   account_replication_type   = "LRS"
#   account_kind               = "StorageV2"
#   https_traffic_only_enabled = true
#   min_tls_version            = "TLS1_2"
#   share_properties {
#     retention_policy { days = 7 }
#     smb { channel_encryption_type = ["AES-128-GCM", "AES-256-GCM"] }
#   }
# }
#
# # storage-no-public: VIOLATION — public network access enabled
# resource "azurerm_storage_account" "fail_public_network" {
#   name                          = "failpublicnetsa"
#   resource_group_name           = azurerm_resource_group.rg.name
#   location                      = azurerm_resource_group.rg.location
#   account_tier                  = "Standard"
#   account_replication_type      = "LRS"
#   public_network_access_enabled = true
#   https_traffic_only_enabled    = true
#   min_tls_version               = "TLS1_2"
# }
#
# # storage-secure-transfer: VIOLATION — HTTPS traffic not enforced
# resource "azurerm_storage_account" "fail_secure_transfer" {
#   name                       = "failsecxfersa"
#   resource_group_name        = azurerm_resource_group.rg.name
#   location                   = azurerm_resource_group.rg.location
#   account_tier               = "Standard"
#   account_replication_type   = "LRS"
#   https_traffic_only_enabled = false
#   min_tls_version            = "TLS1_2"
# }
#
# # storage-tls12: VIOLATION — minimum TLS version set to 1.0
# resource "azurerm_storage_account" "fail_tls_version" {
#   name                       = "failtlsversa"
#   resource_group_name        = azurerm_resource_group.rg.name
#   location                   = azurerm_resource_group.rg.location
#   account_tier               = "Standard"
#   account_replication_type   = "LRS"
#   https_traffic_only_enabled = true
#   min_tls_version            = "TLS1_0"
# }
#
# # trusted-services: VIOLATION — default_action=Deny with no AzureServices bypass
# resource "azurerm_storage_account" "fail_trusted_services" {
#   name                          = "failtrustedsvcsa"
#   resource_group_name           = azurerm_resource_group.rg.name
#   location                      = azurerm_resource_group.rg.location
#   account_tier                  = "Standard"
#   account_replication_type      = "LRS"
#   https_traffic_only_enabled    = true
#   min_tls_version               = "TLS1_2"
#   public_network_access_enabled = true
#   network_rules {
#     default_action = "Deny"
#     bypass         = ["Logging"]
#   }
# }

# ─────────────────────────────────────────────────────────────────────────────
# ACTIVE — subscription-owners (IAM policy)
# ─────────────────────────────────────────────────────────────────────────────
# COMMENTED OUT -- subscription-owners (IAM policy), verified successfully.
#
# Policy  : subscription must not have more than 3 Owner role assignments
#           visible in this Terraform plan (minimum of 2 is a documented,
#           unenforceable recommendation -- see policies/subscription-owners.policy.hcl).
# Subscription : timmareddy-azure-test (b4c6e83c-e900-42e9-ae40-f5d42244f50f)
# Tenant       : 237fbc04-c52a-458b-af97-eaf7157c0cd4
#
# owner_one/owner_two were real, imported Owner role assignments used to
# verify the fixed policy end-to-end against a real HCP Terraform run (see
# run-L2LXdezmBjhpKXUr / run-ZJLaUZjKcd5wVyCQ: tf-policy-evaluations passed
# cleanly). Both were destroyed after testing -- uncomment and re-import (or
# create fresh ones) to test IAM again.
# ─────────────────────────────────────────────────────────────────────────────

# # owner_one — ServicePrincipal: 7bb30395-4c24-467b-b316-c3a61e09a2d3
# #
# # NOTE: skip_service_principal_aad_check is ForceNew-only (create-time only)
# # on azurerm_role_assignment. Since this resource is imported rather than
# # created by this config, the flag isn't persisted in Azure and the provider
# # cannot toggle it in place ("doesn't support update") -- so it must be left
# # unset here to match the real imported state.
# resource "azurerm_role_assignment" "owner_one" {
#   scope                = "/subscriptions/b4c6e83c-e900-42e9-ae40-f5d42244f50f"
#   role_definition_name = "Owner"
#   principal_id         = "2dbc65dc-5ad7-4ddf-8797-09407b8c3af9"
# }
#
# # owner_two — Group: admin-b4c6e83c-e900-42e9-ae40-f5d42244f50f
# resource "azurerm_role_assignment" "owner_two" {
#   scope                = "/subscriptions/b4c6e83c-e900-42e9-ae40-f5d42244f50f"
#   role_definition_name = "Owner"
#   principal_id         = "1bc1fa47-d8a0-4e70-93cf-e3b0a2e56ab2"
# }

