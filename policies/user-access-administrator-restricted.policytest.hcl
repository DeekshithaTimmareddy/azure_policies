# Copyright IBM Corp. 2026

policytest {
  targets = ["user-access-administrator-restricted.policy.hcl"]
}

resource "azurerm_role_assignment" "pass_owner_by_name" {
  attrs = {
  scope = "/subscriptions/00000000-0000-0000-0000-000000000000"
  principal_id = "11111111-1111-1111-1111-111111111111"
  role_definition_name = "Owner"
  role_definition_id = null
  }
}

resource "azurerm_role_assignment" "pass_reader_by_id" {
  attrs = {
  scope = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-app"
  principal_id = "11111111-1111-1111-1111-111111111111"
  role_definition_name = null
  role_definition_id = "/subscriptions/00000000-0000-0000-0000-000000000000/providers/Microsoft.Authorization/roleDefinitions/acdd72a7-3385-48ef-bd42-f606fbaa4c9b"
  }
}

resource "azurerm_role_assignment" "pass_contributor_real_plan_shape" {
  attrs = {
  scope = "/subscriptions/00000000-0000-0000-0000-000000000000"
  principal_id = "11111111-1111-1111-1111-111111111111"
  role_definition_name = null
  role_definition_id = "/subscriptions/00000000-0000-0000-0000-000000000000/providers/Microsoft.Authorization/roleDefinitions/b24988ac-6180-4a58-b0c3-4b3a8f6f5d6b"
  }
}

resource "azurerm_role_assignment" "pass_similar_name" {
  attrs = {
  scope = "/subscriptions/00000000-0000-0000-0000-000000000000"
  principal_id = "11111111-1111-1111-1111-111111111111"
  role_definition_name = "User Access Administrator Custom"
  role_definition_id = null
  }
}

resource "azurerm_role_assignment" "pass_nulls" {
  attrs = {
  scope = "/subscriptions/00000000-0000-0000-0000-000000000000"
  principal_id = "11111111-1111-1111-1111-111111111111"
  role_definition_name = null
  role_definition_id = null
  }
}

resource "azurerm_role_assignment" "fail_uaa_name_root" {
  attrs = {
  scope = "/"
  principal_id = "11111111-1111-1111-1111-111111111111"
  role_definition_name = "User Access Administrator"
  role_definition_id = null
  }
  expect_failure = true
}

resource "azurerm_role_assignment" "fail_uaa_name_subscription" {
  attrs = {
  scope = "/subscriptions/00000000-0000-0000-0000-000000000000"
  principal_id = "11111111-1111-1111-1111-111111111111"
  role_definition_name = "User Access Administrator"
  role_definition_id = null
  }
  expect_failure = true
}

resource "azurerm_role_assignment" "fail_uaa_name_mixed_case_spaces" {
  attrs = {
  scope = "/subscriptions/00000000-0000-0000-0000-000000000000"
  principal_id = "11111111-1111-1111-1111-111111111111"
  role_definition_name = "  user access ADMINISTRATOR "
  role_definition_id = null
  }
  expect_failure = true
}

resource "azurerm_role_assignment" "fail_uaa_id_subscription_scoped" {
  attrs = {
  scope = "/subscriptions/00000000-0000-0000-0000-000000000000"
  principal_id = "11111111-1111-1111-1111-111111111111"
  role_definition_name = null
  role_definition_id = "/subscriptions/00000000-0000-0000-0000-000000000000/providers/Microsoft.Authorization/roleDefinitions/18d7d88d-d35e-4fb5-a5c3-7773c20a72d9"
  }
  expect_failure = true
}

resource "azurerm_role_assignment" "fail_uaa_id_tenant_scoped_root" {
  attrs = {
  scope = "/"
  principal_id = "11111111-1111-1111-1111-111111111111"
  role_definition_name = null
  role_definition_id = "/providers/Microsoft.Authorization/roleDefinitions/18d7d88d-d35e-4fb5-a5c3-7773c20a72d9"
  }
  expect_failure = true
}

resource "azurerm_role_assignment" "fail_uaa_id_management_group" {
  attrs = {
  scope = "/providers/Microsoft.Management/managementGroups/mg-root"
  principal_id = "11111111-1111-1111-1111-111111111111"
  role_definition_name = null
  role_definition_id = "/providers/Microsoft.Authorization/roleDefinitions/18d7d88d-d35e-4fb5-a5c3-7773c20a72d9"
  }
  expect_failure = true
}

resource "azurerm_role_assignment" "fail_uaa_id_resource_group" {
  attrs = {
  scope = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-app"
  principal_id = "11111111-1111-1111-1111-111111111111"
  role_definition_name = null
  role_definition_id = "/subscriptions/00000000-0000-0000-0000-000000000000/providers/Microsoft.Authorization/roleDefinitions/18d7d88d-d35e-4fb5-a5c3-7773c20a72d9"
  }
  expect_failure = true
}

resource "azurerm_role_assignment" "fail_uaa_id_uppercase" {
  attrs = {
  scope = "/subscriptions/00000000-0000-0000-0000-000000000000"
  principal_id = "11111111-1111-1111-1111-111111111111"
  role_definition_name = null
  role_definition_id = "/SUBSCRIPTIONS/00000000-0000-0000-0000-000000000000/PROVIDERS/MICROSOFT.AUTHORIZATION/ROLEDEFINITIONS/18D7D88D-D35E-4FB5-A5C3-7773C20A72D9"
  }
  expect_failure = true
}

resource "azurerm_role_assignment" "fail_uaa_id_trailing_slash" {
  attrs = {
  scope = "/subscriptions/00000000-0000-0000-0000-000000000000"
  principal_id = "11111111-1111-1111-1111-111111111111"
  role_definition_name = null
  role_definition_id = "/subscriptions/00000000-0000-0000-0000-000000000000/providers/Microsoft.Authorization/roleDefinitions/18d7d88d-d35e-4fb5-a5c3-7773c20a72d9/"
  }
  expect_failure = true
}

resource "azurerm_role_assignment" "fail_uaa_name_and_id" {
  attrs = {
  scope = "/subscriptions/00000000-0000-0000-0000-000000000000"
  principal_id = "11111111-1111-1111-1111-111111111111"
  role_definition_name = "User Access Administrator"
  role_definition_id = "/subscriptions/00000000-0000-0000-0000-000000000000/providers/Microsoft.Authorization/roleDefinitions/18d7d88d-d35e-4fb5-a5c3-7773c20a72d9"
  }
  expect_failure = true
}

resource "azurerm_pim_active_role_assignment" "pass_owner" {
  attrs = {
  scope = "/subscriptions/00000000-0000-0000-0000-000000000000"
  principal_id = "11111111-1111-1111-1111-111111111111"
  role_definition_id = "/subscriptions/00000000-0000-0000-0000-000000000000/providers/Microsoft.Authorization/roleDefinitions/8e3af657-a8ff-443c-a75c-2fe8c4bcb635"
  }
}

resource "azurerm_pim_active_role_assignment" "pass_null_role" {
  attrs = {
  scope = "/subscriptions/00000000-0000-0000-0000-000000000000"
  principal_id = "11111111-1111-1111-1111-111111111111"
  role_definition_id = null
  }
}

resource "azurerm_pim_active_role_assignment" "fail_uaa_root" {
  attrs = {
  scope = "/"
  principal_id = "11111111-1111-1111-1111-111111111111"
  role_definition_id = "/providers/Microsoft.Authorization/roleDefinitions/18d7d88d-d35e-4fb5-a5c3-7773c20a72d9"
  }
  expect_failure = true
}

resource "azurerm_pim_active_role_assignment" "fail_uaa_management_group" {
  attrs = {
  scope = "/providers/Microsoft.Management/managementGroups/mg-root"
  principal_id = "11111111-1111-1111-1111-111111111111"
  role_definition_id = "/providers/Microsoft.Authorization/roleDefinitions/18d7d88d-d35e-4fb5-a5c3-7773c20a72d9"
  }
  expect_failure = true
}

resource "azurerm_pim_active_role_assignment" "fail_uaa_subscription" {
  attrs = {
  scope = "/subscriptions/00000000-0000-0000-0000-000000000000"
  principal_id = "11111111-1111-1111-1111-111111111111"
  role_definition_id = "/subscriptions/00000000-0000-0000-0000-000000000000/providers/Microsoft.Authorization/roleDefinitions/18d7d88d-d35e-4fb5-a5c3-7773c20a72d9"
  }
  expect_failure = true
}

resource "azurerm_pim_active_role_assignment" "fail_uaa_resource_group_uppercase" {
  attrs = {
  scope = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-app"
  principal_id = "11111111-1111-1111-1111-111111111111"
  role_definition_id = "/SUBSCRIPTIONS/00000000-0000-0000-0000-000000000000/PROVIDERS/MICROSOFT.AUTHORIZATION/ROLEDEFINITIONS/18D7D88D-D35E-4FB5-A5C3-7773C20A72D9"
  }
  expect_failure = true
}

resource "azurerm_pim_eligible_role_assignment" "pass_owner" {
  attrs = {
  scope = "/subscriptions/00000000-0000-0000-0000-000000000000"
  principal_id = "11111111-1111-1111-1111-111111111111"
  role_definition_id = "/subscriptions/00000000-0000-0000-0000-000000000000/providers/Microsoft.Authorization/roleDefinitions/8e3af657-a8ff-443c-a75c-2fe8c4bcb635"
  }
}

resource "azurerm_pim_eligible_role_assignment" "pass_null_role" {
  attrs = {
  scope = "/subscriptions/00000000-0000-0000-0000-000000000000"
  principal_id = "11111111-1111-1111-1111-111111111111"
  role_definition_id = null
  }
}

resource "azurerm_pim_eligible_role_assignment" "fail_uaa_root" {
  attrs = {
  scope = "/"
  principal_id = "11111111-1111-1111-1111-111111111111"
  role_definition_id = "/providers/Microsoft.Authorization/roleDefinitions/18d7d88d-d35e-4fb5-a5c3-7773c20a72d9"
  }
  expect_failure = true
}

resource "azurerm_pim_eligible_role_assignment" "fail_uaa_management_group" {
  attrs = {
  scope = "/providers/Microsoft.Management/managementGroups/mg-root"
  principal_id = "11111111-1111-1111-1111-111111111111"
  role_definition_id = "/providers/Microsoft.Authorization/roleDefinitions/18d7d88d-d35e-4fb5-a5c3-7773c20a72d9"
  }
  expect_failure = true
}

resource "azurerm_pim_eligible_role_assignment" "fail_uaa_subscription" {
  attrs = {
  scope = "/subscriptions/00000000-0000-0000-0000-000000000000"
  principal_id = "11111111-1111-1111-1111-111111111111"
  role_definition_id = "/subscriptions/00000000-0000-0000-0000-000000000000/providers/Microsoft.Authorization/roleDefinitions/18d7d88d-d35e-4fb5-a5c3-7773c20a72d9"
  }
  expect_failure = true
}

resource "azurerm_pim_eligible_role_assignment" "fail_uaa_resource_group_uppercase" {
  attrs = {
  scope = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-app"
  principal_id = "11111111-1111-1111-1111-111111111111"
  role_definition_id = "/SUBSCRIPTIONS/00000000-0000-0000-0000-000000000000/PROVIDERS/MICROSOFT.AUTHORIZATION/ROLEDEFINITIONS/18D7D88D-D35E-4FB5-A5C3-7773C20A72D9"
  }
  expect_failure = true
}
