policytest {
  targets = ["cis_azure_foundations_v6:7.11.policy.hcl"]
}

resource "azurerm_subnet_network_security_group_association" "pass_association" {
  attrs = {
    subnet_id = "/subscriptions/sub/resourceGroups/rg/providers/Microsoft.Network/virtualNetworks/vnet/subnets/protected"
    network_security_group_id = "/subscriptions/sub/resourceGroups/rg/providers/Microsoft.Network/networkSecurityGroups/nsg"
  }
}

resource "azurerm_subnet_network_security_group_association" "pass_unknown_nsg_for_known_subnet_deferred" {
  attrs = {
    subnet_id = "/subscriptions/sub/resourceGroups/rg/providers/Microsoft.Network/virtualNetworks/vnet/subnets/unknown-nsg"
  }
}

resource "azurerm_subnet_network_security_group_association" "fail_null_nsg" {
  expect_failure = true
  attrs = {
    subnet_id = "/subscriptions/sub/resourceGroups/rg/providers/Microsoft.Network/virtualNetworks/vnet/subnets/null-nsg"
    network_security_group_id = null
  }
}

resource "azurerm_subnet_network_security_group_association" "fail_blank_nsg" {
  expect_failure = true
  attrs = {
    subnet_id = "/subscriptions/sub/resourceGroups/rg/providers/Microsoft.Network/virtualNetworks/vnet/subnets/blank-nsg"
    network_security_group_id = " \t "
  }
}

resource "azurerm_subnet_network_security_group_association" "fail_malformed_nsg" {
  expect_failure = true
  attrs = {
    subnet_id = "/subscriptions/sub/resourceGroups/rg/providers/Microsoft.Network/virtualNetworks/vnet/subnets/bad-nsg"
    network_security_group_id = "nsg"
  }
}

resource "azurerm_subnet_network_security_group_association" "fail_null_subnet" {
  expect_failure = true
  attrs = {
    subnet_id = null
    network_security_group_id = ""
  }
}

resource "azurerm_subnet_network_security_group_association" "fail_blank_subnet" {
  expect_failure = true
  attrs = { subnet_id = " ", network_security_group_id = "" }
}

resource "azurerm_subnet_network_security_group_association" "fail_wrong_subnet_type" {
  expect_failure = true
  attrs = { subnet_id = "/subscriptions/sub/resourceGroups/rg/providers/Microsoft.Network/virtualNetworks/vnet", network_security_group_id = "" }
}

resource "azurerm_subnet" "pass_associated" {
  attrs = { id = "/subscriptions/sub/resourceGroups/rg/providers/Microsoft.Network/virtualNetworks/vnet/subnets/protected" }
}

resource "azurerm_subnet" "pass_associated_case_whitespace_slash" {
  attrs = { id = " /SUBSCRIPTIONS/SUB/RESOURCEGROUPS/RG/PROVIDERS/MICROSOFT.NETWORK/VIRTUALNETWORKS/VNET/SUBNETS/PROTECTED/ " }
}

resource "azurerm_subnet" "pass_computed_nsg_without_association_resource" {
  attrs = {
    id = "/subscriptions/sub/resourceGroups/rg/providers/Microsoft.Network/virtualNetworks/vnet/subnets/computed"
    network_security_group_id = "/subscriptions/sub/resourceGroups/rg/providers/Microsoft.Network/networkSecurityGroups/nsg"
  }
}

resource "azurerm_subnet" "pass_unknown_subnet_id_deferred" {
  attrs = { name = "new", network_security_group_id = null }
}

resource "azurerm_subnet" "pass_known_subnet_unknown_nsg_deferred" {
  attrs = { id = "/subscriptions/sub/resourceGroups/rg/providers/Microsoft.Network/virtualNetworks/vnet/subnets/unknown-nsg" }
}

resource "azurerm_subnet" "pass_write_only_version_deferred" {
  attrs = {
    id = "/subscriptions/sub/resourceGroups/rg/providers/Microsoft.Network/virtualNetworks/vnet/subnets/write-only"
    network_security_group_id_wo = null
    network_security_group_id_wo_version = 1
  }
}

resource "azurerm_subnet" "fail_missing_association" {
  expect_failure = true
  attrs = { id = "/subscriptions/sub/resourceGroups/rg/providers/Microsoft.Network/virtualNetworks/vnet/subnets/unprotected" }
}

resource "azurerm_subnet" "fail_same_name_other_subscription" {
  expect_failure = true
  attrs = { id = "/subscriptions/other/resourceGroups/rg/providers/Microsoft.Network/virtualNetworks/vnet/subnets/protected" }
}

resource "azurerm_subnet" "fail_same_name_other_rg" {
  expect_failure = true
  attrs = { id = "/subscriptions/sub/resourceGroups/other/providers/Microsoft.Network/virtualNetworks/vnet/subnets/protected" }
}

resource "azurerm_subnet" "fail_same_name_other_vnet" {
  expect_failure = true
  attrs = { id = "/subscriptions/sub/resourceGroups/rg/providers/Microsoft.Network/virtualNetworks/other/subnets/protected" }
}

resource "azurerm_subnet" "fail_sibling_name" {
  expect_failure = true
  attrs = { id = "/subscriptions/sub/resourceGroups/rg/providers/Microsoft.Network/virtualNetworks/vnet/subnets/protected-other" }
}

resource "azurerm_subnet" "fail_invalid_computed_nsg" {
  expect_failure = true
  attrs = {
    id = "/subscriptions/sub/resourceGroups/rg/providers/Microsoft.Network/virtualNetworks/vnet/subnets/invalid"
    network_security_group_id = "invalid"
  }
}

resource "azurerm_subnet" "fail_write_only_zero_version" {
  expect_failure = true
  attrs = {
    id = "/subscriptions/sub/resourceGroups/rg/providers/Microsoft.Network/virtualNetworks/vnet/subnets/write-only"
    network_security_group_id_wo_version = 0
  }
}

resource "azurerm_virtual_network" "pass_inline_protected" {
  attrs = {
    subnet = [{ name = "app", security_group = "/subscriptions/sub/resourceGroups/rg/providers/Microsoft.Network/networkSecurityGroups/nsg" }]
  }
}

resource "azurerm_virtual_network" "pass_inline_two_protected" {
  attrs = {
    subnet = [
      { name = "app", security_group = "/subscriptions/sub/resourceGroups/rg/providers/Microsoft.Network/networkSecurityGroups/nsg" },
      { name = "db", security_group = "/subscriptions/sub/resourceGroups/rg/providers/Microsoft.Network/networkSecurityGroups/nsg" }
    ]
  }
}

resource "azurerm_virtual_network" "pass_inline_unknown_nsg_deferred" {
  attrs = { subnet = [{ name = "app" }] }
}

resource "azurerm_virtual_network" "pass_inline_unknown_collection_deferred" {
  attrs = { subnet = null }
}

resource "azurerm_virtual_network" "pass_no_inline_subnets" {
  attrs = { name = "standalone-subnets-vnet" }
}

resource "azurerm_virtual_network" "pass_empty_inline_subnets" {
  attrs = { subnet = [] }
}

resource "azurerm_virtual_network" "fail_inline_known_null_nsg" {
  expect_failure = true
  attrs = { subnet = [{ name = "app", security_group = null }] }
}

resource "azurerm_virtual_network" "fail_inline_empty_nsg" {
  expect_failure = true
  attrs = { subnet = [{ name = "app", security_group = "" }] }
}

resource "azurerm_virtual_network" "fail_inline_whitespace_nsg" {
  expect_failure = true
  attrs = { subnet = [{ name = "app", security_group = " \t " }] }
}

resource "azurerm_virtual_network" "fail_inline_malformed_nsg" {
  expect_failure = true
  attrs = { subnet = [{ name = "app", security_group = "nsg" }] }
}

resource "azurerm_virtual_network" "fail_inline_one_unprotected" {
  expect_failure = true
  attrs = {
    subnet = [
      { name = "app", security_group = "/subscriptions/sub/resourceGroups/rg/providers/Microsoft.Network/networkSecurityGroups/nsg" },
      { name = "db", security_group = null }
    ]
  }
}

resource "azurerm_virtual_network" "fail_inline_known_bad_among_unknown" {
  expect_failure = true
  attrs = { subnet = [{ name = "unknown" }, { name = "unprotected", security_group = "" }] }
}

resource "azurerm_virtual_network" "fail_gateway_subnet_no_implicit_exemption" {
  expect_failure = true
  attrs = { subnet = [{ name = "GatewaySubnet", security_group = null }] }
}

resource "azurerm_virtual_network" "fail_route_table_not_nsg" {
  expect_failure = true
  attrs = { subnet = [{ name = "app", security_group = "/subscriptions/sub/resourceGroups/rg/providers/Microsoft.Network/routeTables/route" }] }
}

resource "azurerm_network_security_group" "pass_unattached_nsg_not_enough" {
  attrs = { name = "nsg", location = "eastus" }
}

resource "azurerm_subnet" "fail_association_with_null_nsg" {
  expect_failure = true
  attrs = { id = "/subscriptions/sub/resourceGroups/rg/providers/Microsoft.Network/virtualNetworks/vnet/subnets/null-nsg" }
}

resource "azurerm_subnet" "fail_association_with_blank_nsg" {
  expect_failure = true
  attrs = { id = "/subscriptions/sub/resourceGroups/rg/providers/Microsoft.Network/virtualNetworks/vnet/subnets/blank-nsg" }
}

resource "azurerm_subnet" "fail_association_with_malformed_nsg" {
  expect_failure = true
  attrs = { id = "/subscriptions/sub/resourceGroups/rg/providers/Microsoft.Network/virtualNetworks/vnet/subnets/bad-nsg" }
}

resource "azurerm_virtual_network" "pass_inline_normalized_nsg_id" {
  attrs = {
    subnet = [{ name = "app", security_group = " /SUBSCRIPTIONS/SUB/RESOURCEGROUPS/RG/PROVIDERS/MICROSOFT.NETWORK/NETWORKSECURITYGROUPS/NSG/ " }]
  }
}
