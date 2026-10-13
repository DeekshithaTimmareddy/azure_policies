import { writeFileSync } from "node:fs";
import { resolve } from "node:path";

const [runId, outputArgument] = process.argv.slice(2);
const token = process.env.TFC_TOKEN;

if (!runId || !/^run-[A-Za-z0-9]+$/.test(runId) || !token) {
  throw new Error("Usage: TFC_TOKEN must be set; node download-plan.mjs run-ID [output.json]");
}

const host = (process.env.TFC_HOST ?? "https://app.terraform.io").replace(/\/$/, "");
const endpoint = `${host}/api/v2/runs/${runId}/plan/json-output`;
const response = await fetch(endpoint, {
  headers: {
    Authorization: `Bearer ${token}`,
    "Content-Type": "application/vnd.api+json",
  },
  redirect: "follow",
});

if (response.status === 204) {
  throw new Error("HCP has not made plan JSON available yet; wait for the plan to finish.");
}
if (!response.ok) {
  throw new Error(`HCP plan download failed with HTTP ${response.status}. Check the run ID and token access.`);
}

const plan = await response.json();
if (!(plan.planned_values ?? plan.values)?.root_module) {
  throw new Error("Downloaded response is not a Terraform plan JSON document.");
}

const outputPath = resolve(outputArgument ?? "hcp-plan.json");
writeFileSync(outputPath, JSON.stringify(plan));
console.log(`Saved plan JSON to ${outputPath}`);
