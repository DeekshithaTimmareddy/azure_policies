# Copyright IBM Corp. 2026
#
# HCP Terraform test configuration — exercises all Azure policies:
#
#   Policy                        Resource Type                          Status
#   ──────────────────────────────────────────────────────────────────────────
#   blob-anonymous-disabled       azurerm_storage_account                TESTED ✅
#   blob-soft-delete              azurerm_storage_account                TESTED ✅
#   blob-versioning               azurerm_storage_account                TESTED ✅
#   cross-tenant-replication      azurerm_storage_account                TESTED ✅
#   default-entra-auth            azurerm_storage_account                TESTED ✅
#   disable-shared-key            azurerm_storage_account                TESTED ✅
#   file-share-soft-delete        azurerm_storage_account                TESTED ✅
#   smb-aes256-encryption         azurerm_storage_account                TESTED ✅
#   storage-no-public             azurerm_storage_account                TESTED ✅
#   storage-secure-transfer       azurerm_storage_account                TESTED ✅
#   storage-tls12                 azurerm_storage_account                TESTED ✅
#   trusted-services              azurerm_storage_account + network_rules TESTED ✅
#   subscription-owners           azurerm_role_assignment                TESTED ✅
#   http-internet-restrict        azurerm_network_security_group         ACTIVE ✓
#   rdp-internet-restrict         azurerm_network_security_group         ACTIVE ✓
#   udp-port-access-restrict      azurerm_network_security_group + rule  ACTIVE ✓

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
# Network Security Group resources — ACTIVE
# Policies: http-internet-restrict, rdp-internet-restrict, udp-port-access-restrict
# ─────────────────────────────────────────────────────────────────────────────

# COMPLIANT NSG — no Internet-facing HTTP, RDP, or unrestricted UDP
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
    source_address_prefix      = "10.0.0.0/8"
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

# http-internet-restrict: VIOLATION — port 80 open to Internet
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
    destination_port_range     = "80"
    source_address_prefix      = "Internet"
    destination_address_prefix = "*"
  }
}

# rdp-internet-restrict: VIOLATION — RDP port 3389 open to Internet
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
    destination_port_range     = "3389"
    source_address_prefix      = "0.0.0.0/0"
    destination_address_prefix = "*"
  }
}

# udp-port-access-restrict: VIOLATION — UDP port 53 (DNS) open to Internet (inline NSG rule)
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
    destination_port_range     = "53"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }
}

# udp-port-access-restrict: VIOLATION — UDP port 123 (NTP) open via standalone rule
resource "azurerm_network_security_rule" "fail_udp_standalone" {
  name                        = "allow-udp-ntp-internet"
  priority                    = 200
  direction                   = "Inbound"
  access                      = "Allow"
  protocol                    = "Udp"
  source_port_range           = "*"
  destination_port_range      = "123"
  source_address_prefix       = "0.0.0.0/0"
  destination_address_prefix  = "*"
  resource_group_name         = azurerm_resource_group.rg.name
  network_security_group_name = azurerm_network_security_group.fail_udp.name
}
