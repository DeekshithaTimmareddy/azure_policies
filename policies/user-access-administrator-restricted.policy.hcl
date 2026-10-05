# Copyright IBM Corp. 2026

# Ensure That Use of the 'User Access Administrator' Role is Restricted

policy {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = ">= 4.0.0, < 6.0.0"
    }
  }
}

input "user-access-administrator-restricted-enforcement-level" {
  type    = string
  default = "advisory"
}

resource_policy "azurerm_role_assignment" "user_access_administrator_restricted" {
  enforcement_level = input.user-access-administrator-restricted-enforcement-level

  locals {
    role_name = core::try(core::lower(core::trimspace(attrs.role_definition_name)), "")
    role_id   = core::try(core::lower(core::trim(attrs.role_definition_id, "/ ")), "")
    # An explicit ID is authoritative; the provider may leave the unused name unknown.
    is_uaa = local.role_id != "" ? core::endswith(local.role_id, "18d7d88d-d35e-4fb5-a5c3-7773c20a72d9") : local.role_name == "user access administrator"
  }

  enforce {
    condition     = !local.is_uaa
    error_message = "The 'User Access Administrator' role must not be assigned through a role assignment at any scope."
  }
}

resource_policy "azurerm_pim_active_role_assignment" "user_access_administrator_restricted" {
  enforcement_level = input.user-access-administrator-restricted-enforcement-level

  locals {
    role_id   = core::try(core::lower(core::trim(attrs.role_definition_id, "/ ")), "")
    is_uaa    = core::endswith(local.role_id, "18d7d88d-d35e-4fb5-a5c3-7773c20a72d9")
  }

  enforce {
    condition     = !local.is_uaa
    error_message = "The 'User Access Administrator' role must not be assigned through a PIM active role assignment at any scope."
  }
}

resource_policy "azurerm_pim_eligible_role_assignment" "user_access_administrator_restricted" {
  enforcement_level = input.user-access-administrator-restricted-enforcement-level

  locals {
    role_id   = core::try(core::lower(core::trim(attrs.role_definition_id, "/ ")), "")
    is_uaa    = core::endswith(local.role_id, "18d7d88d-d35e-4fb5-a5c3-7773c20a72d9")
  }

  enforce {
    condition     = !local.is_uaa
    error_message = "The 'User Access Administrator' role must not be assigned through a PIM eligible role assignment at any scope."
  }
}
