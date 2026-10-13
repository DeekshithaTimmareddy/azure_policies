# Copyright IBM Corp. 2026

policytest {
  targets = ["2-14-asset-inventory.policy.hcl"]
}

resource "google_project_service" "pass_cloudasset_without_project_resource" {
  attrs = {
    service = "cloudasset.googleapis.com"
  }
}
