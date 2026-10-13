# GCP HCP policy test

This Terraform root is a live-test pilot for GCP logging controls 2.5-2.12 only. It creates a Pub/Sub topic and Monitoring notification channel, then one log metric and one alert for the selected control. It is not a test of all 22 policies. The `.policy.hcl` rules are not evaluated natively by HCP Terraform; the `check-plan.mjs` helper runs the matching `tfpolicy` rule against an exported Terraform plan.

## Workspace setup

Use the `gcp-cis-test` workspace in the Azure repository, with working directory `local-testing/gcp-hcp`, auto-apply disabled, and VCS triggers limited to this directory. The repository must contain this directory and `policies/gcp/logging` on the selected branch before queueing a run.

Add these Terraform variables in the HCP workspace:

| Name | Value |
| --- | --- |
| `project_id` | ID of a disposable GCP test project |
| `phase` | `bootstrap`, `metric`, or `test` |
| `control` | One of `sql`, `ownership`, `audit`, `role`, `firewall`, `route`, `network`, or `storage` |

Configure GCP authentication as a sensitive environment variable supported by the Google provider, preferably through workload identity. If using a service-account credential, use the `GOOGLE_CREDENTIALS` environment variable, store it only as sensitive in HCP, and grant only the permissions needed to create and delete these test resources. Do not commit credential files or paste credentials into chat. Required APIs must already be enabled in the disposable project; this root does not enable APIs.

## Run sequence

1. With `phase = bootstrap`, queue a plan and review it. Apply only if it contains the Pub/Sub topic and notification channel, with no unrelated changes.
2. Set one `control` and `phase = metric`. Queue a fresh plan and apply only after reviewing it. This creates the control's log-based metric without its alert.
3. Wait up to 10 minutes for Cloud Monitoring to make the new metric available. Then set `phase = test`, queue a fresh plan, and ensure it proposes only the matching alert. Do not apply until the exported plan passes the matching `tfpolicy` check below.
4. To test another control, set its `control` value and return `phase` to `metric`. Review the planned metric replacement and alert removal, apply, wait for propagation, then return to `phase = test` and check the alert plan.
5. When finished, queue a destroy plan, review it, and confirm it removes only resources from this test workspace. Verify the workspace state is empty afterward.

Never apply a plan for another project or an unexpected resource set. The test can create billable resources while they exist. HCP apply is not itself gated by `tfpolicy`; perform the plan check before approving apply.

## Evaluate an HCP plan

Install the same released `tfpolicy` version used by CI (0.4.0 as of 2026-10-13) and Node.js 18 or newer. From the HCP run page, copy the run ID (it begins with `run-`). A user or team API token with workspace admin access is required for the JSON plan endpoint; organization tokens are not supported. Keep the token in a local secret mechanism and set it as `TFC_TOKEN` in the shell without putting its value in a command or file.

```sh
node local-testing/gcp-hcp/download-plan.mjs run-REPLACE_WITH_RUN_ID /tmp/gcp-hcp-plan.json
node local-testing/gcp-hcp/check-plan.mjs /tmp/gcp-hcp-plan.json sql
```

Pass the matching control to the checker: `sql` (2.12), `ownership` (2.5), `audit` (2.6), `role` (2.7), `firewall` (2.8), `route` (2.9), `network` (2.10), or `storage` (2.11). The checker refuses plans missing either a metric or alert resource. Plan JSON may contain sensitive values; keep it outside the repository and delete it after checking.

The helper uses HCP Terraform's [plan JSON output API](https://developer.hashicorp.com/terraform/cloud-docs/api-docs/plans#retrieve-the-json-execution-plan). The local `tfpolicy` check is an additional manual step, not native HCP policy enforcement.

## Coverage limits

This root exercises only controls 2.5-2.12. The full authored set remains 22 policies across IAM, logging, and network. Several controls must remain plan-only or need separate carefully scoped configurations; see `gcp-local-testing/README.md` in the development workspace for the live-test results and safety restrictions. Passing this pilot is not certification of all 22 policies or proof that real events trigger notifications.
