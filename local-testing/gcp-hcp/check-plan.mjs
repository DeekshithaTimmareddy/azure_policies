import { readFileSync, mkdtempSync, writeFileSync, rmSync } from "node:fs";
import { tmpdir } from "node:os";
import { resolve, join, dirname } from "node:path";
import { fileURLToPath } from "node:url";
import { spawnSync } from "node:child_process";

const [planPath, control] = process.argv.slice(2);
const policies = {
  sql: "2-12-sql-config-change-alert.policy.hcl",
  ownership: "2-5-project-ownership-change-alert.policy.hcl",
  audit: "2-6-audit-config-change-alert.policy.hcl",
  role: "2-7-custom-role-change-alert.policy.hcl",
  firewall: "2-8-firewall-rule-change-alert.policy.hcl",
  route: "2-9-route-change-alert.policy.hcl",
  network: "2-10-network-change-alert.policy.hcl",
  storage: "2-11-storage-iam-change-alert.policy.hcl",
};

if (!planPath || !policies[control]) {
  throw new Error("Usage: node check-plan.mjs PLAN.json CONTROL");
}

const plan = JSON.parse(readFileSync(planPath, "utf8"));
const root = (plan.planned_values ?? plan.values)?.root_module;
if (!root) throw new Error("Plan JSON has no root_module planned values");

function collectResources(module) {
  return [
    ...(module.resources ?? []),
    ...(module.child_modules ?? []).flatMap(collectResources),
  ];
}

const resources = collectResources(root);
const requiredTypes = ["google_logging_metric", "google_monitoring_alert_policy"];
const policyResources = resources.filter((resource) => requiredTypes.includes(resource.type));
for (const type of requiredTypes) {
  if (!policyResources.some((resource) => resource.type === type)) {
    throw new Error(`Plan has no ${type}; refusing a vacuous policy check`);
  }
}

function policyAttributes(resource) {
  const values = resource.values ?? {};
  if (resource.type === "google_logging_metric") {
    return { name: values.name, filter: values.filter };
  }
  return {
    enabled: values.enabled,
    notification_channels: values.notification_channels,
    conditions: values.conditions,
  };
}

const policyDirectory = resolve(
  dirname(fileURLToPath(import.meta.url)),
  "../../policies/gcp/logging",
);
const testsDirectory = mkdtempSync(join(tmpdir(), "gcp-hcp-plan-"));
const fixture = `policytest {
  targets = [${JSON.stringify(policies[control])}]
}
${policyResources.map((resource, index) => `resource ${JSON.stringify(resource.type)} ${JSON.stringify(`planned_${index}`)} {
  attrs = ${JSON.stringify(policyAttributes(resource))}
}
`).join("\n")}`;

try {
  const fixturePath = join(testsDirectory, `${policies[control].replace(".policy.hcl", ".policytest.hcl")}`);
  writeFileSync(fixturePath, fixture);
  const result = spawnSync(
    "tfpolicy",
    ["test", `--policies=${policyDirectory}`, `--tests=${testsDirectory}`],
    { stdio: "inherit" },
  );
  if (result.error) throw result.error;
  if (result.status !== 0) process.exitCode = result.status ?? 1;
  else console.log(`PASS: ${policies[control]} against exported HCP plan`);
} finally {
  rmSync(testsDirectory, { recursive: true, force: true });
}