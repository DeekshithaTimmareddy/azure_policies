policytest {
  targets = ["bastion-host-exists.policy.hcl"]
}

resource "azurerm_bastion_host" "present_standard" {
  attrs = {
    name                = "prod-bastion"
    location            = "eastus"
    resource_group_name = "prod-network-rg"
    ip_configuration = [{
      name                 = "ipcfg"
      subnet_id            = "/subscriptions/11111111-1111-1111-1111-111111111111/resourceGroups/prod-network-rg/providers/Microsoft.Network/virtualNetworks/prod-vnet/subnets/AzureBastionSubnet"
      public_ip_address_id = "/subscriptions/11111111-1111-1111-1111-111111111111/resourceGroups/prod-network-rg/providers/Microsoft.Network/publicIPAddresses/prod-bastion-pip"
    }]
  }
}

resource "azurerm_bastion_host" "present_second" {
  attrs = {
    name                = "hub-bastion"
    location            = "westus2"
    resource_group_name = "hub-network-rg"
    ip_configuration = [{
      name                 = "ipcfg"
      subnet_id            = "/subscriptions/22222222-2222-2222-2222-222222222222/resourceGroups/hub-network-rg/providers/Microsoft.Network/virtualNetworks/hub-vnet/subnets/AzureBastionSubnet"
      public_ip_address_id = "/subscriptions/22222222-2222-2222-2222-222222222222/resourceGroups/hub-network-rg/providers/Microsoft.Network/publicIPAddresses/hub-bastion-pip"
    }]
  }
}

resource "azurerm_bastion_host" "present_no_public_ip" {
  attrs = {
    name                = "minimal-bastion"
    location            = "centralus"
    resource_group_name = "minimal-rg"
    ip_configuration = [{
      name      = "ipcfg"
      subnet_id = "/subscriptions/33333333-3333-3333-3333-333333333333/resourceGroups/minimal-rg/providers/Microsoft.Network/virtualNetworks/minimal-vnet/subnets/AzureBastionSubnet"
    }]
  }
}
