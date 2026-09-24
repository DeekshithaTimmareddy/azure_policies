# Copyright IBM Corp. 2026
#
# HCP Terraform test configuration — exercises all Azure policies:
#
#   Policy                        Resource Type                          Status
#   ──────────────────────────────────────────────────────────────────────────
#   blob-anonymous-disabled       azurerm_storage_account                verified ✅ (fix confirmed via HCP run)
#   blob-soft-delete              azurerm_storage_account                verified ✅ (fix confirmed via HCP run)
#   blob-versioning               azurerm_storage_account                verified ✅ (fix confirmed via HCP run)
#   cross-tenant-replication      azurerm_storage_account                verified ✅ (fix confirmed via HCP run)
#   default-entra-auth            azurerm_storage_account                verified ✅ (fix confirmed via HCP run)
#   disable-shared-key            azurerm_storage_account                verified ✅ (fix confirmed via HCP run)
#   file-share-soft-delete        azurerm_storage_account                verified ✅ (fix confirmed via HCP run)
#   smb-aes256-encryption         azurerm_storage_account                verified ✅ (fix confirmed via HCP run)
#   storage-no-public             azurerm_storage_account                verified ✅ (fix confirmed via HCP run)
#   storage-secure-transfer       azurerm_storage_account                verified ✅ (fix confirmed via HCP run)
#   storage-tls12                 azurerm_storage_account                verified ✅ (fix confirmed via HCP run)
#   trusted-services              azurerm_storage_account + network_rules verified ✅ (fix confirmed via HCP run)
#   subscription-owners           azurerm_role_assignment                verified ✅ (destroyed after test)
#   http-internet-restrict        azurerm_network_security_group         verified ✅ (fix confirmed via HCP run)
#   rdp-internet-restrict         azurerm_network_security_group         verified ✅ (fix confirmed via HCP run)
#   udp-port-access-restrict      azurerm_network_security_group + rule  verified ✅ (fix confirmed via HCP run)
#   rbac-enabled                  azurerm_key_vault                      verified ✅ (fix confirmed via HCP run, destroyed)
#   purge-protection-enabled      azurerm_key_vault                      verified ✅ (fix confirmed via HCP run, destroyed)
#   public-network-access-disabled azurerm_key_vault                     verified ✅ (fix confirmed via HCP run, destroyed)
#   key-expiration-rbac           azurerm_key_vault_key                  verified ✅ (fix confirmed via HCP run, destroyed)
#   key-expiration-access-policy  azurerm_key_vault_key                  verified ✅ (fix confirmed via HCP run, destroyed)
#   secret-expiration-rbac        azurerm_key_vault_secret               verified ✅ (fix confirmed via HCP run, destroyed)
#   secret-expiration-access-policy azurerm_key_vault_secret              verified ✅ (fix confirmed via HCP run, destroyed)
#   automatic-key-rotation-enabled azurerm_key_vault_key                 verified ✅ (fix confirmed via HCP run, destroyed)
#   certificate-validity-12-months azurerm_key_vault_certificate         verified ✅ (fix confirmed via HCP run, destroyed)
#   private-endpoints-used         azurerm_private_endpoint              verified ✅ (fix confirmed via HCP run, destroyed)
#   keyvault-logging-enabled       azurerm_monitor_diagnostic_setting    verified ✅ (fix confirmed via HCP run, destroyed)
#   defender-servers-on           azurerm_security_center_subscription_pricing ACTIVE ✓ (Phase 2 CIS, subscription-wide singleton)

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
# COMMENTED OUT -- Network Security Group resources (tested previously, see PR history)
# Policies: http-internet-restrict, rdp-internet-restrict, udp-port-access-restrict
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

# # COMPLIANT NSG — no Internet-facing HTTP, RDP, or unrestricted UDP
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
# # http-internet-restrict: VIOLATION — port 443 open to IPv6 Internet (::/0), via
# # a standalone azurerm_network_security_rule (new fixed behavior).
# resource "azurerm_network_security_rule" "fail_http_ipv6_standalone" {
#   name                        = "allow-https-ipv6-internet"
#   priority                    = 210
#   direction                   = "Inbound"
#   access                      = "Allow"
#   protocol                    = "Tcp"
#   source_port_range           = "*"
#   destination_port_range      = "443"
#   source_address_prefix       = "::/0"
#   destination_address_prefix  = "*"
#   resource_group_name         = azurerm_resource_group.rg.name
#   network_security_group_name = azurerm_network_security_group.fail_http.name
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
# # rdp-internet-restrict: VIOLATION — RDP port 3389 open via a standalone
# # azurerm_network_security_rule (new fixed behavior).
# resource "azurerm_network_security_rule" "fail_rdp_standalone" {
#   name                        = "allow-rdp-internet-standalone"
#   priority                    = 220
#   direction                   = "Inbound"
#   access                      = "Allow"
#   protocol                    = "Tcp"
#   source_port_range           = "*"
#   destination_port_range      = "3389"
#   source_address_prefix       = "Internet"
#   destination_address_prefix  = "*"
#   resource_group_name         = azurerm_resource_group.rg.name
#   network_security_group_name = azurerm_network_security_group.fail_rdp.name
# }
#
# # udp-port-access-restrict: VIOLATION — UDP port 53 (DNS) open to Internet (inline NSG rule)
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


# ─────────────────────────────────────────────────────────────────────────────
# COMMENTED OUT -- Key Vault resources (tested previously, see PR history)
# Policies: rbac-enabled, purge-protection-enabled, public-network-access-disabled,
#           key-expiration-rbac, key-expiration-access-policy, secret-expiration-rbac,
#           secret-expiration-access-policy, automatic-key-rotation-enabled,
#           certificate-validity-12-months, private-endpoints-used, keyvault-logging-enabled
# ─────────────────────────────────────────────────────────────────────────────
# # ─────────────────────────────────────────────────────────────────────────────
# # ACTIVE -- Key Vault resources (Phase 2 CIS controls)
# # Policies: rbac-enabled, purge-protection-enabled, public-network-access-disabled,
# #           key-expiration-rbac, key-expiration-access-policy, secret-expiration-rbac,
# #           secret-expiration-access-policy, automatic-key-rotation-enabled,
# #           certificate-validity-12-months, private-endpoints-used, keyvault-logging-enabled
# # ─────────────────────────────────────────────────────────────────────────────
#
# data "azurerm_client_config" "current" {}
#
# # Vault A: RBAC model, public network access enabled (needed for Terraform's
# # own data-plane calls to create keys/secrets/certs inside it).
# resource "azurerm_key_vault" "rbac_data_ops" {
#   name                          = "kv-rbac-dataops-ph2"
#   location                      = azurerm_resource_group.rg.location
#   resource_group_name           = azurerm_resource_group.rg.name
#   tenant_id                     = data.azurerm_client_config.current.tenant_id
#   sku_name                      = "standard"
#   rbac_authorization_enabled    = true # rbac-enabled: PASS
#   purge_protection_enabled      = true # purge-protection-enabled: PASS
#   public_network_access_enabled = true # public-network-access-disabled: FAIL here (data-plane access required); PASS proven separately below
# }
#
# resource "azurerm_role_assignment" "rbac_data_ops_self_admin" {
#   scope                = azurerm_key_vault.rbac_data_ops.id
#   role_definition_name = "Key Vault Administrator"
#   principal_id         = data.azurerm_client_config.current.object_id
# }
#
# # key-expiration-rbac: PASS — expiration_date set; also satisfies automatic-key-rotation-enabled
# resource "azurerm_key_vault_key" "rbac_key_pass" {
#   name            = "rbac-key-pass"
#   key_vault_id    = azurerm_key_vault.rbac_data_ops.id
#   key_type        = "RSA"
#   key_size        = 2048
#   key_opts        = ["decrypt", "encrypt", "sign", "verify", "wrapKey", "unwrapKey"]
#   expiration_date = timeadd(timestamp(), "8760h") # +1 year
#
#   rotation_policy {
#     automatic {
#       time_after_creation = "P90D"
#     }
#     expire_after         = "P365D"
#     notify_before_expiry = "P30D"
#   }
#
#   depends_on = [azurerm_role_assignment.rbac_data_ops_self_admin]
#
#   lifecycle {
#     ignore_changes = [expiration_date]
#   }
# }
#
# # key-expiration-rbac: FAIL — no expiration_date, no rotation_policy
# resource "azurerm_key_vault_key" "rbac_key_fail" {
#   name         = "rbac-key-fail"
#   key_vault_id = azurerm_key_vault.rbac_data_ops.id
#   key_type     = "RSA"
#   key_size     = 2048
#   key_opts     = ["decrypt", "encrypt", "sign", "verify", "wrapKey", "unwrapKey"]
#
#   depends_on = [azurerm_role_assignment.rbac_data_ops_self_admin]
# }
#
# # secret-expiration-rbac: PASS — expiration_date set
# resource "azurerm_key_vault_secret" "rbac_secret_pass" {
#   name            = "rbac-secret-pass"
#   value           = "placeholder-value-pass"
#   key_vault_id    = azurerm_key_vault.rbac_data_ops.id
#   expiration_date = timeadd(timestamp(), "8760h")
#
#   depends_on = [azurerm_role_assignment.rbac_data_ops_self_admin]
#
#   lifecycle {
#     ignore_changes = [expiration_date]
#   }
# }
#
# # secret-expiration-rbac: FAIL — no expiration_date
# resource "azurerm_key_vault_secret" "rbac_secret_fail" {
#   name         = "rbac-secret-fail"
#   value        = "placeholder-value-fail"
#   key_vault_id = azurerm_key_vault.rbac_data_ops.id
#
#   depends_on = [azurerm_role_assignment.rbac_data_ops_self_admin]
# }
#
# # certificate-validity-12-months: PASS — validity_in_months = 12
# resource "azurerm_key_vault_certificate" "cert_pass" {
#   name         = "cert-validity-pass"
#   key_vault_id = azurerm_key_vault.rbac_data_ops.id
#
#   certificate_policy {
#     issuer_parameters {
#       name = "Self"
#     }
#     key_properties {
#       exportable = true
#       key_type   = "RSA"
#       key_size   = 2048
#       reuse_key  = true
#     }
#     lifetime_action {
#       action {
#         action_type = "AutoRenew"
#       }
#       trigger {
#         days_before_expiry = 30
#       }
#     }
#     secret_properties {
#       content_type = "application/x-pkcs12"
#     }
#     x509_certificate_properties {
#       subject            = "CN=cert-pass.example.com"
#       validity_in_months = 12
#       key_usage = [
#         "cRLSign", "dataEncipherment", "digitalSignature", "keyAgreement",
#         "keyCertSign", "keyEncipherment",
#       ]
#     }
#   }
#
#   depends_on = [azurerm_role_assignment.rbac_data_ops_self_admin]
# }
#
# # certificate-validity-12-months: FAIL — validity_in_months = 24
# resource "azurerm_key_vault_certificate" "cert_fail" {
#   name         = "cert-validity-fail"
#   key_vault_id = azurerm_key_vault.rbac_data_ops.id
#
#   certificate_policy {
#     issuer_parameters {
#       name = "Self"
#     }
#     key_properties {
#       exportable = true
#       key_type   = "RSA"
#       key_size   = 2048
#       reuse_key  = true
#     }
#     lifetime_action {
#       action {
#         action_type = "AutoRenew"
#       }
#       trigger {
#         days_before_expiry = 30
#       }
#     }
#     secret_properties {
#       content_type = "application/x-pkcs12"
#     }
#     x509_certificate_properties {
#       subject            = "CN=cert-fail.example.com"
#       validity_in_months = 24
#       key_usage = [
#         "cRLSign", "dataEncipherment", "digitalSignature", "keyAgreement",
#         "keyCertSign", "keyEncipherment",
#       ]
#     }
#   }
#
#   depends_on = [azurerm_role_assignment.rbac_data_ops_self_admin]
# }
#
# # Vault B: access-policy model (RBAC disabled) — tests rbac-enabled FAIL,
# # purge-protection-enabled FAIL, public-network-access-disabled FAIL, and
# # hosts the access-policy-path key/secret compliant+fail pairs.
# resource "azurerm_key_vault" "access_policy_vault" {
#   name                          = "kv-accesspolicy-ph2"
#   location                      = azurerm_resource_group.rg.location
#   resource_group_name           = azurerm_resource_group.rg.name
#   tenant_id                     = data.azurerm_client_config.current.tenant_id
#   sku_name                      = "standard"
#   rbac_authorization_enabled    = false # rbac-enabled: FAIL
#   purge_protection_enabled      = false # purge-protection-enabled: FAIL
#   public_network_access_enabled = true  # public-network-access-disabled: FAIL
# }
#
# resource "azurerm_key_vault_access_policy" "access_policy_self" {
#   key_vault_id = azurerm_key_vault.access_policy_vault.id
#   tenant_id    = data.azurerm_client_config.current.tenant_id
#   object_id    = data.azurerm_client_config.current.object_id
#
#   key_permissions = [
#     "Create", "Get", "List", "Delete", "Purge", "GetRotationPolicy", "SetRotationPolicy",
#   ]
#   secret_permissions = [
#     "Set", "Get", "List", "Delete", "Purge",
#   ]
# }
#
# # key-expiration-access-policy: PASS — expiration_date set
# resource "azurerm_key_vault_key" "access_policy_key_pass" {
#   name            = "ap-key-pass"
#   key_vault_id    = azurerm_key_vault.access_policy_vault.id
#   key_type        = "RSA"
#   key_size        = 2048
#   key_opts        = ["decrypt", "encrypt", "sign", "verify", "wrapKey", "unwrapKey"]
#   expiration_date = timeadd(timestamp(), "8760h")
#
#   depends_on = [azurerm_key_vault_access_policy.access_policy_self]
#
#   lifecycle {
#     ignore_changes = [expiration_date]
#   }
# }
#
# # key-expiration-access-policy: FAIL — no expiration_date
# resource "azurerm_key_vault_key" "access_policy_key_fail" {
#   name         = "ap-key-fail"
#   key_vault_id = azurerm_key_vault.access_policy_vault.id
#   key_type     = "RSA"
#   key_size     = 2048
#   key_opts     = ["decrypt", "encrypt", "sign", "verify", "wrapKey", "unwrapKey"]
#
#   depends_on = [azurerm_key_vault_access_policy.access_policy_self]
# }
#
# # secret-expiration-access-policy: PASS — expiration_date set
# resource "azurerm_key_vault_secret" "access_policy_secret_pass" {
#   name            = "ap-secret-pass"
#   value           = "placeholder-value-pass"
#   key_vault_id    = azurerm_key_vault.access_policy_vault.id
#   expiration_date = timeadd(timestamp(), "8760h")
#
#   depends_on = [azurerm_key_vault_access_policy.access_policy_self]
#
#   lifecycle {
#     ignore_changes = [expiration_date]
#   }
# }
#
# # secret-expiration-access-policy: FAIL — no expiration_date
# resource "azurerm_key_vault_secret" "access_policy_secret_fail" {
#   name         = "ap-secret-fail"
#   value        = "placeholder-value-fail"
#   key_vault_id = azurerm_key_vault.access_policy_vault.id
#
#   depends_on = [azurerm_key_vault_access_policy.access_policy_self]
# }
#
# # Vault C: network-isolated control-plane-only vault — no data-plane children
# # (public network access disabled blocks data-plane calls, so we do not
# # attempt to create keys/secrets/certs here). Proves the PASS case for
# # public-network-access-disabled together with rbac-enabled and
# # purge-protection-enabled.
# resource "azurerm_key_vault" "network_isolated_pass" {
#   name                          = "kv-netiso-pass-ph2"
#   location                      = azurerm_resource_group.rg.location
#   resource_group_name           = azurerm_resource_group.rg.name
#   tenant_id                     = data.azurerm_client_config.current.tenant_id
#   sku_name                      = "standard"
#   rbac_authorization_enabled    = true  # rbac-enabled: PASS
#   purge_protection_enabled      = true  # purge-protection-enabled: PASS
#   public_network_access_enabled = false # public-network-access-disabled: PASS
# }
#
# # Private Endpoint infrastructure for private-endpoints-used
# resource "azurerm_virtual_network" "kv_vnet" {
#   name                = "kv-ph2-vnet"
#   address_space       = ["10.10.0.0/16"]
#   location            = azurerm_resource_group.rg.location
#   resource_group_name = azurerm_resource_group.rg.name
# }
#
# resource "azurerm_subnet" "kv_pe_subnet" {
#   name                              = "kv-pe-subnet"
#   resource_group_name               = azurerm_resource_group.rg.name
#   virtual_network_name              = azurerm_virtual_network.kv_vnet.name
#   address_prefixes                  = ["10.10.1.0/24"]
#   private_endpoint_network_policies = "Disabled"
# }
#
# # private-endpoints-used: PASS — private endpoint targets rbac_data_ops
# resource "azurerm_private_endpoint" "kv_pe" {
#   name                = "kv-rbac-dataops-pe"
#   location            = azurerm_resource_group.rg.location
#   resource_group_name = azurerm_resource_group.rg.name
#   subnet_id           = azurerm_subnet.kv_pe_subnet.id
#
#   private_service_connection {
#     name                           = "kv-rbac-dataops-psc"
#     private_connection_resource_id = azurerm_key_vault.rbac_data_ops.id
#     subresource_names              = ["vault"]
#     is_manual_connection           = false
#   }
# }
# # private-endpoints-used: FAIL — access_policy_vault has no matching private endpoint (implicit, no resource needed)
#
# # Log Analytics Workspace + diagnostic settings for keyvault-logging-enabled
# resource "azurerm_log_analytics_workspace" "kv_law" {
#   name                = "kv-ph2-law"
#   location            = azurerm_resource_group.rg.location
#   resource_group_name = azurerm_resource_group.rg.name
#   sku                 = "PerGB2018"
#   retention_in_days   = 30
# }
#
# # keyvault-logging-enabled: PASS — both 'audit' and 'allLogs' category groups enabled
# resource "azurerm_monitor_diagnostic_setting" "kv_diag_pass" {
#   name                       = "kv-rbac-dataops-diag-pass"
#   target_resource_id         = azurerm_key_vault.rbac_data_ops.id
#   log_analytics_workspace_id = azurerm_log_analytics_workspace.kv_law.id
#
#   enabled_log {
#     category_group = "audit"
#   }
#   enabled_log {
#     category_group = "allLogs"
#   }
# }
#
# # keyvault-logging-enabled: FAIL — destination configured but missing 'allLogs'
# resource "azurerm_monitor_diagnostic_setting" "kv_diag_fail" {
#   name                       = "kv-accesspolicy-diag-fail"
#   target_resource_id         = azurerm_key_vault.access_policy_vault.id
#   log_analytics_workspace_id = azurerm_log_analytics_workspace.kv_law.id
#
#   enabled_log {
#     category_group = "audit"
#   }
# }

# ─────────────────────────────────────────────────────────────────────────────
# ACTIVE -- Security Center / Defender resources (Phase 2 CIS controls)
# Policy: defender-servers-on (only; other 6 Security Center policies verified
#         via local tfpolicy test only -- subscription-wide singleton settings
#         intentionally not applied here one at a time per user direction)
# ─────────────────────────────────────────────────────────────────────────────

# defender-servers-on: PASS — Defender for Servers (VirtualMachines) set to Standard.
# NOTE: subscription-wide singleton setting (not scoped to a resource group).
# Confirmed 0 VMs exist in this subscription at time of testing, so this incurs
# no actual per-VM-hour billing while active. Restored to Free on destroy.
resource "azurerm_security_center_subscription_pricing" "vm_standard" {
  tier          = "Standard"
  resource_type = "VirtualMachines"
}
