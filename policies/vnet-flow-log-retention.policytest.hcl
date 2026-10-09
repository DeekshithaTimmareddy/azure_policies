# Copyright IBM Corp. 2026

policytest {
  targets = ["vnet-flow-log-retention.policy.hcl"]
}

resource "azurerm_network_watcher_flow_log" "pass_vnet_days_0" {

  attrs = {
    name                 = "fl-pass-vnet-days-0"
    enabled              = true
    network_watcher_name = "nw-eastus"
    resource_group_name  = "rg"
    storage_account_id   = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg/providers/Microsoft.Storage/storageAccounts/flowlogsa"
    target_resource_id   = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg/providers/Microsoft.Network/virtualNetworks/vnet-pass-vnet-days-0"
    retention_policy     = [{ days = 0, enabled = true }]
  }
}

resource "azurerm_network_watcher_flow_log" "pass_vnet_days_90" {

  attrs = {
    name                 = "fl-pass-vnet-days-90"
    enabled              = true
    network_watcher_name = "nw-eastus"
    resource_group_name  = "rg"
    storage_account_id   = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg/providers/Microsoft.Storage/storageAccounts/flowlogsa"
    target_resource_id   = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg/providers/Microsoft.Network/virtualNetworks/vnet-pass-vnet-days-90"
    retention_policy     = [{ days = 90, enabled = true }]
  }
}

resource "azurerm_network_watcher_flow_log" "pass_vnet_days_365" {

  attrs = {
    name                 = "fl-pass-vnet-days-365"
    enabled              = true
    network_watcher_name = "nw-eastus"
    resource_group_name  = "rg"
    storage_account_id   = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg/providers/Microsoft.Storage/storageAccounts/flowlogsa"
    target_resource_id   = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg/providers/Microsoft.Network/virtualNetworks/vnet-pass-vnet-days-365"
    retention_policy     = [{ days = 365, enabled = true }]
  }
}

resource "azurerm_network_watcher_flow_log" "fail_vnet_days_89" {
  expect_failure = true
  attrs = {
    name                 = "fl-fail-vnet-days-89"
    enabled              = true
    network_watcher_name = "nw-eastus"
    resource_group_name  = "rg"
    storage_account_id   = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg/providers/Microsoft.Storage/storageAccounts/flowlogsa"
    target_resource_id   = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg/providers/Microsoft.Network/virtualNetworks/vnet-fail-vnet-days-89"
    retention_policy     = [{ days = 89, enabled = true }]
  }
}

resource "azurerm_network_watcher_flow_log" "fail_vnet_days_1" {
  expect_failure = true
  attrs = {
    name                 = "fl-fail-vnet-days-1"
    enabled              = true
    network_watcher_name = "nw-eastus"
    resource_group_name  = "rg"
    storage_account_id   = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg/providers/Microsoft.Storage/storageAccounts/flowlogsa"
    target_resource_id   = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg/providers/Microsoft.Network/virtualNetworks/vnet-fail-vnet-days-1"
    retention_policy     = [{ days = 1, enabled = true }]
  }
}

resource "azurerm_network_watcher_flow_log" "fail_vnet_days_30_policy_disabled" {
  expect_failure = true
  attrs = {
    name                 = "fl-fail-vnet-days-30-policy-disabled"
    enabled              = true
    network_watcher_name = "nw-eastus"
    resource_group_name  = "rg"
    storage_account_id   = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg/providers/Microsoft.Storage/storageAccounts/flowlogsa"
    target_resource_id   = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg/providers/Microsoft.Network/virtualNetworks/vnet-fail-vnet-days-30-policy-disabled"
    retention_policy     = [{ days = 30, enabled = false }]
  }
}

resource "azurerm_network_watcher_flow_log" "pass_nsg_target_days_30" {

  attrs = {
    name                 = "fl-pass-nsg-target-days-30"
    enabled              = true
    network_watcher_name = "nw-eastus"
    resource_group_name  = "rg"
    storage_account_id   = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg/providers/Microsoft.Storage/storageAccounts/flowlogsa"
    target_resource_id   = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg/providers/Microsoft.Network/networkSecurityGroups/nsg-pass-nsg-target-days-30"
    retention_policy     = [{ days = 30, enabled = true }]
  }
}

resource "azurerm_network_watcher_flow_log" "pass_vnet_days_91" {
  attrs = {
    target_resource_id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-net/providers/Microsoft.Network/virtualNetworks/vnet-test"
    retention_policy = [{ enabled = true, days = 91 }]
  }
}

resource "azurerm_network_watcher_flow_log" "pass_indefinite_policy_disabled" {
  attrs = {
    target_resource_id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-net/providers/Microsoft.Network/virtualNetworks/vnet-test"
    retention_policy = [{ enabled = false, days = 0 }]
  }
}

resource "azurerm_network_watcher_flow_log" "pass_disabled_log_retention_90" {
  attrs = {
    target_resource_id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-net/providers/Microsoft.Network/virtualNetworks/vnet-test"
    enabled = false
    retention_policy = [{ enabled = true, days = 90 }]
  }
}

resource "azurerm_network_watcher_flow_log" "pass_null_or_omitted_days" {
  attrs = {
    target_resource_id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-net/providers/Microsoft.Network/virtualNetworks/vnet-test"
    retention_policy = [{ enabled = true, days = null }]
  }
}

resource "azurerm_network_watcher_flow_log" "pass_null_or_omitted_retention_block" {
  attrs = {
    target_resource_id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-net/providers/Microsoft.Network/virtualNetworks/vnet-test"
    retention_policy = null
  }
}

resource "azurerm_network_watcher_flow_log" "pass_target_normalized" {
  attrs = {
    target_resource_id = " /SUBSCRIPTIONS/00000000-0000-0000-0000-000000000000/RESOURCEGROUPS/rg-net/PROVIDERS/MICROSOFT.NETWORK/VIRTUALNETWORKS/vnet-test "
    retention_policy = [{ enabled = true, days = 90 }]
  }
}

resource "azurerm_network_watcher_flow_log" "fail_negative_days" {
  expect_failure = true
  attrs = {
    target_resource_id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-net/providers/Microsoft.Network/virtualNetworks/vnet-test"
    retention_policy = [{ enabled = true, days = -1 }]
  }
}

resource "azurerm_network_watcher_flow_log" "fail_disabled_log_short_retention" {
  expect_failure = true
  attrs = {
    target_resource_id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-net/providers/Microsoft.Network/virtualNetworks/vnet-test"
    enabled = false
    retention_policy = [{ enabled = true, days = 30 }]
  }
}

resource "azurerm_network_watcher_flow_log" "pass_subnet_out_of_scope" {
  attrs = {
    target_resource_id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-net/providers/Microsoft.Network/virtualNetworks/vnet-test/subnets/subnet-test"
    retention_policy = [{ enabled = true, days = 1 }]
  }
}

resource "azurerm_network_watcher_flow_log" "pass_nic_out_of_scope" {
  attrs = {
    target_resource_id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-net/providers/Microsoft.Network/networkInterfaces/nic-test"
    retention_policy = [{ enabled = true, days = 1 }]
  }
}

resource "azurerm_network_watcher_flow_log" "pass_null_or_omitted_target" {
  attrs = {
    target_resource_id = null
    retention_policy = [{ enabled = true, days = 1 }]
  }
}

resource "azurerm_network_watcher_flow_log" "pass_real_plan_null_or_omitted_target_and_storage" {
  attrs = {
    enabled = true
    retention_policy = [{ enabled = true, days = 90 }]
  }
}

resource "azurerm_virtual_network" "pass_vnet_without_log_out_of_scope" {
  attrs = {
    name = "vnet-unrelated"
  }
}
