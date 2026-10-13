# Copyright IBM Corp. 2026

policytest {
  targets = ["2-17-load-balancer-logging.policy.hcl"]
}

resource "google_compute_backend_service" "pass_gl_https_enabled" {
  attrs = {
    name                  = "pass-gl-https-enabled"
    protocol              = "HTTPS"
    load_balancing_scheme = "EXTERNAL_MANAGED"
    log_config            = [{ enable = true, sample_rate = 1.0 }]
  }
}

resource "google_compute_backend_service" "pass_gl_http_enabled_half" {
  attrs = {
    name                  = "pass-gl-http-enabled-half"
    protocol              = "HTTP"
    load_balancing_scheme = "EXTERNAL"
    log_config            = [{ enable = true, sample_rate = 0.5 }]
  }
}

resource "google_compute_backend_service" "pass_gl_enabled_no_rate" {
  attrs = {
    name                  = "pass-gl-enabled-no-rate"
    protocol              = "HTTPS"
    load_balancing_scheme = "EXTERNAL_MANAGED"
    log_config            = [{ enable = true }]
  }
}

resource "google_compute_backend_service" "fail_gl_disabled" {
  expect_failure = true
  attrs = {
    name                  = "fail-gl-disabled"
    protocol              = "HTTPS"
    load_balancing_scheme = "EXTERNAL_MANAGED"
    log_config            = [{ enable = false, sample_rate = 1.0 }]
  }
}

resource "google_compute_backend_service" "fail_gl_log_config_absent" {
  expect_failure = true
  attrs = {
    name                  = "fail-gl-log-config-absent"
    protocol              = "HTTPS"
    load_balancing_scheme = "EXTERNAL_MANAGED"
  }
}

resource "google_compute_backend_service" "fail_gl_log_config_null" {
  expect_failure = true
  attrs = {
    name                  = "fail-gl-log-config-null"
    protocol              = "HTTPS"
    load_balancing_scheme = "EXTERNAL_MANAGED"
    log_config            = null
  }
}

resource "google_compute_backend_service" "fail_gl_log_config_empty" {
  expect_failure = true
  attrs = {
    name                  = "fail-gl-log-config-empty"
    protocol              = "HTTPS"
    load_balancing_scheme = "EXTERNAL_MANAGED"
    log_config            = []
  }
}

resource "google_compute_backend_service" "fail_gl_enable_absent" {
  expect_failure = true
  attrs = {
    name                  = "fail-gl-enable-absent"
    protocol              = "HTTPS"
    load_balancing_scheme = "EXTERNAL_MANAGED"
    log_config            = [{ sample_rate = 1.0 }]
  }
}

resource "google_compute_backend_service" "fail_gl_enable_null" {
  expect_failure = true
  attrs = {
    name                  = "fail-gl-enable-null"
    protocol              = "HTTPS"
    load_balancing_scheme = "EXTERNAL_MANAGED"
    log_config            = [{ enable = null, sample_rate = 1.0 }]
  }
}

resource "google_compute_backend_service" "fail_gl_sample_rate_zero" {
  expect_failure = true
  attrs = {
    name                  = "fail-gl-sample-rate-zero"
    protocol              = "HTTPS"
    load_balancing_scheme = "EXTERNAL_MANAGED"
    log_config            = [{ enable = true, sample_rate = 0.0 }]
  }
}

resource "google_compute_backend_service" "pass_gl_tcp_backend_out_of_scope" {
  attrs = {
    name       = "pass-gl-tcp-backend-out-of-scope"
    protocol   = "TCP"
    log_config = [{ enable = false, sample_rate = 0.0 }]
  }
}

resource "google_compute_backend_service" "pass_gl_ssl_backend_out_of_scope" {
  attrs = {
    name       = "pass-gl-ssl-backend-out-of-scope"
    protocol   = "SSL"
    log_config = [{ enable = false, sample_rate = 0.0 }]
  }
}

resource "google_compute_backend_service" "pass_gl_udp_backend_out_of_scope" {
  attrs = {
    name       = "pass-gl-udp-backend-out-of-scope"
    protocol   = "UDP"
    log_config = [{ enable = false, sample_rate = 0.0 }]
  }
}

resource "google_compute_backend_service" "pass_gl_unspecified_backend_out_of_scope" {
  attrs = {
    name       = "pass-gl-unspecified-backend-out-of-scope"
    protocol   = "UNSPECIFIED"
    log_config = [{ enable = false, sample_rate = 0.0 }]
  }
}

resource "google_compute_region_backend_service" "pass_rg_enabled" {
  attrs = {
    name                  = "pass-rg-enabled"
    protocol              = "HTTPS"
    load_balancing_scheme = "INTERNAL_MANAGED"
    log_config            = [{ enable = true, sample_rate = 1.0 }]
  }
}

resource "google_compute_region_backend_service" "fail_rg_disabled" {
  expect_failure = true
  attrs = {
    name                  = "fail-rg-disabled"
    protocol              = "HTTP"
    load_balancing_scheme = "EXTERNAL_MANAGED"
    log_config            = [{ enable = false, sample_rate = 1.0 }]
  }
}

resource "google_compute_region_backend_service" "fail_rg_log_config_absent" {
  expect_failure = true
  attrs = {
    name                  = "fail-rg-log-config-absent"
    protocol              = "HTTPS"
    load_balancing_scheme = "INTERNAL_MANAGED"
  }
}

resource "google_compute_region_backend_service" "fail_rg_sample_rate_zero" {
  expect_failure = true
  attrs = {
    name                  = "fail-rg-sample-rate-zero"
    protocol              = "HTTPS"
    load_balancing_scheme = "INTERNAL_MANAGED"
    log_config            = [{ enable = true, sample_rate = 0.0 }]
  }
}
