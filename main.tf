# Copyright IBM Corp. 2026
#
# HCP Terraform test configuration — exercises all Azure policies:
#
#   Policy                        Resource Type
#   ─────────────────────────────────────────────────────────────────
#   blob-anonymous-disabled       azurerm_storage_account
#   blob-soft-delete              azurerm_storage_account
#   blob-versioning               azurerm_storage_account
#   cross-tenant-replication      azurerm_storage_account
#   default-entra-auth            azurerm_storage_account
#   disable-shared-key            azurerm_storage_account
#   file-share-soft-delete        azurerm_storage_account
#   smb-aes256-encryption         azurerm_storage_account
#   storage-no-public             azurerm_storage_account
#   storage-secure-transfer       azurerm_storage_account
#   storage-tls12                 azurerm_storage_account
#   trusted-services              azurerm_storage_account + azurerm_storage_account_network_rules
#   http-internet-restrict        azurerm_network_security_group
#   rdp-internet-restrict         azurerm_network_security_group
#   udp-port-access-restrict      azurerm_network_security_group + azurerm_network_security_rule
#   subscription-owners           azurerm_role_assignment

terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 4.0"
    }
  }
}

provider "azurerm" {
  features {}
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

variable "subscription_id" {
  description = "Azure subscription ID used for role-assignment scope tests."
  type        = string
  # Set via TF_VAR_subscription_id or workspace variable in HCP Terraform.
}

resource "azurerm_resource_group" "rg" {
  name     = var.resource_group_name
  location = var.location
}

# ─────────────────────────────────────────────────────────────────────────────
# COMPLIANT storage account
# Satisfies ALL storage-account policies simultaneously:
#   • blob-anonymous-disabled    : allow_nested_items_to_be_public = false
#   • blob-soft-delete           : blob_properties.delete_retention_policy.days = 7
#   • blob-versioning            : blob_properties.versioning_enabled = true
#   • cross-tenant-replication   : cross_tenant_replication_enabled = false
#   • default-entra-auth         : default_to_oauth_authentication = true
#   • disable-shared-key         : shared_access_key_enabled = false
#   • file-share-soft-delete     : share_properties.retention_policy.days = 7
#   • smb-aes256-encryption      : share_properties.smb.channel_encryption_type = ["AES-256-GCM"]
#   • storage-no-public          : public_network_access = "Disabled"
#   • storage-secure-transfer    : https_traffic_only_enabled = true
#   • storage-tls12              : min_tls_version = "TLS1_2"
#   • trusted-services           : public_network_access = "Disabled" (out of scope for that policy)
# ─────────────────────────────────────────────────────────────────────────────

resource "azurerm_storage_account" "compliant" {
  name                     = "compliantpolicysa"
  resource_group_name      = azurerm_resource_group.rg.name
  location                 = azurerm_resource_group.rg.location
  account_tier             = "Standard"
  account_replication_type = "LRS"
  account_kind             = "StorageV2"

  # blob-anonymous-disabled
  allow_nested_items_to_be_public = false

  # cross-tenant-replication
  cross_tenant_replication_enabled = false

  # default-entra-auth
  default_to_oauth_authentication = true

  # disable-shared-key
  shared_access_key_enabled = false

  # storage-no-public  (also keeps trusted-services out of scope)
  public_network_access_enabled = false

  # storage-secure-transfer
  https_traffic_only_enabled = true

  # storage-tls12
  min_tls_version = "TLS1_2"

  # blob-soft-delete + blob-versioning
  blob_properties {
    versioning_enabled = true

    delete_retention_policy {
      days = 7
    }
  }

  # file-share-soft-delete + smb-aes256-encryption
  share_properties {
    retention_policy {
      days = 7
    }

    smb {
      channel_encryption_type = ["AES-256-GCM"]
    }
  }
}

# ─────────────────────────────────────────────────────────────────────────────
# NON-COMPLIANT storage accounts — one per failing condition
# ─────────────────────────────────────────────────────────────────────────────

# blob-anonymous-disabled: public blob access enabled
resource "azurerm_storage_account" "fail_blob_anonymous" {
  name                     = "failblobanonymsa"
  resource_group_name      = azurerm_resource_group.rg.name
  location                 = azurerm_resource_group.rg.location
  account_tier             = "Standard"
  account_replication_type = "LRS"

  allow_nested_items_to_be_public = true   # VIOLATION
  https_traffic_only_enabled      = true
  min_tls_version                 = "TLS1_2"
}

# blob-soft-delete: retention period below 7 days
resource "azurerm_storage_account" "fail_blob_soft_delete" {
  name                     = "failblobsdsa"
  resource_group_name      = azurerm_resource_group.rg.name
  location                 = azurerm_resource_group.rg.location
  account_tier             = "Standard"
  account_replication_type = "LRS"

  allow_nested_items_to_be_public = false
  https_traffic_only_enabled      = true
  min_tls_version                 = "TLS1_2"

  blob_properties {
    versioning_enabled = true

    delete_retention_policy {
      days = 1 # VIOLATION — minimum is 7
    }
  }
}

# blob-versioning: versioning disabled
resource "azurerm_storage_account" "fail_blob_versioning" {
  name                     = "failblobversa"
  resource_group_name      = azurerm_resource_group.rg.name
  location                 = azurerm_resource_group.rg.location
  account_tier             = "Standard"
  account_replication_type = "LRS"

  allow_nested_items_to_be_public = false
  https_traffic_only_enabled      = true
  min_tls_version                 = "TLS1_2"

  blob_properties {
    versioning_enabled = false # VIOLATION

    delete_retention_policy {
      days = 7
    }
  }
}

# cross-tenant-replication: replication enabled
resource "azurerm_storage_account" "fail_cross_tenant_replication" {
  name                     = "failcrosstenantsa"
  resource_group_name      = azurerm_resource_group.rg.name
  location                 = azurerm_resource_group.rg.location
  account_tier             = "Standard"
  account_replication_type = "GRS" # GRS required for cross-tenant replication to be meaningful

  cross_tenant_replication_enabled = true # VIOLATION
  https_traffic_only_enabled       = true
  min_tls_version                  = "TLS1_2"
}

# default-entra-auth: OAuth default disabled
resource "azurerm_storage_account" "fail_default_entra_auth" {
  name                     = "failentraauthsa"
  resource_group_name      = azurerm_resource_group.rg.name
  location                 = azurerm_resource_group.rg.location
  account_tier             = "Standard"
  account_replication_type = "LRS"

  default_to_oauth_authentication = false # VIOLATION
  https_traffic_only_enabled      = true
  min_tls_version                 = "TLS1_2"
}

# disable-shared-key: shared key access left enabled
resource "azurerm_storage_account" "fail_shared_key" {
  name                     = "failsharedkeysa"
  resource_group_name      = azurerm_resource_group.rg.name
  location                 = azurerm_resource_group.rg.location
  account_tier             = "Standard"
  account_replication_type = "LRS"

  shared_access_key_enabled  = true # VIOLATION
  https_traffic_only_enabled = true
  min_tls_version            = "TLS1_2"
}

# file-share-soft-delete: no retention policy
resource "azurerm_storage_account" "fail_file_share_soft_delete" {
  name                     = "failfilesdsa"
  resource_group_name      = azurerm_resource_group.rg.name
  location                 = azurerm_resource_group.rg.location
  account_tier             = "Standard"
  account_replication_type = "LRS"
  account_kind             = "StorageV2"

  https_traffic_only_enabled = true
  min_tls_version            = "TLS1_2"

  share_properties {
    # retention_policy block intentionally omitted — VIOLATION
    smb {
      channel_encryption_type = ["AES-256-GCM"]
    }
  }
}

# smb-aes256-encryption: weak cipher included
resource "azurerm_storage_account" "fail_smb_encryption" {
  name                     = "failsmbencsa"
  resource_group_name      = azurerm_resource_group.rg.name
  location                 = azurerm_resource_group.rg.location
  account_tier             = "Standard"
  account_replication_type = "LRS"
  account_kind             = "StorageV2"

  https_traffic_only_enabled = true
  min_tls_version            = "TLS1_2"

  share_properties {
    retention_policy {
      days = 7
    }

    smb {
      channel_encryption_type = ["AES-128-GCM", "AES-256-GCM"] # VIOLATION — weak cipher present
    }
  }
}

# storage-no-public: public network access enabled
resource "azurerm_storage_account" "fail_public_network" {
  name                     = "failpublicnetsa"
  resource_group_name      = azurerm_resource_group.rg.name
  location                 = azurerm_resource_group.rg.location
  account_tier             = "Standard"
  account_replication_type = "LRS"

  public_network_access_enabled = true # VIOLATION
  https_traffic_only_enabled    = true
  min_tls_version               = "TLS1_2"
}

# storage-secure-transfer: HTTPS not enforced
resource "azurerm_storage_account" "fail_secure_transfer" {
  name                     = "failsecxfersa"
  resource_group_name      = azurerm_resource_group.rg.name
  location                 = azurerm_resource_group.rg.location
  account_tier             = "Standard"
  account_replication_type = "LRS"

  https_traffic_only_enabled = false # VIOLATION
  min_tls_version            = "TLS1_2"
}

# storage-tls12: minimum TLS set to 1.0
resource "azurerm_storage_account" "fail_tls_version" {
  name                     = "failtlsversa"
  resource_group_name      = azurerm_resource_group.rg.name
  location                 = azurerm_resource_group.rg.location
  account_tier             = "Standard"
  account_replication_type = "LRS"

  https_traffic_only_enabled = true
  min_tls_version            = "TLS1_0" # VIOLATION
}

# trusted-services: network rules deny with no AzureServices bypass
resource "azurerm_storage_account" "fail_trusted_services" {
  name                     = "failtrustedsvcsa"
  resource_group_name      = azurerm_resource_group.rg.name
  location                 = azurerm_resource_group.rg.location
  account_tier             = "Standard"
  account_replication_type = "LRS"

  https_traffic_only_enabled    = true
  min_tls_version               = "TLS1_2"
  public_network_access_enabled = true

  network_rules {
    default_action = "Deny"
    bypass         = ["Logging"] # VIOLATION — AzureServices missing
  }
}

# ─────────────────────────────────────────────────────────────────────────────
# COMPLIANT Network Security Group
# No inbound Allow rules for HTTP/HTTPS, RDP, or restricted UDP ports.
# ─────────────────────────────────────────────────────────────────────────────

resource "azurerm_network_security_group" "compliant" {
  name                = "compliant-nsg"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name

  security_rule {
    name                       = "allow-https-internal"
    priority                   = 100
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "443"
    source_address_prefix      = "10.0.0.0/8" # Internal — not Internet
    destination_address_prefix = "*"
  }

  security_rule {
    name                       = "deny-all-inbound"
    priority                   = 4096
    direction                  = "Inbound"
    access                     = "Deny"
    protocol                   = "*"
    source_port_range          = "*"
    destination_port_range     = "*"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }
}

# ─────────────────────────────────────────────────────────────────────────────
# NON-COMPLIANT Network Security Groups
# ─────────────────────────────────────────────────────────────────────────────

# http-internet-restrict: HTTP open to Internet
resource "azurerm_network_security_group" "fail_http" {
  name                = "fail-http-nsg"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name

  security_rule {
    name                       = "allow-http-internet"
    priority                   = 100
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "80" # VIOLATION — port 80 from Internet
    source_address_prefix      = "Internet"
    destination_address_prefix = "*"
  }
}

# rdp-internet-restrict: RDP open to Internet
resource "azurerm_network_security_group" "fail_rdp" {
  name                = "fail-rdp-nsg"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name

  security_rule {
    name                       = "allow-rdp-internet"
    priority                   = 100
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "3389" # VIOLATION — RDP from Internet
    source_address_prefix      = "0.0.0.0/0"
    destination_address_prefix = "*"
  }
}

# udp-port-access-restrict: UDP DNS (53) open to Internet (inline rule)
resource "azurerm_network_security_group" "fail_udp" {
  name                = "fail-udp-nsg"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name

  security_rule {
    name                       = "allow-udp-dns-internet"
    priority                   = 100
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Udp"
    source_port_range          = "*"
    destination_port_range     = "53" # VIOLATION — DNS/UDP from Internet
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }
}

# udp-port-access-restrict: standalone azurerm_network_security_rule violation (NTP 123)
resource "azurerm_network_security_rule" "fail_udp_standalone" {
  name                        = "allow-udp-ntp-internet"
  priority                    = 200
  direction                   = "Inbound"
  access                      = "Allow"
  protocol                    = "Udp"
  source_port_range           = "*"
  destination_port_range      = "123" # VIOLATION — NTP/UDP from Internet
  source_address_prefix       = "0.0.0.0/0"
  destination_address_prefix  = "*"
  resource_group_name         = azurerm_resource_group.rg.name
  network_security_group_name = azurerm_network_security_group.fail_udp.name
}

# ─────────────────────────────────────────────────────────────────────────────
# subscription-owners: role assignments
# The policy requires 2–3 Owner assignments per subscription scope.
# ─────────────────────────────────────────────────────────────────────────────

# COMPLIANT — two owners on the target subscription
resource "azurerm_role_assignment" "owner_one" {
  scope                = "/subscriptions/${var.subscription_id}"
  role_definition_name = "Owner"
  principal_id         = "00000000-0000-0000-0000-000000000001"
}

resource "azurerm_role_assignment" "owner_two" {
  scope                = "/subscriptions/${var.subscription_id}"
  role_definition_name = "Owner"
  principal_id         = "00000000-0000-0000-0000-000000000002"
}
