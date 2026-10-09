# Copyright IBM Corp. 2026

policytest {
  targets = ["network-watcher-enabled.policy.hcl"]
}

resource "azurerm_network_watcher" "pass_eastus" {
  attrs = {
    name                = "NetworkWatcher_eastus"
    location            = "eastus"
    resource_group_name = "NetworkWatcherRG"
  }
}

resource "azurerm_network_watcher" "pass_westeurope" {
  attrs = {
    name                = "NetworkWatcher_westeurope"
    location            = "westeurope"
    resource_group_name = "NetworkWatcherRG"
  }
}

resource "azurerm_network_watcher" "pass_north_europe_display_name" {
  attrs = {
    name                = "NetworkWatcher_northeurope"
    location            = "North Europe"
    resource_group_name = "NetworkWatcherRG"
  }
}

resource "azurerm_network_watcher" "fail_location_empty" {
  expect_failure = true
  attrs = {
    name                = "NetworkWatcher_empty"
    location            = ""
    resource_group_name = "NetworkWatcherRG"
  }
}

resource "azurerm_network_watcher" "pass_location_null_deferred" {
  attrs = {
    name                = "NetworkWatcher_null"
    location            = null
    resource_group_name = "NetworkWatcherRG"
  }
}

resource "azurerm_virtual_network" "pass_vnet_eastus_covered" {
  attrs = {
    name                = "vnet-eastus"
    location            = "eastus"
    resource_group_name = "app-rg"
    address_space       = ["10.0.0.0/16"]
  }
}

resource "azurerm_virtual_network" "pass_vnet_westeurope_covered" {
  attrs = {
    name                = "vnet-westeurope"
    location            = "westeurope"
    resource_group_name = "app-rg"
    address_space       = ["10.1.0.0/16"]
  }
}

resource "azurerm_virtual_network" "pass_vnet_display_name_eastus_covered" {
  attrs = {
    name                = "vnet-east-us-display"
    location            = "East US"
    resource_group_name = "app-rg"
    address_space       = ["10.4.0.0/16"]
  }
}

resource "azurerm_virtual_network" "pass_vnet_northeurope_covered_by_display_name_watcher" {
  attrs = {
    name                = "vnet-northeurope"
    location            = "northeurope"
    resource_group_name = "app-rg"
    address_space       = ["10.5.0.0/16"]
  }
}

resource "azurerm_virtual_network" "fail_vnet_westus_uncovered" {
  expect_failure = true
  attrs = {
    name                = "vnet-westus"
    location            = "westus"
    resource_group_name = "app-rg"
    address_space       = ["10.2.0.0/16"]
  }
}

resource "azurerm_virtual_network" "fail_vnet_japan_east_display_uncovered" {
  expect_failure = true
  attrs = {
    name                = "vnet-japaneast"
    location            = "Japan East"
    resource_group_name = "app-rg"
    address_space       = ["10.3.0.0/16"]
  }
}

resource "azurerm_network_watcher" "pass_known_subscription_watcher" {
  attrs = {
    id = "/subscriptions/11111111-1111-1111-1111-111111111111/resourceGroups/rg-net/providers/Microsoft.Network/networkWatchers/nw-centralus"
    location = "centralus"
  }
}

resource "azurerm_virtual_network" "pass_same_subscription" {
  attrs = {
    id = "/subscriptions/11111111-1111-1111-1111-111111111111/resourceGroups/rg-net/providers/Microsoft.Network/virtualNetworks/vnet-centralus"
    location = "centralus"
  }
}

resource "azurerm_virtual_network" "fail_other_subscription" {
  expect_failure = true
  attrs = {
    id = "/subscriptions/22222222-2222-2222-2222-222222222222/resourceGroups/rg-net/providers/Microsoft.Network/virtualNetworks/vnet-centralus"
    location = "centralus"
  }
}

resource "azurerm_virtual_network" "pass_null_or_omitted_location" {
  attrs = {
    location = null
  }
}

resource "azurerm_virtual_network" "fail_blank_location" {
  expect_failure = true
  attrs = {
    location = "   "
  }
}

resource "azurerm_network_watcher" "fail_whitespace_location" {
  expect_failure = true
  attrs = {
    location = "   "
  }
}

resource "azurerm_virtual_network" "pass_normalized_region" {
  attrs = {
    location = " EAST US "
  }
}

resource "azurerm_virtual_network" "fail_region_not_regex" {
  expect_failure = true
  attrs = {
    location = "east.*"
  }
}

resource "azurerm_network_watcher" "pass_duplicate_region" {
  attrs = {
    location = "eastus"
  }
}

resource "azurerm_virtual_network" "pass_second_vnet_same_region" {
  attrs = {
    location = "eastus"
  }
}

resource "azurerm_resource_group" "pass_other_resource_out_of_scope" {
  attrs = {
    location = "japaneast"
  }
}
