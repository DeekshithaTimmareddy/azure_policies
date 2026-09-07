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
#   http-internet-restrict        azurerm_network_security_group         commented
#   rdp-internet-restrict         azurerm_network_security_group         commented
#   udp-port-access-restrict      azurerm_network_security_group + rule  commented
#   subscription-owners           azurerm_role_assignment                ACTIVE ✓

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
# COMMENTED OUT — Storage account resources (all storage-account policies)
# Uncomment this section when testing storage-account policies.
# ─────────────────────────────────────────────────────────────────────────────

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

# # COMPLIANT storage account — satisfies all 12 storage-account policies
# resource "azurerm_storage_account" "compliant" {
#   name                     = "compliantpolicysa"
#   resource_group_name      = azurerm_resource_group.rg.name
#   location                 = azurerm_resource_group.rg.location
#   account_tier             = "Standard"
#   account_replication_type = "LRS"
#   account_kind             = "StorageV2"
#   allow_nested_items_to_be_public  = false   # blob-anonymous-disabled
#   cross_tenant_replication_enabled = false   # cross-tenant-replication
#   default_to_oauth_authentication  = true    # default-entra-auth
#   shared_access_key_enabled        = false   # disable-shared-key
#   public_network_access_enabled    = false   # storage-no-public
#   https_traffic_only_enabled       = true    # storage-secure-transfer
#   min_tls_version                  = "TLS1_2" # storage-tls12
#   blob_properties {
#     versioning_enabled = true                # blob-versioning
#     delete_retention_policy { days = 7 }     # blob-soft-delete
#   }
#   share_properties {
#     retention_policy { days = 7 }            # file-share-soft-delete
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
# # blob-soft-delete: VIOLATION — retention below 7 days
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
# # cross-tenant-replication: VIOLATION — replication enabled
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
# # default-entra-auth: VIOLATION — OAuth default disabled
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
# # disable-shared-key: VIOLATION — shared key left enabled
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
# # file-share-soft-delete: VIOLATION — no retention policy
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
# # smb-aes256-encryption: VIOLATION — weak cipher included
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
# # storage-secure-transfer: VIOLATION — HTTPS not enforced
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
# # storage-tls12: VIOLATION — minimum TLS set to 1.0
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
# # trusted-services: VIOLATION — Deny rules with no AzureServices bypass
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
# COMMENTED OUT — Network Security Group resources (NSG policies)
# Uncomment this section when testing NSG policies.
# Requires azurerm_resource_group.rg — also uncomment the scaffold above.
# ─────────────────────────────────────────────────────────────────────────────

# # COMPLIANT NSG — no Internet-facing HTTP, RDP, or restricted UDP
# resource "azurerm_network_security_group" "compliant" {
#   name                = "compliant-nsg"
#   location            = azurerm_resource_group.rg.location
#   resource_group_name = azurerm_resource_group.rg.name
#   security_rule {
#     name                       = "allow-https-internal"
#     priority                   = 100
#     direction                  = "Inbound"
#     access                     = "Allow"
#     protocol                   = "Tcp"
#     source_port_range          = "*"
#     destination_port_range     = "443"
#     source_address_prefix      = "10.0.0.0/8"
#     destination_address_prefix = "*"
#   }
#   security_rule {
#     name                       = "deny-all-inbound"
#     priority                   = 4096
#     direction                  = "Inbound"
#     access                     = "Deny"
#     protocol                   = "*"
#     source_port_range          = "*"
#     destination_port_range     = "*"
#     source_address_prefix      = "*"
#     destination_address_prefix = "*"
#   }
# }
#
# # http-internet-restrict: VIOLATION — port 80 open to Internet
# resource "azurerm_network_security_group" "fail_http" {
#   name                = "fail-http-nsg"
#   location            = azurerm_resource_group.rg.location
#   resource_group_name = azurerm_resource_group.rg.name
#   security_rule {
#     name                       = "allow-http-internet"
#     priority                   = 100
#     direction                  = "Inbound"
#     access                     = "Allow"
#     protocol                   = "Tcp"
#     source_port_range          = "*"
#     destination_port_range     = "80"
#     source_address_prefix      = "Internet"
#     destination_address_prefix = "*"
#   }
# }
#
# # rdp-internet-restrict: VIOLATION — RDP port 3389 open to Internet
# resource "azurerm_network_security_group" "fail_rdp" {
#   name                = "fail-rdp-nsg"
#   location            = azurerm_resource_group.rg.location
#   resource_group_name = azurerm_resource_group.rg.name
#   security_rule {
#     name                       = "allow-rdp-internet"
#     priority                   = 100
#     direction                  = "Inbound"
#     access                     = "Allow"
#     protocol                   = "Tcp"
#     source_port_range          = "*"
#     destination_port_range     = "3389"
#     source_address_prefix      = "0.0.0.0/0"
#     destination_address_prefix = "*"
#   }
# }
#
# # udp-port-access-restrict: VIOLATION — UDP port 53 (DNS) open to Internet (inline)
# resource "azurerm_network_security_group" "fail_udp" {
#   name                = "fail-udp-nsg"
#   location            = azurerm_resource_group.rg.location
#   resource_group_name = azurerm_resource_group.rg.name
#   security_rule {
#     name                       = "allow-udp-dns-internet"
#     priority                   = 100
#     direction                  = "Inbound"
#     access                     = "Allow"
#     protocol                   = "Udp"
#     source_port_range          = "*"
#     destination_port_range     = "53"
#     source_address_prefix      = "*"
#     destination_address_prefix = "*"
#   }
# }
#
# # udp-port-access-restrict: VIOLATION — UDP port 123 (NTP) open via standalone rule
# resource "azurerm_network_security_rule" "fail_udp_standalone" {
#   name                        = "allow-udp-ntp-internet"
#   priority                    = 200
#   direction                   = "Inbound"
#   access                      = "Allow"
#   protocol                    = "Udp"
#   source_port_range           = "*"
#   destination_port_range      = "123"
#   source_address_prefix       = "0.0.0.0/0"
#   destination_address_prefix  = "*"
#   resource_group_name         = azurerm_resource_group.rg.name
#   network_security_group_name = azurerm_network_security_group.fail_udp.name
# }

# ─────────────────────────────────────────────────────────────────────────────
# ACTIVE — subscription-owners (IAM policy)
#
# Policy  : subscription must have between 2 and 3 Owner role assignments.
# Subscription : timmareddy-azure-test (b4c6e83c-e900-42e9-ae40-f5d42244f50f)
# Tenant       : 237fbc04-c52a-458b-af97-eaf7157c0cd4
#
# Both assignments ALREADY EXIST in Azure.
# Run these two import commands ONCE before pushing to avoid a 403 on apply:
#
#   terraform import azurerm_role_assignment.owner_one \
#     /subscriptions/b4c6e83c-e900-42e9-ae40-f5d42244f50f/providers/Microsoft.Authorization/roleAssignments/e1617e29-8444-489f-9062-474bd3f92ee2
#
#   terraform import azurerm_role_assignment.owner_two \
#     /subscriptions/b4c6e83c-e900-42e9-ae40-f5d42244f50f/providers/Microsoft.Authorization/roleAssignments/7d1f1379-60c7-443d-a189-ad214126c6f4
# ─────────────────────────────────────────────────────────────────────────────

# owner_one — ServicePrincipal: 7bb30395-4c24-467b-b316-c3a61e09a2d3
resource "azurerm_role_assignment" "owner_one" {
  scope                            = "/subscriptions/b4c6e83c-e900-42e9-ae40-f5d42244f50f"
  role_definition_name             = "Owner"
  principal_id                     = "2dbc65dc-5ad7-4ddf-8797-09407b8c3af9"
  skip_service_principal_aad_check = true
}

# owner_two — Group: admin-b4c6e83c-e900-42e9-ae40-f5d42244f50f
resource "azurerm_role_assignment" "owner_two" {
  scope                = "/subscriptions/b4c6e83c-e900-42e9-ae40-f5d42244f50f"
  role_definition_name = "Owner"
  principal_id         = "1bc1fa47-d8a0-4e70-93cf-e3b0a2e56ab2"
}
