# Copyright IBM Corp. 2026

policytest {
  targets = ["databricks-private-endpoints-used.policy.hcl"]
}

resource "azurerm_databricks_workspace" "has_private_endpoint" {
  attrs = {
    id                  = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-a/providers/Microsoft.Databricks/workspaces/ws-a"
    name                = "ws-a"
    location            = "eastus"
    resource_group_name = "rg-a"
    sku                 = "premium"
    custom_parameters = [{
      virtual_network_id  = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-a/providers/Microsoft.Network/virtualNetworks/vnet-a"
      public_subnet_name  = "public"
      private_subnet_name = "private"
      no_public_ip        = true
    }]
  }
}

resource "azurerm_private_endpoint" "pe_for_ws_a" {
  skip = true
  attrs = {
    name                = "pe-ws-a"
    location            = "eastus"
    resource_group_name = "rg-a"
    subnet_id           = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-a/providers/Microsoft.Network/virtualNetworks/vnet-a/subnets/subnet-a"
    private_service_connection = [{
      is_manual_connection           = false
      name                           = "psc-ws-a"
      private_connection_resource_id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-a/providers/Microsoft.Databricks/workspaces/ws-a"
      subresource_names              = ["databricks_ui_api"]
    }]
  }
}

resource "azurerm_databricks_workspace" "no_private_endpoint" {
  expect_failure = true
  attrs = {
    id                  = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-b/providers/Microsoft.Databricks/workspaces/ws-b"
    name                = "ws-b"
    location            = "eastus"
    resource_group_name = "rg-b"
    sku                 = "premium"
    custom_parameters = [{
      virtual_network_id  = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-b/providers/Microsoft.Network/virtualNetworks/vnet-b"
      public_subnet_name  = "public"
      private_subnet_name = "private"
      no_public_ip        = true
    }]
  }
}

resource "azurerm_databricks_workspace" "endpoint_for_other_resource" {
  expect_failure = true
  attrs = {
    id                  = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-c/providers/Microsoft.Databricks/workspaces/ws-c"
    name                = "ws-c"
    location            = "eastus"
    resource_group_name = "rg-c"
    sku                 = "premium"
    custom_parameters = [{
      virtual_network_id  = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-c/providers/Microsoft.Network/virtualNetworks/vnet-c"
      public_subnet_name  = "public"
      private_subnet_name = "private"
      no_public_ip        = true
    }]
  }
}

resource "azurerm_private_endpoint" "pe_for_other" {
  skip = true
  attrs = {
    name                = "pe-other"
    location            = "eastus"
    resource_group_name = "rg-c"
    subnet_id           = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-c/providers/Microsoft.Network/virtualNetworks/vnet-c/subnets/subnet-c"
    private_service_connection = [{
      is_manual_connection           = false
      name                           = "psc-other"
      private_connection_resource_id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-c/providers/Microsoft.Storage/storageAccounts/someacct"
      subresource_names              = ["blob"]
    }]
  }
}

resource "azurerm_databricks_workspace" "endpoint_missing_resource_id" {
  expect_failure = true
  attrs = {
    id                  = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-d/providers/Microsoft.Databricks/workspaces/ws-d"
    name                = "ws-d"
    location            = "eastus"
    resource_group_name = "rg-d"
    sku                 = "premium"
    custom_parameters = [{
      virtual_network_id  = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-d/providers/Microsoft.Network/virtualNetworks/vnet-d"
      public_subnet_name  = "public"
      private_subnet_name = "private"
      no_public_ip        = true
    }]
  }
}

resource "azurerm_private_endpoint" "pe_missing_resource_id" {
  skip = true
  attrs = {
    name                = "pe-ws-d"
    location            = "eastus"
    resource_group_name = "rg-d"
    subnet_id           = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-d/providers/Microsoft.Network/virtualNetworks/vnet-d/subnets/subnet-d"
    private_service_connection = [{
      is_manual_connection              = false
      name                              = "psc-ws-d"
      private_connection_resource_alias = "alias-only.privatelink.example"
      subresource_names                 = ["databricks_ui_api"]
    }]
  }
}

resource "azurerm_databricks_workspace" "substring_false_correlation" {
  expect_failure = true
  attrs = {
    id                  = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-e/providers/Microsoft.Databricks/workspaces/ws-e"
    name                = "ws-e"
    location            = "eastus"
    resource_group_name = "rg-e"
    sku                 = "premium"
    custom_parameters = [{
      virtual_network_id  = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-e/providers/Microsoft.Network/virtualNetworks/vnet-e"
      public_subnet_name  = "public"
      private_subnet_name = "private"
      no_public_ip        = true
    }]
  }
}

resource "azurerm_private_endpoint" "pe_substring" {
  skip = true
  attrs = {
    name                = "pe-ws-e"
    location            = "eastus"
    resource_group_name = "rg-e"
    subnet_id           = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-e/providers/Microsoft.Network/virtualNetworks/vnet-e/subnets/subnet-e"
    private_service_connection = [{
      is_manual_connection           = false
      name                           = "psc-ws-e"
      private_connection_resource_id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-e/providers/Microsoft.Databricks/workspaces/ws-e-other"
      subresource_names              = ["databricks_ui_api"]
    }]
  }
}

resource "azurerm_databricks_workspace" "single_psc_matches" {
  attrs = {
    id                  = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-f/providers/Microsoft.Databricks/workspaces/ws-f"
    name                = "ws-f"
    location            = "eastus"
    resource_group_name = "rg-f"
    sku                 = "premium"
    custom_parameters = [{
      virtual_network_id  = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-f/providers/Microsoft.Network/virtualNetworks/vnet-f"
      public_subnet_name  = "public"
      private_subnet_name = "private"
      no_public_ip        = true
    }]
  }
}

resource "azurerm_private_endpoint" "pe_single_matches" {
  skip = true
  attrs = {
    name                = "pe-ws-f"
    location            = "eastus"
    resource_group_name = "rg-f"
    subnet_id           = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-f/providers/Microsoft.Network/virtualNetworks/vnet-f/subnets/subnet-f"
    private_service_connection = [{
      is_manual_connection           = false
      name                           = "psc-f"
      private_connection_resource_id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-f/providers/Microsoft.Databricks/workspaces/ws-f"
      subresource_names              = ["databricks_ui_api"]
    }]
  }
}

resource "azurerm_databricks_workspace" "endpoint_empty_psc" {
  expect_failure = true
  attrs = {
    id                  = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-g/providers/Microsoft.Databricks/workspaces/ws-g"
    name                = "ws-g"
    location            = "eastus"
    resource_group_name = "rg-g"
    sku                 = "premium"
    custom_parameters = [{
      virtual_network_id  = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-g/providers/Microsoft.Network/virtualNetworks/vnet-g"
      public_subnet_name  = "public"
      private_subnet_name = "private"
      no_public_ip        = true
    }]
  }
}

resource "azurerm_private_endpoint" "pe_empty_psc" {
  skip = true
  attrs = {
    name                       = "pe-ws-g"
    location                   = "eastus"
    resource_group_name        = "rg-g"
    subnet_id                  = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-g/providers/Microsoft.Network/virtualNetworks/vnet-g/subnets/subnet-g"
    private_service_connection = []
  }
}

resource "azurerm_databricks_workspace" "resource_id_present_null" {
  expect_failure = true
  attrs = {
    id                  = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-h/providers/Microsoft.Databricks/workspaces/ws-h"
    name                = "ws-h"
    location            = "eastus"
    resource_group_name = "rg-h"
    sku                 = "premium"
    custom_parameters = [{
      virtual_network_id  = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-h/providers/Microsoft.Network/virtualNetworks/vnet-h"
      public_subnet_name  = "public"
      private_subnet_name = "private"
      no_public_ip        = true
    }]
  }
}

resource "azurerm_private_endpoint" "pe_resource_id_null" {
  skip = true
  attrs = {
    name                = "pe-ws-h"
    location            = "eastus"
    resource_group_name = "rg-h"
    subnet_id           = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-h/providers/Microsoft.Network/virtualNetworks/vnet-h/subnets/subnet-h"
    private_service_connection = [{
      is_manual_connection           = false
      name                           = "psc-ws-h"
      private_connection_resource_id = null
      subresource_names              = ["databricks_ui_api"]
    }]
  }
}

resource "azurerm_databricks_workspace" "manual_flag_present_null" {
  attrs = {
    id                  = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-i/providers/Microsoft.Databricks/workspaces/ws-i"
    name                = "ws-i"
    location            = "eastus"
    resource_group_name = "rg-i"
    sku                 = "premium"
    custom_parameters = [{
      virtual_network_id  = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-i/providers/Microsoft.Network/virtualNetworks/vnet-i"
      public_subnet_name  = "public"
      private_subnet_name = "private"
      no_public_ip        = true
    }]
  }
}

resource "azurerm_private_endpoint" "pe_manual_null" {
  skip = true
  attrs = {
    name                = "pe-ws-i"
    location            = "eastus"
    resource_group_name = "rg-i"
    subnet_id           = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-i/providers/Microsoft.Network/virtualNetworks/vnet-i/subnets/subnet-i"
    private_service_connection = [{
      is_manual_connection           = null
      name                           = "psc-ws-i"
      private_connection_resource_id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-i/providers/Microsoft.Databricks/workspaces/ws-i"
      subresource_names              = ["databricks_ui_api"]
    }]
  }
}

  resource "azurerm_databricks_workspace" "case_insensitive_id_match" {
    attrs = {
      id                  = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-j/providers/Microsoft.Databricks/workspaces/ws-j"
      name                = "ws-j"
      location            = "eastus"
      resource_group_name = "rg-j"
      sku                 = "premium"
      custom_parameters = [{
        virtual_network_id  = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-j/providers/Microsoft.Network/virtualNetworks/vnet-j"
        public_subnet_name  = "public"
        private_subnet_name = "private"
        no_public_ip        = true
      }]
    }
  }

  resource "azurerm_private_endpoint" "pe_case_insensitive_id_match" {
    skip = true
    attrs = {
      name                = "pe-ws-j"
      location            = "eastus"
      resource_group_name = "rg-j"
      subnet_id           = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-j/providers/Microsoft.Network/virtualNetworks/vnet-j/subnets/private"
      private_service_connection = [{
        is_manual_connection           = false
        name                           = "psc-ws-j"
        private_connection_resource_id = "/SUBSCRIPTIONS/00000000-0000-0000-0000-000000000000/RESOURCEGROUPS/RG-J/PROVIDERS/MICROSOFT.DATABRICKS/WORKSPACES/WS-J"
        subresource_names              = ["DATABRICKS_UI_API"]
      }]
    }
  }

  resource "azurerm_databricks_workspace" "wrong_subresource" {
    expect_failure = true
    attrs = {
      id                  = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-k/providers/Microsoft.Databricks/workspaces/ws-k"
      name                = "ws-k"
      location            = "eastus"
      resource_group_name = "rg-k"
      sku                 = "premium"
      custom_parameters = [{
        virtual_network_id  = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-k/providers/Microsoft.Network/virtualNetworks/vnet-k"
        public_subnet_name  = "public"
        private_subnet_name = "private"
        no_public_ip        = true
      }]
    }
  }

  resource "azurerm_private_endpoint" "pe_wrong_subresource" {
    skip = true
    attrs = {
      name                = "pe-ws-k"
      location            = "eastus"
      resource_group_name = "rg-k"
      subnet_id           = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-k/providers/Microsoft.Network/virtualNetworks/vnet-k/subnets/private"
      private_service_connection = [{
        is_manual_connection           = false
        name                           = "psc-ws-k"
        private_connection_resource_id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-k/providers/Microsoft.Databricks/workspaces/ws-k"
        subresource_names              = ["some_other_group"]
      }]
    }
  }

  resource "azurerm_databricks_workspace" "standard_sku" {
    expect_failure = true
    attrs = {
      id                  = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-l/providers/Microsoft.Databricks/workspaces/ws-l"
      name                = "ws-l"
      location            = "eastus"
      resource_group_name = "rg-l"
      sku                 = "standard"
      custom_parameters = [{
        virtual_network_id  = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-l/providers/Microsoft.Network/virtualNetworks/vnet-l"
        public_subnet_name  = "public"
        private_subnet_name = "private"
        no_public_ip        = true
      }]
    }
  }

  resource "azurerm_private_endpoint" "pe_standard_sku" {
    skip = true
    attrs = {
      name                = "pe-ws-l"
      location            = "eastus"
      resource_group_name = "rg-l"
      subnet_id           = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-l/providers/Microsoft.Network/virtualNetworks/vnet-l/subnets/private"
      private_service_connection = [{
        is_manual_connection           = false
        name                           = "psc-ws-l"
        private_connection_resource_id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-l/providers/Microsoft.Databricks/workspaces/ws-l"
        subresource_names              = ["databricks_ui_api"]
      }]
    }
  }

  resource "azurerm_databricks_workspace" "no_public_ip_disabled" {
    expect_failure = true
    attrs = {
      id                  = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-m/providers/Microsoft.Databricks/workspaces/ws-m"
      name                = "ws-m"
      location            = "eastus"
      resource_group_name = "rg-m"
      sku                 = "premium"
      custom_parameters = [{
        virtual_network_id  = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-m/providers/Microsoft.Network/virtualNetworks/vnet-m"
        public_subnet_name  = "public"
        private_subnet_name = "private"
        no_public_ip        = false
      }]
    }
  }

  resource "azurerm_private_endpoint" "pe_no_public_ip_disabled" {
    skip = true
    attrs = {
      name                = "pe-ws-m"
      location            = "eastus"
      resource_group_name = "rg-m"
      subnet_id           = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-m/providers/Microsoft.Network/virtualNetworks/vnet-m/subnets/private"
      private_service_connection = [{
        is_manual_connection           = false
        name                           = "psc-ws-m"
        private_connection_resource_id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-m/providers/Microsoft.Databricks/workspaces/ws-m"
        subresource_names              = ["databricks_ui_api"]
      }]
    }
  }

  resource "azurerm_databricks_workspace" "vnet_injection_absent" {
    expect_failure = true
    attrs = {
      id                  = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-n/providers/Microsoft.Databricks/workspaces/ws-n"
      name                = "ws-n"
      location            = "eastus"
      resource_group_name = "rg-n"
      sku                 = "premium"
      custom_parameters = [{
        no_public_ip = true
      }]
    }
  }

  resource "azurerm_private_endpoint" "pe_vnet_injection_absent" {
    skip = true
    attrs = {
      name                = "pe-ws-n"
      location            = "eastus"
      resource_group_name = "rg-n"
      subnet_id           = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-n/providers/Microsoft.Network/virtualNetworks/vnet-n/subnets/private"
      private_service_connection = [{
        is_manual_connection           = false
        name                           = "psc-ws-n"
        private_connection_resource_id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-n/providers/Microsoft.Databricks/workspaces/ws-n"
        subresource_names              = ["databricks_ui_api"]
      }]
    }
}

resource "azurerm_databricks_workspace" "workspace_id_blank" {
    expect_failure = true
    attrs = {
      id                  = ""
      name                = "ws-blank-id"
      location            = "eastus"
      resource_group_name = "rg-o"
      sku                 = "premium"
      custom_parameters = [{
        virtual_network_id  = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-o/providers/Microsoft.Network/virtualNetworks/vnet-o"
        public_subnet_name  = "public"
        private_subnet_name = "private"
        no_public_ip        = true
      }]
    }
}

resource "azurerm_private_endpoint" "pe_blank_workspace_id" {
    skip = true
    attrs = {
      name                = "pe-ws-blank-id"
      location            = "eastus"
      resource_group_name = "rg-o"
      subnet_id           = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-o/providers/Microsoft.Network/virtualNetworks/vnet-o/subnets/private"
      private_service_connection = [{
        is_manual_connection           = false
        name                           = "psc-ws-blank-id"
        private_connection_resource_id = ""
        subresource_names              = ["databricks_ui_api"]
      }]
    }
}

resource "azurerm_databricks_workspace" "no_public_ip_omitted" {
    attrs = {
      id                  = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-p/providers/Microsoft.Databricks/workspaces/ws-p"
      name                = "ws-p"
      location            = "eastus"
      resource_group_name = "rg-p"
      sku                 = "premium"
      custom_parameters = [{
        virtual_network_id  = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-p/providers/Microsoft.Network/virtualNetworks/vnet-p"
        public_subnet_name  = "public"
        private_subnet_name = "private"
      }]
    }
}

resource "azurerm_private_endpoint" "pe_no_public_ip_omitted" {
    skip = true
    attrs = {
      name                = "pe-ws-p"
      location            = "eastus"
      resource_group_name = "rg-p"
      subnet_id           = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-p/providers/Microsoft.Network/virtualNetworks/vnet-p/subnets/private"
      private_service_connection = [{
        is_manual_connection           = false
        name                           = "psc-ws-p"
        private_connection_resource_id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-p/providers/Microsoft.Databricks/workspaces/ws-p"
        subresource_names              = ["databricks_ui_api"]
      }]
    }
}

resource "azurerm_databricks_workspace" "no_public_ip_null" {
    attrs = {
      id                  = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-q/providers/Microsoft.Databricks/workspaces/ws-q"
      name                = "ws-q"
      location            = "eastus"
      resource_group_name = "rg-q"
      sku                 = "premium"
      custom_parameters = [{
        virtual_network_id  = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-q/providers/Microsoft.Network/virtualNetworks/vnet-q"
        public_subnet_name  = "public"
        private_subnet_name = "private"
        no_public_ip        = null
      }]
    }
}

resource "azurerm_private_endpoint" "pe_no_public_ip_null" {
    skip = true
    attrs = {
      name                = "pe-ws-q"
      location            = "eastus"
      resource_group_name = "rg-q"
      subnet_id           = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-q/providers/Microsoft.Network/virtualNetworks/vnet-q/subnets/private"
      private_service_connection = [{
        is_manual_connection           = false
        name                           = "psc-ws-q"
        private_connection_resource_id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-q/providers/Microsoft.Databricks/workspaces/ws-q"
        subresource_names              = ["databricks_ui_api"]
      }]
    }
}
