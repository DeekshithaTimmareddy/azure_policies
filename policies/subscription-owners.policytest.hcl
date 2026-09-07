# Copyright IBM Corp. 2026

policytest {
  targets = ["subscription-owners.policy.hcl"]
}

# PASS: exactly two Owners is the inclusive minimum.
resource "azurerm_role_assignment" "pass_minimum_two_owners" {
  attrs = {
    scope                = "/subscriptions/00000000-0000-0000-0000-000000000002"
    role_definition_name = "Owner"
    principal_id         = "20000000-0000-0000-0000-000000000001"
    principal_type       = "User"
  }
}

resource "azurerm_role_assignment" "pass_minimum_two_owners_helper" {
  skip = true
  attrs = {
    scope                = "/subscriptions/00000000-0000-0000-0000-000000000002"
    role_definition_name = "Owner"
    principal_id         = "20000000-0000-0000-0000-000000000002"
    principal_type       = "Group"
  }
}

# PASS: exactly three Owners is the inclusive maximum. A null role name is
# normalized safely when the built-in Owner role definition ID is present.
resource "azurerm_role_assignment" "pass_maximum_three_owners" {
  attrs = {
    scope                = "/subscriptions/00000000-0000-0000-0000-000000000003"
    role_definition_name = null
    role_definition_id   = "/subscriptions/00000000-0000-0000-0000-000000000003/providers/Microsoft.Authorization/roleDefinitions/8e3af657-a8ff-443c-a75c-2fe8c4bcb635"
    principal_id         = "30000000-0000-0000-0000-000000000001"
    principal_type       = "User"
  }
}

resource "azurerm_role_assignment" "pass_maximum_three_owners_helper_one" {
  skip = true
  attrs = {
    scope                = "/subscriptions/00000000-0000-0000-0000-000000000003"
    role_definition_name = "Owner"
    principal_id         = "30000000-0000-0000-0000-000000000002"
    principal_type       = "Group"
  }
}

resource "azurerm_role_assignment" "pass_maximum_three_owners_helper_two" {
  skip = true
  attrs = {
    scope                = "/subscriptions/00000000-0000-0000-0000-000000000003"
    role_definition_id   = "/providers/Microsoft.Authorization/roleDefinitions/8e3af657-a8ff-443c-a75c-2fe8c4bcb635"
    principal_id         = "30000000-0000-0000-0000-000000000003"
    principal_type       = "ServicePrincipal"
  }
}

# FAIL: role_definition_name is omitted, exercising missing-attribute handling;
# the Owner role ID still identifies the assignment, but its count is only one.
resource "azurerm_role_assignment" "fail_below_minimum" {
  expect_failure = true
  attrs = {
    scope              = "/subscriptions/00000000-0000-0000-0000-000000000001"
    role_definition_id = "/providers/Microsoft.Authorization/roleDefinitions/8e3af657-a8ff-443c-a75c-2fe8c4bcb635"
    principal_id       = "10000000-0000-0000-0000-000000000001"
    principal_type     = "User"
  }
}

# FAIL: four Owners exceeds the allowed maximum.
resource "azurerm_role_assignment" "fail_above_maximum" {
  expect_failure = true
  attrs = {
    scope                = "/subscriptions/00000000-0000-0000-0000-000000000004"
    role_definition_name = "Owner"
    principal_id         = "40000000-0000-0000-0000-000000000001"
    principal_type       = "User"
  }
}

resource "azurerm_role_assignment" "fail_above_maximum_helper_one" {
  skip = true
  attrs = {
    scope                = "/subscriptions/00000000-0000-0000-0000-000000000004"
    role_definition_name = "Owner"
    principal_id         = "40000000-0000-0000-0000-000000000002"
    principal_type       = "User"
  }
}

resource "azurerm_role_assignment" "fail_above_maximum_helper_two" {
  skip = true
  attrs = {
    scope                = "/subscriptions/00000000-0000-0000-0000-000000000004"
    role_definition_name = "Owner"
    principal_id         = "40000000-0000-0000-0000-000000000003"
    principal_type       = "Group"
  }
}

resource "azurerm_role_assignment" "fail_above_maximum_helper_three" {
  skip = true
  attrs = {
    scope                = "/subscriptions/00000000-0000-0000-0000-000000000004"
    role_definition_name = "Owner"
    principal_id         = "40000000-0000-0000-0000-000000000004"
    principal_type       = "ServicePrincipal"
  }
}

# PASS: a non-Owner role is outside the evaluation target.
resource "azurerm_role_assignment" "pass_non_owner_role" {
  attrs = {
    scope                = "/subscriptions/00000000-0000-0000-0000-000000000005"
    role_definition_name = "Contributor"
    principal_id         = "50000000-0000-0000-0000-000000000001"
    principal_type       = "User"
  }
}

# PASS: an Owner below subscription scope is outside the evaluation target.
resource "azurerm_role_assignment" "pass_non_subscription_scope" {
  attrs = {
    scope                = "/subscriptions/00000000-0000-0000-0000-000000000006/resourceGroups/example"
    role_definition_name = "Owner"
    principal_id         = "60000000-0000-0000-0000-000000000001"
    principal_type       = "User"
  }
}
