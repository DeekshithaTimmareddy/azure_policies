# Copyright IBM Corp. 2026

policytest {
  targets = ["2-5-project-ownership-change-alert.policy.hcl"]
}

resource "google_logging_metric" "pass_full_with_alert" {
  attrs = {
    name              = "m-pass-full-with-alert"
    project           = "my-project"
    filter            = "(protoPayload.serviceName=\"cloudresourcemanager.googleapis.com\") AND (ProjectOwnership OR projectOwnerInvitee) OR (protoPayload.serviceData.policyDelta.bindingDeltas.action=\"REMOVE\" AND protoPayload.serviceData.policyDelta.bindingDeltas.role=\"roles/owner\") OR (protoPayload.serviceData.policyDelta.bindingDeltas.action=\"ADD\" AND protoPayload.serviceData.policyDelta.bindingDeltas.role=\"roles/owner\")"
    metric_descriptor = [{ metric_kind = "DELTA", value_type = "INT64", unit = "1" }]
  }
}

resource "google_monitoring_alert_policy" "alert_pass_full_with_alert" {
  skip = true
  attrs = {
    display_name          = "alert-pass_full_with_alert"
    combiner              = "OR"
    enabled               = true
    notification_channels = ["projects/my-project/notificationChannels/1234567890"]
    conditions = [{
      display_name = "owner-change-pass_full_with_alert"
      condition_threshold = [{
        filter          = "metric.type=\"logging.googleapis.com/user/m-pass-full-with-alert\" AND resource.type=\"global\""
        comparison      = "COMPARISON_GT"
        threshold_value = 0
        duration        = "0s"
        aggregations    = [{ alignment_period = "60s", per_series_aligner = "ALIGN_COUNT" }]
      }]
    }]
  }
}

resource "google_logging_metric" "pass_alert_enabled_absent" {
  attrs = {
    name              = "m-pass-alert-enabled-absent"
    project           = "my-project"
    filter            = "(protoPayload.serviceName=\"cloudresourcemanager.googleapis.com\") AND (ProjectOwnership OR projectOwnerInvitee) OR (protoPayload.serviceData.policyDelta.bindingDeltas.action=\"REMOVE\" AND protoPayload.serviceData.policyDelta.bindingDeltas.role=\"roles/owner\") OR (protoPayload.serviceData.policyDelta.bindingDeltas.action=\"ADD\" AND protoPayload.serviceData.policyDelta.bindingDeltas.role=\"roles/owner\")"
    metric_descriptor = [{ metric_kind = "DELTA", value_type = "INT64", unit = "1" }]
  }
}

resource "google_monitoring_alert_policy" "alert_pass_alert_enabled_absent" {
  skip = true
  attrs = {
    display_name          = "alert-pass_alert_enabled_absent"
    combiner              = "OR"
    notification_channels = ["projects/my-project/notificationChannels/1234567890"]
    conditions = [{
      display_name = "owner-change-pass_alert_enabled_absent"
      condition_threshold = [{
        filter          = "metric.type=\"logging.googleapis.com/user/m-pass-alert-enabled-absent\" AND resource.type=\"global\""
        comparison      = "COMPARISON_GT"
        threshold_value = 0
        duration        = "0s"
        aggregations    = [{ alignment_period = "60s", per_series_aligner = "ALIGN_COUNT" }]
      }]
    }]
  }
}

resource "google_logging_metric" "pass_unrelated_route_metric" {
  attrs = {
    name              = "m-pass-unrelated-route-metric"
    project           = "my-project"
    filter            = "resource.type=\"gce_route\" AND protoPayload.methodName:\"compute.routes.insert\""
    metric_descriptor = [{ metric_kind = "DELTA", value_type = "INT64", unit = "1" }]
  }
}

resource "google_logging_metric" "pass_unrelated_empty_filter" {
  attrs = {
    name              = "m-pass-unrelated-empty-filter"
    project           = "my-project"
    filter            = ""
    metric_descriptor = [{ metric_kind = "DELTA", value_type = "INT64", unit = "1" }]
  }
}

resource "google_logging_metric" "fail_missing_service" {
  expect_failure = true
  attrs = {
    name              = "m-fail-missing-service"
    project           = "my-project"
    filter            = "(ProjectOwnership OR projectOwnerInvitee) OR (protoPayload.serviceData.policyDelta.bindingDeltas.action=\"REMOVE\" AND protoPayload.serviceData.policyDelta.bindingDeltas.role=\"roles/owner\") OR (protoPayload.serviceData.policyDelta.bindingDeltas.action=\"ADD\" AND protoPayload.serviceData.policyDelta.bindingDeltas.role=\"roles/owner\")"
    metric_descriptor = [{ metric_kind = "DELTA", value_type = "INT64", unit = "1" }]
  }
}

resource "google_monitoring_alert_policy" "alert_fail_missing_service" {
  skip = true
  attrs = {
    display_name          = "alert-fail_missing_service"
    combiner              = "OR"
    enabled               = true
    notification_channels = ["projects/my-project/notificationChannels/1234567890"]
    conditions = [{
      display_name = "owner-change-fail_missing_service"
      condition_threshold = [{
        filter          = "metric.type=\"logging.googleapis.com/user/m-fail-missing-service\" AND resource.type=\"global\""
        comparison      = "COMPARISON_GT"
        threshold_value = 0
        duration        = "0s"
        aggregations    = [{ alignment_period = "60s", per_series_aligner = "ALIGN_COUNT" }]
      }]
    }]
  }
}

resource "google_logging_metric" "fail_missing_ownership_tokens" {
  expect_failure = true
  attrs = {
    name              = "m-fail-missing-ownership-tokens"
    project           = "my-project"
    filter            = "(protoPayload.serviceName=\"cloudresourcemanager.googleapis.com\") OR (protoPayload.serviceData.policyDelta.bindingDeltas.action=\"REMOVE\" AND protoPayload.serviceData.policyDelta.bindingDeltas.role=\"roles/owner\") OR (protoPayload.serviceData.policyDelta.bindingDeltas.action=\"ADD\" AND protoPayload.serviceData.policyDelta.bindingDeltas.role=\"roles/owner\")"
    metric_descriptor = [{ metric_kind = "DELTA", value_type = "INT64", unit = "1" }]
  }
}

resource "google_monitoring_alert_policy" "alert_fail_missing_ownership_tokens" {
  skip = true
  attrs = {
    display_name          = "alert-fail_missing_ownership_tokens"
    combiner              = "OR"
    enabled               = true
    notification_channels = ["projects/my-project/notificationChannels/1234567890"]
    conditions = [{
      display_name = "owner-change-fail_missing_ownership_tokens"
      condition_threshold = [{
        filter          = "metric.type=\"logging.googleapis.com/user/m-fail-missing-ownership-tokens\" AND resource.type=\"global\""
        comparison      = "COMPARISON_GT"
        threshold_value = 0
        duration        = "0s"
        aggregations    = [{ alignment_period = "60s", per_series_aligner = "ALIGN_COUNT" }]
      }]
    }]
  }
}

resource "google_logging_metric" "fail_remove_wrong_role" {
  expect_failure = true
  attrs = {
    name              = "m-fail-remove-wrong-role"
    project           = "my-project"
    filter            = "(protoPayload.serviceName=\"cloudresourcemanager.googleapis.com\") AND (ProjectOwnership OR projectOwnerInvitee) OR (protoPayload.serviceData.policyDelta.bindingDeltas.action=\"REMOVE\" AND protoPayload.serviceData.policyDelta.bindingDeltas.role=\"roles/editor\") OR (protoPayload.serviceData.policyDelta.bindingDeltas.action=\"ADD\" AND protoPayload.serviceData.policyDelta.bindingDeltas.role=\"roles/owner\")"
    metric_descriptor = [{ metric_kind = "DELTA", value_type = "INT64", unit = "1" }]
  }
}

resource "google_monitoring_alert_policy" "alert_fail_remove_wrong_role" {
  skip = true
  attrs = {
    display_name          = "alert-fail_remove_wrong_role"
    combiner              = "OR"
    enabled               = true
    notification_channels = ["projects/my-project/notificationChannels/1234567890"]
    conditions = [{
      display_name = "owner-change-fail_remove_wrong_role"
      condition_threshold = [{
        filter          = "metric.type=\"logging.googleapis.com/user/m-fail-remove-wrong-role\" AND resource.type=\"global\""
        comparison      = "COMPARISON_GT"
        threshold_value = 0
        duration        = "0s"
        aggregations    = [{ alignment_period = "60s", per_series_aligner = "ALIGN_COUNT" }]
      }]
    }]
  }
}

resource "google_logging_metric" "fail_add_wrong_role" {
  expect_failure = true
  attrs = {
    name              = "m-fail-add-wrong-role"
    project           = "my-project"
    filter            = "(protoPayload.serviceName=\"cloudresourcemanager.googleapis.com\") AND (ProjectOwnership OR projectOwnerInvitee) OR (protoPayload.serviceData.policyDelta.bindingDeltas.action=\"REMOVE\" AND protoPayload.serviceData.policyDelta.bindingDeltas.role=\"roles/owner\") OR (protoPayload.serviceData.policyDelta.bindingDeltas.action=\"ADD\" AND protoPayload.serviceData.policyDelta.bindingDeltas.role=\"roles/editor\")"
    metric_descriptor = [{ metric_kind = "DELTA", value_type = "INT64", unit = "1" }]
  }
}

resource "google_monitoring_alert_policy" "alert_fail_add_wrong_role" {
  skip = true
  attrs = {
    display_name          = "alert-fail_add_wrong_role"
    combiner              = "OR"
    enabled               = true
    notification_channels = ["projects/my-project/notificationChannels/1234567890"]
    conditions = [{
      display_name = "owner-change-fail_add_wrong_role"
      condition_threshold = [{
        filter          = "metric.type=\"logging.googleapis.com/user/m-fail-add-wrong-role\" AND resource.type=\"global\""
        comparison      = "COMPARISON_GT"
        threshold_value = 0
        duration        = "0s"
        aggregations    = [{ alignment_period = "60s", per_series_aligner = "ALIGN_COUNT" }]
      }]
    }]
  }
}

resource "google_logging_metric" "fail_missing_remove_clause" {
  expect_failure = true
  attrs = {
    name              = "m-fail-missing-remove-clause"
    project           = "my-project"
    filter            = "(protoPayload.serviceName=\"cloudresourcemanager.googleapis.com\") AND (ProjectOwnership OR projectOwnerInvitee) OR (protoPayload.serviceData.policyDelta.bindingDeltas.action=\"ADD\" AND protoPayload.serviceData.policyDelta.bindingDeltas.role=\"roles/owner\")"
    metric_descriptor = [{ metric_kind = "DELTA", value_type = "INT64", unit = "1" }]
  }
}

resource "google_monitoring_alert_policy" "alert_fail_missing_remove_clause" {
  skip = true
  attrs = {
    display_name          = "alert-fail_missing_remove_clause"
    combiner              = "OR"
    enabled               = true
    notification_channels = ["projects/my-project/notificationChannels/1234567890"]
    conditions = [{
      display_name = "owner-change-fail_missing_remove_clause"
      condition_threshold = [{
        filter          = "metric.type=\"logging.googleapis.com/user/m-fail-missing-remove-clause\" AND resource.type=\"global\""
        comparison      = "COMPARISON_GT"
        threshold_value = 0
        duration        = "0s"
        aggregations    = [{ alignment_period = "60s", per_series_aligner = "ALIGN_COUNT" }]
      }]
    }]
  }
}

resource "google_logging_metric" "fail_missing_add_clause" {
  expect_failure = true
  attrs = {
    name              = "m-fail-missing-add-clause"
    project           = "my-project"
    filter            = "(protoPayload.serviceName=\"cloudresourcemanager.googleapis.com\") AND (ProjectOwnership OR projectOwnerInvitee) OR (protoPayload.serviceData.policyDelta.bindingDeltas.action=\"REMOVE\" AND protoPayload.serviceData.policyDelta.bindingDeltas.role=\"roles/owner\")"
    metric_descriptor = [{ metric_kind = "DELTA", value_type = "INT64", unit = "1" }]
  }
}

resource "google_monitoring_alert_policy" "alert_fail_missing_add_clause" {
  skip = true
  attrs = {
    display_name          = "alert-fail_missing_add_clause"
    combiner              = "OR"
    enabled               = true
    notification_channels = ["projects/my-project/notificationChannels/1234567890"]
    conditions = [{
      display_name = "owner-change-fail_missing_add_clause"
      condition_threshold = [{
        filter          = "metric.type=\"logging.googleapis.com/user/m-fail-missing-add-clause\" AND resource.type=\"global\""
        comparison      = "COMPARISON_GT"
        threshold_value = 0
        duration        = "0s"
        aggregations    = [{ alignment_period = "60s", per_series_aligner = "ALIGN_COUNT" }]
      }]
    }]
  }
}

resource "google_logging_metric" "fail_no_alert_policy" {
  expect_failure = true
  attrs = {
    name              = "m-fail-no-alert-policy"
    project           = "my-project"
    filter            = "(protoPayload.serviceName=\"cloudresourcemanager.googleapis.com\") AND (ProjectOwnership OR projectOwnerInvitee) OR (protoPayload.serviceData.policyDelta.bindingDeltas.action=\"REMOVE\" AND protoPayload.serviceData.policyDelta.bindingDeltas.role=\"roles/owner\") OR (protoPayload.serviceData.policyDelta.bindingDeltas.action=\"ADD\" AND protoPayload.serviceData.policyDelta.bindingDeltas.role=\"roles/owner\")"
    metric_descriptor = [{ metric_kind = "DELTA", value_type = "INT64", unit = "1" }]
  }
}

resource "google_logging_metric" "fail_alert_disabled" {
  expect_failure = true
  attrs = {
    name              = "m-fail-alert-disabled"
    project           = "my-project"
    filter            = "(protoPayload.serviceName=\"cloudresourcemanager.googleapis.com\") AND (ProjectOwnership OR projectOwnerInvitee) OR (protoPayload.serviceData.policyDelta.bindingDeltas.action=\"REMOVE\" AND protoPayload.serviceData.policyDelta.bindingDeltas.role=\"roles/owner\") OR (protoPayload.serviceData.policyDelta.bindingDeltas.action=\"ADD\" AND protoPayload.serviceData.policyDelta.bindingDeltas.role=\"roles/owner\")"
    metric_descriptor = [{ metric_kind = "DELTA", value_type = "INT64", unit = "1" }]
  }
}

resource "google_monitoring_alert_policy" "alert_fail_alert_disabled" {
  skip = true
  attrs = {
    display_name          = "alert-fail_alert_disabled"
    combiner              = "OR"
    enabled               = false
    notification_channels = ["projects/my-project/notificationChannels/1234567890"]
    conditions = [{
      display_name = "owner-change-fail_alert_disabled"
      condition_threshold = [{
        filter          = "metric.type=\"logging.googleapis.com/user/m-fail-alert-disabled\" AND resource.type=\"global\""
        comparison      = "COMPARISON_GT"
        threshold_value = 0
        duration        = "0s"
        aggregations    = [{ alignment_period = "60s", per_series_aligner = "ALIGN_COUNT" }]
      }]
    }]
  }
}

resource "google_logging_metric" "fail_alert_other_metric" {
  expect_failure = true
  attrs = {
    name              = "m-fail-alert-other-metric"
    project           = "my-project"
    filter            = "(protoPayload.serviceName=\"cloudresourcemanager.googleapis.com\") AND (ProjectOwnership OR projectOwnerInvitee) OR (protoPayload.serviceData.policyDelta.bindingDeltas.action=\"REMOVE\" AND protoPayload.serviceData.policyDelta.bindingDeltas.role=\"roles/owner\") OR (protoPayload.serviceData.policyDelta.bindingDeltas.action=\"ADD\" AND protoPayload.serviceData.policyDelta.bindingDeltas.role=\"roles/owner\")"
    metric_descriptor = [{ metric_kind = "DELTA", value_type = "INT64", unit = "1" }]
  }
}

resource "google_monitoring_alert_policy" "alert_fail_alert_other_metric" {
  skip = true
  attrs = {
    display_name          = "alert-fail_alert_other_metric"
    combiner              = "OR"
    enabled               = true
    notification_channels = ["projects/my-project/notificationChannels/1234567890"]
    conditions = [{
      display_name = "owner-change-fail_alert_other_metric"
      condition_threshold = [{
        filter          = "metric.type=\"logging.googleapis.com/user/some-other-metric\" AND resource.type=\"global\""
        comparison      = "COMPARISON_GT"
        threshold_value = 0
        duration        = "0s"
        aggregations    = [{ alignment_period = "60s", per_series_aligner = "ALIGN_COUNT" }]
      }]
    }]
  }
}
