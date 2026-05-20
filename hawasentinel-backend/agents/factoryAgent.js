import { BaseAgent } from './baseAgent.js';

const tools = [
  {
    type: "function",
    function: {
      name: "monitor_emissions",
      description: "Monitor industrial emissions based on AQI and factory density",
      parameters: {
        type: "object",
        properties: {
          aqi: { type: "number" },
          industrial_zone: { type: "string" }
        },
        required: ["aqi", "industrial_zone"]
      }
    }
  },
  {
    type: "function",
    function: {
      name: "issue_factory_shutdown",
      description: "Issue temporary shutdown orders to highly polluting factories",
      parameters: {
        type: "object",
        properties: {
          factories_to_shutdown: { type: "array", items: { type: "string" } },
          zone: { type: "string" }
        },
        required: ["factories_to_shutdown", "zone"]
      }
    }
  }
];

const toolExecutors = {
  monitor_emissions: async ({ aqi, industrial_zone }) => {
    let emission_status = "compliant";
    if (aqi > 350) emission_status = "severe_violation";
    else if (aqi > 200) emission_status = "warning_level";

    // Mock factory lists
    const violators = emission_status === "severe_violation" ? ["Steel Mill A", "Cement Factory B", "Textile Plant C"] : [];

    return {
      emission_status,
      violators_identified: violators.length,
      factories_exceeding_limits: violators
    };
  },
  issue_factory_shutdown: async ({ factories_to_shutdown, zone }) => {
    return {
      shutdown_orders_issued: factories_to_shutdown.length,
      zone_affected: zone,
      epa_teams_dispatched: factories_to_shutdown.length,
      notification: `Shutdown orders issued for ${factories_to_shutdown.join(', ')} in ${zone} due to severe emission violations.`
    };
  }
};

const systemPrompt = `You are the Factory Regulation Agent for HawaSentinel.
Monitor industrial zones and shut down non-compliant factories based on AQI.
Always respond with valid JSON only.

Final JSON output shape must exactly match:
{
  "agent": "factory",
  "decision": "shutdown" | "warn" | "monitor",
  "confidence": 0.0-1.0,
  "emission_report": {
    "emission_status": "severe_violation",
    "violators_identified": 3
  },
  "shutdown_details": {
    "shutdown_orders_issued": 3,
    "epa_teams_dispatched": 3,
    "notification": "string"
  },
  "action_taken": "string describing what was done"
}`;

export const factoryAgent = new BaseAgent({
  name: "factoryAgent",
  systemPrompt,
  tools,
  toolExecutors
});
