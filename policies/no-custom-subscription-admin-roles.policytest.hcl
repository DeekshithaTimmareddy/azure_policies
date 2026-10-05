# Copyright IBM Corp. 2026

policytest {
  targets = ["no-custom-subscription-admin-roles.policy.hcl"]
}

resource "azurerm_role_definition" "pass_scoped_actions_at_subscription" {
  attrs = {
  name              = "pass-scoped-actions-at-subscription"
  scope             = "/subscriptions/00000000-0000-0000-0000-000000000000"
  assignable_scopes = ["/subscriptions/00000000-0000-0000-0000-000000000000"]
  permissions       = [
    {
    actions          = ["Microsoft.Compute/virtualMachines/read", "Microsoft.Compute/virtualMachines/start/action"]
    data_actions     = null
    not_actions      = null
    not_data_actions = null
    }
  ]
  }
}

resource "azurerm_role_definition" "pass_provider_wildcard_at_subscription" {
  attrs = {
  name              = "pass-provider-wildcard-at-subscription"
  scope             = "/subscriptions/00000000-0000-0000-0000-000000000000"
  assignable_scopes = ["/subscriptions/00000000-0000-0000-0000-000000000000"]
  permissions       = [
    {
    actions          = ["Microsoft.Storage/*"]
    data_actions     = null
    not_actions      = null
    not_data_actions = null
    }
  ]
  }
}

resource "azurerm_role_definition" "pass_wildcard_only_in_data_actions" {
  attrs = {
  name              = "pass-wildcard-only-in-data-actions"
  scope             = "/subscriptions/00000000-0000-0000-0000-000000000000"
  assignable_scopes = ["/subscriptions/00000000-0000-0000-0000-000000000000"]
  permissions       = [
    {
    actions          = ["Microsoft.Storage/storageAccounts/read"]
    data_actions     = ["*"]
    not_actions      = null
    not_data_actions = null
    }
  ]
  }
}

resource "azurerm_role_definition" "pass_wildcard_at_resource_group" {
  attrs = {
  name              = "pass-wildcard-at-resource-group"
  scope             = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-app"
  assignable_scopes = ["/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-app"]
  permissions       = [
    {
    actions          = ["*"]
    data_actions     = null
    not_actions      = null
    not_data_actions = null
    }
  ]
  }
}

resource "azurerm_role_definition" "pass_wildcard_scope_resource_group_assignable_omitted" {
  attrs = {
  name              = "pass-wildcard-scope-resource-group-assignable-omitted"
  scope             = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-app"
  assignable_scopes = null
  permissions       = [
    {
    actions          = ["*"]
    data_actions     = null
    not_actions      = null
    not_data_actions = null
    }
  ]
  }
}

resource "azurerm_role_definition" "pass_no_permissions_blocks" {
  attrs = {
  name              = "pass-no-permissions-blocks"
  scope             = "/subscriptions/00000000-0000-0000-0000-000000000000"
  assignable_scopes = ["/subscriptions/00000000-0000-0000-0000-000000000000"]
  permissions       = []
  }
}

resource "azurerm_role_definition" "pass_null_actions" {
  attrs = {
  name              = "pass-null-actions"
  scope             = "/subscriptions/00000000-0000-0000-0000-000000000000"
  assignable_scopes = ["/subscriptions/00000000-0000-0000-0000-000000000000"]
  permissions       = [
    {
    actions          = null
    data_actions     = null
    not_actions      = null
    not_data_actions = null
    }
  ]
  }
}

resource "azurerm_role_definition" "pass_resource_scope" {
  attrs = {
  name              = "pass-resource-scope"
  scope             = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-app/providers/Microsoft.Storage/storageAccounts/sa1"
  assignable_scopes = null
  permissions       = [
    {
    actions          = ["*"]
    data_actions     = null
    not_actions      = null
    not_data_actions = null
    }
  ]
  }
}

resource "azurerm_role_definition" "fail_wildcard_at_subscription" {
  attrs = {
  name              = "fail-wildcard-at-subscription"
  scope             = "/subscriptions/00000000-0000-0000-0000-000000000000"
  assignable_scopes = ["/subscriptions/00000000-0000-0000-0000-000000000000"]
  permissions       = [
    {
    actions          = ["*"]
    data_actions     = null
    not_actions      = null
    not_data_actions = null
    }
  ]
  }
  expect_failure = true
}

resource "azurerm_role_definition" "fail_wildcard_assignable_omitted_real_plan_shape" {
  attrs = {
  name              = "fail-wildcard-assignable-omitted-real-plan-shape"
  scope             = "/subscriptions/00000000-0000-0000-0000-000000000000"
  assignable_scopes = null
  permissions       = [
    {
    actions          = ["*"]
    data_actions     = null
    not_actions      = null
    not_data_actions = null
    }
  ]
  }
  expect_failure = true
}

resource "azurerm_role_definition" "fail_wildcard_assignable_empty" {
  attrs = {
  name              = "fail-wildcard-assignable-empty"
  scope             = "/subscriptions/00000000-0000-0000-0000-000000000000"
  assignable_scopes = []
  permissions       = [
    {
    actions          = ["*"]
    data_actions     = null
    not_actions      = null
    not_data_actions = null
    }
  ]
  }
  expect_failure = true
}

resource "azurerm_role_definition" "fail_wildcard_with_not_actions" {
  attrs = {
  name              = "fail-wildcard-with-not-actions"
  scope             = "/subscriptions/00000000-0000-0000-0000-000000000000"
  assignable_scopes = ["/subscriptions/00000000-0000-0000-0000-000000000000"]
  permissions       = [
    {
    actions          = ["*"]
    data_actions     = null
    not_actions      = ["Microsoft.Authorization/*/Delete"]
    not_data_actions = null
    }
  ]
  }
  expect_failure = true
}

resource "azurerm_role_definition" "fail_wildcard_in_second_permissions_block" {
  attrs = {
  name              = "fail-wildcard-in-second-permissions-block"
  scope             = "/subscriptions/00000000-0000-0000-0000-000000000000"
  assignable_scopes = ["/subscriptions/00000000-0000-0000-0000-000000000000"]
  permissions       = [
    {
    actions          = ["Microsoft.Compute/*/read"]
    data_actions     = null
    not_actions      = null
    not_data_actions = null
    },
    {
    actions          = ["*"]
    data_actions     = null
    not_actions      = null
    not_data_actions = null
    }
  ]
  }
  expect_failure = true
}

resource "azurerm_role_definition" "fail_wildcard_among_other_actions" {
  attrs = {
  name              = "fail-wildcard-among-other-actions"
  scope             = "/subscriptions/00000000-0000-0000-0000-000000000000"
  assignable_scopes = ["/subscriptions/00000000-0000-0000-0000-000000000000"]
  permissions       = [
    {
    actions          = ["Microsoft.Compute/*/read", "*"]
    data_actions     = null
    not_actions      = null
    not_data_actions = null
    }
  ]
  }
  expect_failure = true
}

resource "azurerm_role_definition" "fail_subscription_among_several_scopes" {
  attrs = {
  name              = "fail-subscription-among-several-scopes"
  scope             = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-app"
  assignable_scopes = ["/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-app", "/subscriptions/00000000-0000-0000-0000-000000000000"]
  permissions       = [
    {
    actions          = ["*"]
    data_actions     = null
    not_actions      = null
    not_data_actions = null
    }
  ]
  }
  expect_failure = true
}

resource "azurerm_role_definition" "fail_subscription_mixed_case_trailing_slash" {
  attrs = {
  name              = "fail-subscription-mixed-case-trailing-slash"
  scope             = "/subscriptions/00000000-0000-0000-0000-000000000000"
  assignable_scopes = ["/Subscriptions/00000000-0000-0000-0000-000000000000/"]
  permissions       = [
    {
    actions          = ["*"]
    data_actions     = null
    not_actions      = null
    not_data_actions = null
    }
  ]
  }
  expect_failure = true
}

resource "azurerm_role_definition" "fail_wildcard_at_management_group" {
  attrs = {
  name              = "fail-wildcard-at-management-group"
  scope             = "/providers/Microsoft.Management/managementGroups/mg-root"
  assignable_scopes = ["/providers/Microsoft.Management/managementGroups/mg-root"]
  permissions       = [
    {
    actions          = ["*"]
    data_actions     = null
    not_actions      = null
    not_data_actions = null
    }
  ]
  }
  expect_failure = true
}

resource "azurerm_role_definition" "fail_wildcard_at_management_group_lower_case" {
  attrs = {
  name              = "fail-wildcard-at-management-group-lower-case"
  scope             = "/providers/microsoft.management/managementgroups/mg-root"
  assignable_scopes = ["/providers/microsoft.management/managementgroups/mg-root"]
  permissions       = [
    {
    actions          = ["*"]
    data_actions     = null
    not_actions      = null
    not_data_actions = null
    }
  ]
  }
  expect_failure = true
}

resource "azurerm_role_definition" "fail_wildcard_at_root" {
  attrs = {
  name              = "fail-wildcard-at-root"
  scope             = "/"
  assignable_scopes = ["/"]
  permissions       = [
    {
    actions          = ["*"]
    data_actions     = null
    not_actions      = null
    not_data_actions = null
    }
  ]
  }
  expect_failure = true
}

resource "azurerm_role_definition" "fail_wildcard_root_scope_assignable_omitted" {
  attrs = {
  name              = "fail-wildcard-root-scope-assignable-omitted"
  scope             = "/"
  assignable_scopes = null
  permissions       = [
    {
    actions          = ["*"]
    data_actions     = null
    not_actions      = null
    not_data_actions = null
    }
  ]
  }
  expect_failure = true
}

resource "azurerm_role_definition" "pass_unknown_scope_at_plan_time" {
  attrs = {
  name              = "pass-unknown-scope-at-plan-time"
  scope             = null
  assignable_scopes = null
  permissions       = [
    {
    actions          = ["*"]
    data_actions     = null
    not_actions      = null
    not_data_actions = null
    }
  ]
  }
}

resource "azurerm_role_definition" "fail_wildcard_action_with_whitespace" {
  attrs = {
  name              = "fail-wildcard-action-with-whitespace"
  scope             = "/subscriptions/00000000-0000-0000-0000-000000000000"
  assignable_scopes = ["/subscriptions/00000000-0000-0000-0000-000000000000"]
  permissions       = [
    {
    actions          = [" * "]
    data_actions     = null
    not_actions      = null
    not_data_actions = null
    }
  ]
  }
  expect_failure = true
}

resource "azurerm_role_definition" "fail_unknown_scope_alongside_subscription" {
  attrs = {
  name              = "fail-unknown-scope-alongside-subscription"
  scope             = "/subscriptions/00000000-0000-0000-0000-000000000000"
  assignable_scopes = [null, "/subscriptions/00000000-0000-0000-0000-000000000000"]
  permissions       = [
    {
    actions          = ["*"]
    data_actions     = null
    not_actions      = null
    not_data_actions = null
    }
  ]
  }
  expect_failure = true
}
