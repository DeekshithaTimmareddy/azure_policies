# Copyright IBM Corp. 2026

policytest {
  targets = ["databricks-subnet-nsg-configured.policy.hcl"]
}

resource "azurerm_network_security_group" "databricks_nsg_with_inline_deny" {
  attrs = {
    id                  = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-network/providers/Microsoft.Network/networkSecurityGroups/nsg-databricks"
    name                = "nsg-databricks"
    location            = "eastus"
    resource_group_name = "rg-network"
    security_rule = [{
      name                       = "deny-known-unwanted"
      access                     = "Deny"
      direction                  = "Inbound"
      priority                   = 200
      protocol                   = "*"
      source_address_prefix      = "198.51.100.0/24"
      destination_address_prefix = "*"
      source_port_range          = "*"
      destination_port_range     = "*"
    }]
  }
}

resource "azurerm_databricks_workspace" "both_subnets_associated" {
  attrs = {
    name                = "dbw-associated"
    location            = "eastus"
    resource_group_name = "rg-databricks"
    sku                 = "premium"
    custom_parameters = [{
      virtual_network_id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-network/providers/Microsoft.Network/virtualNetworks/vnet-databricks"
      public_subnet_name = "public-subnet"
      private_subnet_name = "private-subnet"
    }]
  }
}

resource "azurerm_subnet_network_security_group_association" "public_association" {
  skip = true
  attrs = {
    subnet_id                 = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-network/providers/Microsoft.Network/virtualNetworks/vnet-databricks/subnets/public-subnet"
    network_security_group_id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-network/providers/Microsoft.Network/networkSecurityGroups/nsg-databricks"
  }
}

resource "azurerm_subnet_network_security_group_association" "private_association" {
  skip = true
  attrs = {
    subnet_id                 = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-network/providers/Microsoft.Network/virtualNetworks/vnet-databricks/subnets/private-subnet"
    network_security_group_id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-network/providers/Microsoft.Network/networkSecurityGroups/nsg-databricks"
  }
}

resource "azurerm_databricks_workspace" "missing_public_association" {
  expect_failure = true
  attrs = {
    name                = "dbw-no-public-association"
    location            = "eastus"
    resource_group_name = "rg-databricks"
    sku                 = "premium"
    custom_parameters = [{
      virtual_network_id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-public-missing/providers/Microsoft.Network/virtualNetworks/vnet-public-missing"
      public_subnet_name = "public-subnet"
      private_subnet_name = "private-subnet"
    }]
  }
}

resource "azurerm_subnet_network_security_group_association" "only_private_association" {
  skip = true
  attrs = {
    subnet_id                 = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-public-missing/providers/Microsoft.Network/virtualNetworks/vnet-public-missing/subnets/private-subnet"
    network_security_group_id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-public-missing/providers/Microsoft.Network/networkSecurityGroups/nsg-private"
  }
}

resource "azurerm_databricks_workspace" "missing_private_association" {
  expect_failure = true
  attrs = {
    name                = "dbw-no-private-association"
    location            = "eastus"
    resource_group_name = "rg-databricks"
    sku                 = "premium"
    custom_parameters = [{
      virtual_network_id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-private-missing/providers/Microsoft.Network/virtualNetworks/vnet-private-missing"
      public_subnet_name = "public-subnet"
      private_subnet_name = "private-subnet"
    }]
  }
}

resource "azurerm_subnet_network_security_group_association" "only_public_association" {
  skip = true
  attrs = {
    subnet_id                 = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-private-missing/providers/Microsoft.Network/virtualNetworks/vnet-private-missing/subnets/public-subnet"
    network_security_group_id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-private-missing/providers/Microsoft.Network/networkSecurityGroups/nsg-public"
  }
}

resource "azurerm_databricks_workspace" "unrelated_association" {
  expect_failure = true
  attrs = {
    name                = "dbw-unrelated-association"
    location            = "eastus"
    resource_group_name = "rg-databricks"
    sku                 = "premium"
    custom_parameters = [{
      virtual_network_id  = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-correct/providers/Microsoft.Network/virtualNetworks/vnet-correct"
      public_subnet_name  = "public-subnet"
      private_subnet_name = "private-subnet"
    }]
  }
}

resource "azurerm_subnet_network_security_group_association" "wrong_vnet_association" {
  skip = true
  attrs = {
    subnet_id                 = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-other/providers/Microsoft.Network/virtualNetworks/vnet-other/subnets/public-subnet"
    network_security_group_id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-other/providers/Microsoft.Network/networkSecurityGroups/nsg-other"
  }
}

resource "azurerm_databricks_workspace" "blank_nsg_id" {
  expect_failure = true
  attrs = {
    name                = "dbw-blank-nsg-id"
    location            = "eastus"
    resource_group_name = "rg-databricks"
    sku                 = "premium"
    custom_parameters = [{
      virtual_network_id  = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-blank-nsg/providers/Microsoft.Network/virtualNetworks/vnet-blank-nsg"
      public_subnet_name  = "public-subnet"
      private_subnet_name = "private-subnet"
    }]
  }
}

resource "azurerm_subnet_network_security_group_association" "blank_nsg_association" {
  skip = true
  attrs = {
    subnet_id                 = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-blank-nsg/providers/Microsoft.Network/virtualNetworks/vnet-blank-nsg/subnets/public-subnet"
    network_security_group_id = ""
  }
}

resource "azurerm_databricks_workspace" "associated_nsg_allow_only" {
  expect_failure = true
  attrs = {
    name                = "dbw-associated-nsg-without-deny"
    location            = "eastus"
    resource_group_name = "rg-databricks"
    sku                 = "premium"
    custom_parameters = [{
      virtual_network_id  = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-no-deny/providers/Microsoft.Network/virtualNetworks/vnet-no-deny"
      public_subnet_name  = "public-subnet"
      private_subnet_name = "private-subnet"
    }]
  }
}

resource "azurerm_network_security_group" "associated_allow_only" {
  skip = true
  attrs = {
    id                  = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-no-deny/providers/Microsoft.Network/networkSecurityGroups/nsg-allow-only"
    name                = "nsg-allow-only"
    location            = "eastus"
    resource_group_name = "rg-no-deny"
    security_rule = [{
      name                       = "allow-app"
      access                     = "Allow"
      direction                  = "Inbound"
      priority                   = 100
      protocol                   = "Tcp"
      source_address_prefix      = "10.0.0.0/16"
      destination_address_prefix = "*"
      source_port_range          = "*"
      destination_port_range     = "443"
    }]
  }
}

resource "azurerm_subnet_network_security_group_association" "allow_only_public_association" {
  skip = true
  attrs = {
    subnet_id                 = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-no-deny/providers/Microsoft.Network/virtualNetworks/vnet-no-deny/subnets/public-subnet"
    network_security_group_id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-no-deny/providers/Microsoft.Network/networkSecurityGroups/nsg-allow-only"
  }
}

resource "azurerm_subnet_network_security_group_association" "allow_only_private_association" {
  skip = true
  attrs = {
    subnet_id                 = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-no-deny/providers/Microsoft.Network/virtualNetworks/vnet-no-deny/subnets/private-subnet"
    network_security_group_id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-no-deny/providers/Microsoft.Network/networkSecurityGroups/nsg-allow-only"
  }
}

resource "azurerm_databricks_workspace" "standalone_deny_rule" {
  attrs = {
    name                = "dbw-standalone-deny"
    location            = "eastus"
    resource_group_name = "rg-databricks"
    sku                 = "premium"
    custom_parameters = [{
      virtual_network_id  = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-standalone/providers/Microsoft.Network/virtualNetworks/vnet-standalone"
      public_subnet_name  = "public-subnet"
      private_subnet_name = "private-subnet"
    }]
  }
}

resource "azurerm_network_security_group" "standalone_rule_nsg" {
  skip = true
  attrs = {
    id                  = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-standalone/providers/Microsoft.Network/networkSecurityGroups/nsg-standalone"
    name                = "nsg-standalone"
    location            = "eastus"
    resource_group_name = "rg-standalone"
  }
}

resource "azurerm_network_security_rule" "standalone_deny_rule" {
  skip = true
  attrs = {
    name                        = "deny-unwanted"
    access                      = "Deny"
    direction                   = "Inbound"
    priority                    = 200
    protocol                    = "*"
    source_address_prefix       = "198.51.100.0/24"
    destination_address_prefix  = "*"
    source_port_range           = "*"
    destination_port_range      = "*"
    network_security_group_name = "nsg-standalone"
    resource_group_name         = "rg-standalone"
  }
}

resource "azurerm_subnet_network_security_group_association" "standalone_deny_public_association" {
  skip = true
  attrs = {
    subnet_id                 = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-standalone/providers/Microsoft.Network/virtualNetworks/vnet-standalone/subnets/public-subnet"
    network_security_group_id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-standalone/providers/Microsoft.Network/networkSecurityGroups/nsg-standalone"
  }
}

resource "azurerm_subnet_network_security_group_association" "standalone_deny_private_association" {
  skip = true
  attrs = {
    subnet_id                 = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-standalone/providers/Microsoft.Network/virtualNetworks/vnet-standalone/subnets/private-subnet"
    network_security_group_id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-standalone/providers/Microsoft.Network/networkSecurityGroups/nsg-standalone"
  }
}

resource "azurerm_databricks_workspace" "standalone_rule_wrong_resource_group" {
  expect_failure = true
  attrs = {
    name                = "dbw-wrong-rule-resource-group"
    location            = "eastus"
    resource_group_name = "rg-databricks"
    sku                 = "premium"
    custom_parameters = [{
      virtual_network_id  = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-target/providers/Microsoft.Network/virtualNetworks/vnet-target"
      public_subnet_name  = "public-subnet"
      private_subnet_name = "private-subnet"
    }]
  }
}

resource "azurerm_network_security_group" "target_nsg_no_inline_rules" {
  skip = true
  attrs = {
    id                  = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-target/providers/Microsoft.Network/networkSecurityGroups/nsg-collision"
    name                = "nsg-collision"
    location            = "eastus"
    resource_group_name = "rg-target"
    security_rule       = []
  }
}

resource "azurerm_network_security_rule" "same_name_rule_other_group" {
  skip = true
  attrs = {
    id                          = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-other/providers/Microsoft.Network/networkSecurityGroups/nsg-collision/securityRules/deny-unwanted"
    name                        = "deny-unwanted"
    access                      = "Deny"
    direction                   = "Inbound"
    priority                    = 200
    protocol                    = "*"
    source_address_prefix       = "198.51.100.0/24"
    destination_address_prefix  = "*"
    source_port_range           = "*"
    destination_port_range      = "*"
    network_security_group_name = "nsg-collision"
    resource_group_name         = "rg-other"
  }
}

resource "azurerm_subnet_network_security_group_association" "target_public_association" {
  skip = true
  attrs = {
    subnet_id                 = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-target/providers/Microsoft.Network/virtualNetworks/vnet-target/subnets/public-subnet"
    network_security_group_id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-target/providers/Microsoft.Network/networkSecurityGroups/nsg-collision"
  }
}

resource "azurerm_subnet_network_security_group_association" "target_private_association" {
  skip = true
  attrs = {
    subnet_id                 = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-target/providers/Microsoft.Network/virtualNetworks/vnet-target/subnets/private-subnet"
    network_security_group_id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-target/providers/Microsoft.Network/networkSecurityGroups/nsg-collision"
  }
}

resource "azurerm_databricks_workspace" "no_vnet_configuration" {
  expect_failure = true
  attrs = {
    name                = "dbw-no-vnet-configuration"
    location            = "eastus"
    resource_group_name = "rg-databricks"
    sku                 = "standard"
  }
}

resource "azurerm_databricks_workspace" "distinct_nsgs_one_without_deny" {
  expect_failure = true
  attrs = {
    name                = "dbw-distinct-nsgs-one-without-deny"
    location            = "eastus"
    resource_group_name = "rg-databricks"
    sku                 = "premium"
    custom_parameters = [{
      virtual_network_id  = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-split/providers/Microsoft.Network/virtualNetworks/vnet-split"
      public_subnet_name  = "public-subnet"
      private_subnet_name = "private-subnet"
    }]
  }
}

resource "azurerm_network_security_group" "public_split_nsg_with_deny" {
  skip = true
  attrs = {
    id                  = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-split/providers/Microsoft.Network/networkSecurityGroups/nsg-public"
    name                = "nsg-public"
    location            = "eastus"
    resource_group_name = "rg-split"
    security_rule = [{
      name                       = "deny-unwanted"
      access                     = "Deny"
      direction                  = "Inbound"
      priority                   = 200
      protocol                   = "*"
      source_address_prefix      = "198.51.100.0/24"
      destination_address_prefix = "*"
      source_port_range          = "*"
      destination_port_range     = "*"
    }]
  }
}

resource "azurerm_network_security_group" "private_split_nsg_allow_only" {
  skip = true
  attrs = {
    id                  = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-split/providers/Microsoft.Network/networkSecurityGroups/nsg-private"
    name                = "nsg-private"
    location            = "eastus"
    resource_group_name = "rg-split"
    security_rule = [{
      name                       = "allow-app"
      access                     = "Allow"
      direction                  = "Inbound"
      priority                   = 100
      protocol                   = "Tcp"
      source_address_prefix      = "10.0.0.0/16"
      destination_address_prefix = "*"
      source_port_range          = "*"
      destination_port_range     = "443"
    }]
  }
}

resource "azurerm_subnet_network_security_group_association" "split_public_association" {
  skip = true
  attrs = {
    subnet_id                 = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-split/providers/Microsoft.Network/virtualNetworks/vnet-split/subnets/public-subnet"
    network_security_group_id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-split/providers/Microsoft.Network/networkSecurityGroups/nsg-public"
  }
}

resource "azurerm_subnet_network_security_group_association" "split_private_association" {
  skip = true
  attrs = {
    subnet_id                 = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-split/providers/Microsoft.Network/virtualNetworks/vnet-split/subnets/private-subnet"
    network_security_group_id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-split/providers/Microsoft.Network/networkSecurityGroups/nsg-private"
  }
}

resource "azurerm_databricks_workspace" "associated_nsgs_absent_from_plan" {
  expect_failure = true
  attrs = {
    name                = "dbw-associated-nsgs-absent-from-plan"
    location            = "eastus"
    resource_group_name = "rg-databricks"
    sku                 = "premium"
    custom_parameters = [{
      virtual_network_id  = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-not-planned/providers/Microsoft.Network/virtualNetworks/vnet-not-planned"
      public_subnet_name  = "public-subnet"
      private_subnet_name = "private-subnet"
    }]
  }
}

resource "azurerm_subnet_network_security_group_association" "not_planned_public_association" {
  skip = true
  attrs = {
    subnet_id                 = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-not-planned/providers/Microsoft.Network/virtualNetworks/vnet-not-planned/subnets/public-subnet"
    network_security_group_id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-not-planned/providers/Microsoft.Network/networkSecurityGroups/nsg-not-planned-public"
  }
}

resource "azurerm_subnet_network_security_group_association" "not_planned_private_association" {
  skip = true
  attrs = {
    subnet_id                 = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-not-planned/providers/Microsoft.Network/virtualNetworks/vnet-not-planned/subnets/private-subnet"
    network_security_group_id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-not-planned/providers/Microsoft.Network/networkSecurityGroups/nsg-not-planned-private"
  }
}
