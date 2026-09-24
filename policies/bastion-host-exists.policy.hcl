locals {
  all_bastion_hosts = core::getresources("azurerm_bastion_host", {})
  bastion_count     = core::length(local.all_bastion_hosts)
}

resource_policy "azurerm_bastion_host" "ensure_bastion_host_exists" {
  enforcement_level = "advisory"

  enforce {
    condition     = local.bastion_count > 0
    error_message = "An Azure Bastion Host must exist: at least one azurerm_bastion_host is required for secure VM remote access."
  }
}
