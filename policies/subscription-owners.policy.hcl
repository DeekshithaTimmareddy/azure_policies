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

input "subscription-owners-enforcement-level" {
  type    = string
  default = "advisory"
}

resource_policy "azurerm_role_assignment" "subscription_owner_count" {
  locals {
    scope_raw          = core::try(attrs.scope, null)
    scope              = local.scope_raw != null ? local.scope_raw : ""
    role_name_raw      = core::try(attrs.role_definition_name, null)
    role_name          = local.role_name_raw != null ? local.role_name_raw : ""
    role_id_raw        = core::try(attrs.role_definition_id, null)
    role_id            = local.role_id_raw != null ? local.role_id_raw : ""
    is_owner           = local.role_name == "Owner" || core::endswith(core::lower(local.role_id), "8e3af657-a8ff-443c-a75c-2fe8c4bcb635")
    is_subscription    = core::try(core::regex("^/subscriptions/[^/]+$", local.scope), null) != null
    assignments        = core::getresources("azurerm_role_assignment", { scope = local.scope })
    owner_assignments  = [for assignment in local.assignments : assignment if (core::try(assignment.role_definition_name, null) != null ? assignment.role_definition_name == "Owner" : false) || (core::try(assignment.role_definition_id, null) != null ? core::endswith(core::lower(assignment.role_definition_id), "8e3af657-a8ff-443c-a75c-2fe8c4bcb635") : false)]
    owner_count        = core::length(local.owner_assignments)
    compliant          = local.owner_count <= 3
  }

  filter = local.is_subscription && local.is_owner

  enforcement_level = input.subscription-owners-enforcement-level
  enforce {
    condition     = local.compliant
    error_message = "A subscription must not have more than 3 Owner role assignments visible in this Terraform plan."
  }
  # NOTE: minimum Owner count (>= 2) cannot be enforced reliably from Terraform
  # plan data -- a plan with zero Owner assignments proves nothing about the
  # subscription's actual Owners, since assignments made outside this
  # configuration (portal, CLI, other Terraform runs) are invisible here.
}
