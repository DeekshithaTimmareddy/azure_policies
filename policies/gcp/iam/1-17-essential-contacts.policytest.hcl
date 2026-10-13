# Copyright IBM Corp. 2026

policytest {
  targets = ["1-17-essential-contacts.policy.hcl"]
}

resource "google_essential_contacts_contact" "pass_org_all" {
  attrs = {
    parent                              = "organizations/1001"
    email                               = "sec@example.com"
    language_tag                        = "en"
    notification_category_subscriptions = ["ALL"]
  }
}

resource "google_essential_contacts_contact" "pass_org_split_a" {
  attrs = {
    parent                              = "organizations/1002"
    email                               = "legal@example.com"
    language_tag                        = "en"
    notification_category_subscriptions = ["LEGAL", "SECURITY"]
  }
}

resource "google_essential_contacts_contact" "pass_org_split_b" {
  attrs = {
    parent                              = "organizations/1002"
    email                               = "ops@example.com"
    language_tag                        = "en"
    notification_category_subscriptions = ["SUSPENSION", "TECHNICAL"]
  }
}

resource "google_essential_contacts_contact" "pass_org_four_categories" {
  attrs = {
    parent                              = "organizations/1003"
    email                               = "ops@example.com"
    language_tag                        = "en"
    notification_category_subscriptions = ["LEGAL", "SECURITY", "SUSPENSION", "TECHNICAL"]
  }
}

resource "google_essential_contacts_contact" "fail_org_only_non_essential" {
  expect_failure = true
  attrs = {
    parent                              = "organizations/1004"
    email                               = "billing@example.com"
    language_tag                        = "en"
    notification_category_subscriptions = ["BILLING", "PRODUCT_UPDATES"]
  }
}

resource "google_essential_contacts_contact" "fail_org_missing_technical" {
  expect_failure = true
  attrs = {
    parent                              = "organizations/1005"
    email                               = "ops@example.com"
    language_tag                        = "en"
    notification_category_subscriptions = ["LEGAL", "SECURITY", "SUSPENSION"]
  }
}

resource "google_essential_contacts_contact" "fail_org_empty_categories" {
  expect_failure = true
  attrs = {
    parent                              = "organizations/1006"
    email                               = "ops@example.com"
    language_tag                        = "en"
    notification_category_subscriptions = []
  }
}

resource "google_essential_contacts_contact" "fail_org_empty_email" {
  expect_failure = true
  attrs = {
    parent                              = "organizations/1007"
    email                               = ""
    language_tag                        = "en"
    notification_category_subscriptions = ["ALL"]
  }
}

resource "google_essential_contacts_contact" "fail_org_whitespace_email" {
  expect_failure = true
  attrs = {
    parent                              = "organizations/1009"
    email                               = "   "
    language_tag                        = "en"
    notification_category_subscriptions = ["ALL"]
  }
}

resource "google_essential_contacts_contact" "pass_org_covered_all" {
  attrs = {
    parent                              = "organizations/1008"
    email                               = "sec@example.com"
    language_tag                        = "en"
    notification_category_subscriptions = ["ALL"]
  }
}

resource "google_essential_contacts_contact" "pass_org_covered_extra_billing" {
  attrs = {
    parent                              = "organizations/1008"
    email                               = "billing@example.com"
    language_tag                        = "en"
    notification_category_subscriptions = ["BILLING"]
  }
}

resource "google_essential_contacts_contact" "pass_project_scope" {
  attrs = {
    parent                              = "projects/my-project"
    email                               = "sec@example.com"
    language_tag                        = "en"
    notification_category_subscriptions = ["ALL"]
  }
}

resource "google_essential_contacts_contact" "pass_folder_scope" {
  attrs = {
    parent                              = "folders/987654321"
    email                               = "billing@example.com"
    language_tag                        = "en"
    notification_category_subscriptions = ["BILLING"]
  }
}
