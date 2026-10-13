# Copyright IBM Corp. 2026

policytest {
  targets = ["2-9-route-change-alert.policy.hcl"]
}

resource "google_logging_metric" "fail_absent_condition_only" {
  expect_failure = true
  attrs = {
    name   = "route-absent-only"
    filter = "resource.type=\"gce_route\" AND (protoPayload.methodName:\"compute.routes.delete\" OR protoPayload.methodName:\"compute.routes.insert\")"
  }
}

resource "google_monitoring_alert_policy" "alert_absent_condition_only" {
  skip = true
  attrs = {
    display_name = "alert-absent-only"
    combiner     = "OR"
    enabled      = true
    conditions = [{
      display_name = "route metric absent"
      condition_absent = [{
        filter   = "metric.type=\"logging.googleapis.com/user/route-absent-only\" AND resource.type=\"global\""
        duration = "0s"
      }]
    }]
  }
}
