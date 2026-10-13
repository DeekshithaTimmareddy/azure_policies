# Copyright IBM Corp. 2026

policytest {
  targets = ["2-13-dns-logging.policy.hcl"]
}

resource "google_compute_network" "pass_net_a" {
  attrs = { name = "net-a", id = "projects/demo-proj/global/networks/net-a", self_link = "https://www.googleapis.com/compute/v1/projects/demo-proj/global/networks/net-a" }
}
resource "google_dns_policy" "pass_policy_a" {
  attrs = { name = "dns-a", enable_logging = true, networks = [{ network_url = "projects/demo-proj/global/networks/net-a" }] }
}
resource "google_compute_network" "fail_net_b_uncovered" {
  expect_failure = true
  attrs          = { name = "net-b", id = "projects/demo-proj/global/networks/net-b", self_link = "https://www.googleapis.com/compute/v1/projects/demo-proj/global/networks/net-b" }
}
resource "google_compute_network" "fail_net_c_logging_false" {
  expect_failure = true
  attrs          = { name = "net-c", id = "projects/demo-proj/global/networks/net-c", self_link = "https://www.googleapis.com/compute/v1/projects/demo-proj/global/networks/net-c" }
}
resource "google_dns_policy" "fail_policy_c_logging_false" {
  expect_failure = true
  attrs          = { name = "dns-c", enable_logging = false, networks = [{ network_url = "projects/demo-proj/global/networks/net-c" }] }
}
resource "google_compute_network" "fail_net_d_logging_absent" {
  expect_failure = true
  attrs          = { name = "net-d", id = "projects/demo-proj/global/networks/net-d", self_link = "https://www.googleapis.com/compute/v1/projects/demo-proj/global/networks/net-d" }
}
resource "google_dns_policy" "fail_policy_d_logging_absent" {
  expect_failure = true
  attrs          = { name = "dns-d", networks = [{ network_url = "projects/demo-proj/global/networks/net-d" }] }
}
resource "google_compute_network" "fail_net_e_logging_null" {
  expect_failure = true
  attrs          = { name = "net-e", id = "projects/demo-proj/global/networks/net-e", self_link = "https://www.googleapis.com/compute/v1/projects/demo-proj/global/networks/net-e" }
}
resource "google_dns_policy" "fail_policy_e_logging_null" {
  expect_failure = true
  attrs          = { name = "dns-e", enable_logging = null, networks = [{ network_url = "projects/demo-proj/global/networks/net-e" }] }
}
resource "google_dns_policy" "pass_policy_f_empty_networks" {
  attrs = { name = "dns-f", enable_logging = true, networks = [] }
}

resource "google_compute_network" "pass_network_by_self_link" {
  attrs = {
    name      = "net-self-link"
    id        = "projects/demo-proj/global/networks/net-self-link"
    self_link = "https://www.googleapis.com/compute/v1/projects/demo-proj/global/networks/net-self-link"
  }
}

resource "google_dns_policy" "pass_policy_self_link" {
  attrs = {
    name           = "dns-self-link"
    enable_logging = true
    networks = [{
      network_url = "https://www.googleapis.com/compute/v1/projects/demo-proj/global/networks/net-self-link"
    }]
  }
}

resource "google_compute_network" "pass_network_by_name" {
  attrs = {
    name      = "net-by-name"
    project   = "demo-proj"
    id        = null
    self_link = null
  }
}

resource "google_dns_policy" "pass_policy_network_name" {
  attrs = {
    name           = "dns-network-name"
    enable_logging = true
    networks = [{
      network_url = "https://www.googleapis.com/compute/v1/projects/demo-proj/global/networks/net-by-name"
    }]
  }
}

resource "google_compute_network" "fail_same_name_other_project" {
  expect_failure = true
  attrs = {
    name      = "shared-network"
    project   = "project-one"
    id        = "projects/project-one/global/networks/shared-network"
    self_link = "https://www.googleapis.com/compute/v1/projects/project-one/global/networks/shared-network"
  }
}

resource "google_dns_policy" "policy_for_other_project_network" {
  attrs = {
    enable_logging = true
    networks = [{
      network_url = "https://www.googleapis.com/compute/v1/projects/project-two/global/networks/shared-network"
    }]
  }
}
