# Copyright IBM Corp. 2026

policytest {
  targets = ["nsg-flow-log-retention.policy.hcl"]
}

resource "azurerm_network_watcher_flow_log" "pass_days_90" {
  attrs = {
    name                 = "fl-pass_days_90"
    network_watcher_name = "nw-eastus"
    resource_group_name  = "rg-net"
    enabled              = true
    storage_account_id   = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-net/providers/Microsoft.Storage/storageAccounts/stlogs"
    target_resource_id   = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-net/providers/Microsoft.Network/networkSecurityGroups/nsg-pass_days_90"
    retention_policy     = [{ enabled = true, days = 90 }]
  }
}

resource "azurerm_network_watcher_flow_log" "pass_days_365" {
  attrs = {
    name                 = "fl-pass_days_365"
    network_watcher_name = "nw-eastus"
    resource_group_name  = "rg-net"
    enabled              = true
    storage_account_id   = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-net/providers/Microsoft.Storage/storageAccounts/stlogs"
    target_resource_id   = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-net/providers/Microsoft.Network/networkSecurityGroups/nsg-pass_days_365"
    retention_policy     = [{ enabled = true, days = 365 }]
  }
}

resource "azurerm_network_watcher_flow_log" "pass_days_0" {
  attrs = {
    name                 = "fl-pass_days_0"
    network_watcher_name = "nw-eastus"
    resource_group_name  = "rg-net"
    enabled              = true
    storage_account_id   = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-net/providers/Microsoft.Storage/storageAccounts/stlogs"
    target_resource_id   = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-net/providers/Microsoft.Network/networkSecurityGroups/nsg-pass_days_0"
    retention_policy     = [{ enabled = true, days = 0 }]
  }
}

resource "azurerm_network_watcher_flow_log" "fail_days_89" {
  expect_failure = true
  attrs = {
    name                 = "fl-fail_days_89"
    network_watcher_name = "nw-eastus"
    resource_group_name  = "rg-net"
    enabled              = true
    storage_account_id   = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-net/providers/Microsoft.Storage/storageAccounts/stlogs"
    target_resource_id   = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-net/providers/Microsoft.Network/networkSecurityGroups/nsg-fail_days_89"
    retention_policy     = [{ enabled = true, days = 89 }]
  }
}

resource "azurerm_network_watcher_flow_log" "fail_days_30" {
  expect_failure = true
  attrs = {
    name                 = "fl-fail_days_30"
    network_watcher_name = "nw-eastus"
    resource_group_name  = "rg-net"
    enabled              = true
    storage_account_id   = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-net/providers/Microsoft.Storage/storageAccounts/stlogs"
    target_resource_id   = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-net/providers/Microsoft.Network/networkSecurityGroups/nsg-fail_days_30"
    retention_policy     = [{ enabled = true, days = 30 }]
  }
}

resource "azurerm_network_watcher_flow_log" "fail_disabled_days_90" {
  expect_failure = true
  attrs = {
    name                 = "fl-fail_disabled_days_90"
    network_watcher_name = "nw-eastus"
    resource_group_name  = "rg-net"
    enabled              = false
    storage_account_id   = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-net/providers/Microsoft.Storage/storageAccounts/stlogs"
    target_resource_id   = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-net/providers/Microsoft.Network/networkSecurityGroups/nsg-fail_disabled_days_90"
    retention_policy     = [{ enabled = true, days = 90 }]
  }
}

resource "azurerm_network_watcher_flow_log" "fail_disabled_days_0" {
  expect_failure = true
  attrs = {
    name                 = "fl-fail_disabled_days_0"
    network_watcher_name = "nw-eastus"
    resource_group_name  = "rg-net"
    enabled              = false
    storage_account_id   = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-net/providers/Microsoft.Storage/storageAccounts/stlogs"
    target_resource_id   = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-net/providers/Microsoft.Network/networkSecurityGroups/nsg-fail_disabled_days_0"
    retention_policy     = [{ enabled = true, days = 0 }]
  }
}

resource "azurerm_network_watcher_flow_log" "pass_days_91" {
  attrs = {
    target_resource_id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-net/providers/Microsoft.Network/networkSecurityGroups/nsg-test"
    enabled = true
    retention_policy = [{ enabled = true, days = 91 }]
  }
}

resource "azurerm_network_watcher_flow_log" "pass_indefinite_retention_disabled" {
  attrs = {
    target_resource_id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-net/providers/Microsoft.Network/networkSecurityGroups/nsg-test"
    enabled = true
    retention_policy = [{ enabled = false, days = 0 }]
  }
}

resource "azurerm_network_watcher_flow_log" "pass_null_or_omitted_days" {
  attrs = {
    target_resource_id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-net/providers/Microsoft.Network/networkSecurityGroups/nsg-test"
    enabled = true
    retention_policy = [{ enabled = true, days = null }]
  }
}

resource "azurerm_network_watcher_flow_log" "pass_null_or_omitted_retention_block" {
  attrs = {
    target_resource_id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-net/providers/Microsoft.Network/networkSecurityGroups/nsg-test"
    enabled = true
    retention_policy = null
  }
}

resource "azurerm_network_watcher_flow_log" "pass_null_or_omitted_enabled" {
  attrs = {
    target_resource_id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-net/providers/Microsoft.Network/networkSecurityGroups/nsg-test"
    enabled = null
    retention_policy = [{ enabled = true, days = 90 }]
  }
}

resource "azurerm_network_watcher_flow_log" "pass_target_normalized" {
  attrs = {
    target_resource_id = " /SUBSCRIPTIONS/00000000-0000-0000-0000-000000000000/RESOURCEGROUPS/rg-net/PROVIDERS/MICROSOFT.NETWORK/NETWORKSECURITYGROUPS/nsg-test "
    enabled = true
    retention_policy = [{ enabled = true, days = 90 }]
  }
}

resource "azurerm_network_watcher_flow_log" "fail_days_1" {
  expect_failure = true
  attrs = {
    target_resource_id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-net/providers/Microsoft.Network/networkSecurityGroups/nsg-test"
    enabled = true
    retention_policy = [{ enabled = true, days = 1 }]
  }
}

resource "azurerm_network_watcher_flow_log" "fail_negative_days" {
  expect_failure = true
  attrs = {
    target_resource_id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-net/providers/Microsoft.Network/networkSecurityGroups/nsg-test"
    enabled = true
    retention_policy = [{ enabled = true, days = -1 }]
  }
}

resource "azurerm_network_watcher_flow_log" "fail_short_days_retention_disabled" {
  expect_failure = true
  attrs = {
    target_resource_id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-net/providers/Microsoft.Network/networkSecurityGroups/nsg-test"
    enabled = true
    retention_policy = [{ enabled = false, days = 30 }]
  }
}

resource "azurerm_network_watcher_flow_log" "fail_disabled_null_or_omitted_days" {
  expect_failure = true
  attrs = {
    target_resource_id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-net/providers/Microsoft.Network/networkSecurityGroups/nsg-test"
    enabled = false
    retention_policy = [{ enabled = true, days = null }]
  }
}

resource "azurerm_network_watcher_flow_log" "pass_vnet_out_of_scope" {
  attrs = {
    target_resource_id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-net/providers/Microsoft.Network/virtualNetworks/vnet-test"
    enabled = false
    retention_policy = [{ enabled = true, days = 1 }]
  }
}

resource "azurerm_network_watcher_flow_log" "pass_subnet_out_of_scope" {
  attrs = {
    target_resource_id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-net/providers/Microsoft.Network/virtualNetworks/vnet-test/subnets/subnet-test"
    enabled = false
    retention_policy = [{ enabled = true, days = 1 }]
  }
}

resource "azurerm_network_watcher_flow_log" "pass_nic_out_of_scope" {
  attrs = {
    target_resource_id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-net/providers/Microsoft.Network/networkInterfaces/nic-test"
    enabled = false
    retention_policy = [{ enabled = true, days = 1 }]
  }
}

resource "azurerm_network_watcher_flow_log" "pass_null_or_omitted_target_deferred" {
  attrs = {
    target_resource_id = null
    enabled = false
    retention_policy = [{ enabled = true, days = 1 }]
  }
}

resource "azurerm_network_security_group" "pass_nsg_without_log_out_of_scope" {
  attrs = {
    name = "nsg-unrelated"
  }
}
