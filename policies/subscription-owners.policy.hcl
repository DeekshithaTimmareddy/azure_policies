# Copyright IBM Corp. 2026

# Ensure there are between 2 and 3 Subscription Owners

policy {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = ">= 4.0.0, < 6.0.0"
    }
  }
}

# LIMITATION: The count includes only azurerm_role_assignment resources visible to
# the current tfpolicy evaluation. It cannot discover role assignments managed
# outside Terraform or subscriptions represented by no role assignment resource.
resource_policy "azurerm_role_assignment" "subscription_owner_count" {
  locals {
    scope_raw          = core::try(attrs.scope, null)
    scope              = local.scope_raw != null ? local.scope_raw : ""
    role_name_raw      = core::try(attrs.role_definition_name, null)
    role_name          = local.role_name_raw != null ? local.role_name_raw : ""
    role_id_raw        = core::try(attrs.role_definition_id, null)
    role_id            = local.role_id_raw != null ? local.role_id_raw : ""
    is_owner           = local.role_name == "Owner" || core::endswith(local.role_id, "8e3af657-a8ff-443c-a75c-2fe8c4bcb635")
    is_subscription    = core::try(core::regex("^/subscriptions/[^/]+$", local.scope), null) != null
    assignments        = core::getresources("azurerm_role_assignment", { scope = local.scope })
    owner_assignments  = [for assignment in local.assignments : assignment if (core::try(assignment.role_definition_name, null) != null ? assignment.role_definition_name == "Owner" : false) || (core::try(assignment.role_definition_id, null) != null ? core::endswith(assignment.role_definition_id, "8e3af657-a8ff-443c-a75c-2fe8c4bcb635") : false)]
    owner_count        = core::length(local.owner_assignments)
    compliant          = local.owner_count >= 2 && local.owner_count <= 3
  }

  filter = local.is_subscription && local.is_owner

  enforcement_level = "advisory"
  enforce {
    condition     = local.compliant
    error_message = "A subscription must have between 2 and 3 Owner role assignments. Add or remove subscription-scoped Owner assignments to meet this range."
  }
}
