policy {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = ">= 4.0.0, < 6.0.0"
    }
  }
}

locals {
  cis_7_11_associations = [
    for a in core::getresources("azurerm_subnet_network_security_group_association", {}) : {
      subnet_id = core::try(a.subnet_id == null ? "" : core::lower(core::trimsuffix(core::trimspace(a.subnet_id), "/")), null)
      nsg_id    = core::try(a.network_security_group_id == null ? "" : core::lower(core::trimsuffix(core::trimspace(a.network_security_group_id), "/")), null)
    }
  ]
}

resource_policy "azurerm_subnet" "7_11_standalone" {
  enforcement_level = "advisory"

  locals {
    id = core::try(core::lower(core::trimsuffix(core::trimspace(attrs.id), "/")), null)
    nsg_id = core::try(core::lower(core::trimsuffix(core::trimspace(attrs.network_security_group_id), "/")), null)
    nsg_valid = core::try(core::regex(
      "^/subscriptions/[^/]+/resourcegroups/[^/]+/providers/microsoft\\.network/networksecuritygroups/[^/]+$", local.nsg_id
    ), null) != null
    write_only_version = core::try(attrs.network_security_group_id_wo_version, null)
    candidate_associations = [
      for a in local.cis_7_11_associations : a
      if (a.subnet_id == null || core::try(core::regex("^/subscriptions/[^/]+/resourcegroups/[^/]+/providers/microsoft\\.network/virtualnetworks/[^/]+/subnets/[^/]+$", a.subnet_id), null) != null) &&
        (a.nsg_id == null || core::try(core::regex("^/subscriptions/[^/]+/resourcegroups/[^/]+/providers/microsoft\\.network/networksecuritygroups/[^/]+$", a.nsg_id), null) != null)
    ]
    matching_associations = [
      for a in local.candidate_associations : a
      if local.id != null && a.subnet_id != null && local.id == a.subnet_id
    ]
    unresolved_associations = [
      for a in local.candidate_associations : a
      if local.id == null || a.subnet_id == null
    ]
  }

  enforce {
    condition = (local.nsg_valid || core::length(local.matching_associations) > 0 ||
      core::length(local.unresolved_associations) > 0 ||
      (local.write_only_version == null ? false : local.write_only_version >= 1))
    error_message = "The subnet must have an NSG association, a resolved network_security_group_id, or a configured write-only NSG assignment. Unknown association IDs require resolved-value verification."
  }
}

resource_policy "azurerm_subnet_network_security_group_association" "7_11_association" {
  enforcement_level = "advisory"

  locals {
    subnet_id = core::try(attrs.subnet_id == null ? "" : core::lower(core::trimsuffix(core::trimspace(attrs.subnet_id), "/")), null)
    nsg_id = core::try(attrs.network_security_group_id == null ? "" : core::lower(core::trimsuffix(core::trimspace(attrs.network_security_group_id), "/")), null)
  }

  enforce {
    condition = local.subnet_id == null ? true : core::try(core::regex(
      "^/subscriptions/[^/]+/resourcegroups/[^/]+/providers/microsoft\\.network/virtualnetworks/[^/]+/subnets/[^/]+$", local.subnet_id
    ), null) != null
    error_message = "The subnet NSG association must reference a valid subnet ARM ID."
  }

  enforce {
    condition = local.nsg_id == null ? true : core::try(core::regex(
      "^/subscriptions/[^/]+/resourcegroups/[^/]+/providers/microsoft\\.network/networksecuritygroups/[^/]+$", local.nsg_id
    ), null) != null
    error_message = "The subnet NSG association must reference a valid Network Security Group ARM ID."
  }
}

resource_policy "azurerm_virtual_network" "7_11_inline" {
  enforcement_level = "advisory"

  locals {
    subnets = [
      for s in core::try([for x in attrs.subnet : x], []) : {
        name = core::try(s.name, "unknown")
        nsg_id = core::try(s.security_group == null ? "" : core::lower(core::trimsuffix(core::trimspace(s.security_group), "/")), null)
      } if s != null
    ]
    unprotected_subnets = [
      for s in local.subnets : s.name
      if s.nsg_id != null && core::try(core::regex(
        "^/subscriptions/[^/]+/resourcegroups/[^/]+/providers/microsoft\\.network/networksecuritygroups/[^/]+$", s.nsg_id
      ), null) == null
    ]
  }

  enforce {
    condition     = core::length(local.unprotected_subnets) == 0
    error_message = "Every inline virtual-network subnet must reference a Network Security Group through security_group."
  }
}
