import { BaseAgent } from './baseAgent.js';

const tools = [
  {
    type: "function",
    function: {
      name: "evaluate_visibility",
      description: "Evaluate visibility and traffic risk based on AQI and fog density",
      parameters: {
        type: "object",
        properties: {
          aqi: { type: "number" },
          fog_density: { type: "number" }
        },
        required: ["aqi", "fog_density"]
      }
    }
  },
  {
    type: "function",
    function: {
      name: "divert_traffic",
      description: "Divert traffic and close hazardous routes",
      parameters: {
        type: "object",
        properties: {
          hazardous_routes: { type: "array", items: { type: "string" } }
        },
        required: ["hazardous_routes"]
      }
    }
  }
];

const toolExecutors = {
  evaluate_visibility: async ({ aqi, fog_density }) => {
    let visibility = "clear";
    if (aqi > 400 || fog_density > 80) visibility = "zero";
    else if (aqi > 250 || fog_density > 50) visibility = "low";

    return {
      visibility_status: visibility,
      accident_risk: visibility === "zero" ? "critical" : visibility === "low" ? "high" : "normal",
      suggested_speed_limit: visibility === "zero" ? 0 : visibility === "low" ? 40 : 80
    };
  },
  divert_traffic: async ({ hazardous_routes }) => {
    return {
      routes_closed: hazardous_routes.length,
      diversions_active: true,
      checkposts_alerted: hazardous_routes.length * 2,
      broadcast_message: `Traffic alert: ${hazardous_routes.join(", ")} are closed due to low visibility.`
    };
  }
};

const systemPrompt = `You are the Traffic Police Agent for HawaSentinel.
Evaluate visibility and manage traffic routing based on AQI and fog density.
Always respond with valid JSON only.

Final JSON output shape must exactly match:
{
  "agent": "traffic_police",
  "decision": "close_routes" | "slow_traffic" | "normal",
  "confidence": 0.0-1.0,
  "visibility_evaluation": {
    "visibility_status": "zero",
    "accident_risk": "critical",
    "suggested_speed_limit": 0
  },
  "traffic_management": {
    "routes_closed": 3,
    "diversions_active": true,
    "broadcast_message": "string"
  },
  "action_taken": "string describing what was done"
}`;

export const trafficPoliceAgent = new BaseAgent({
  name: "trafficPoliceAgent",
  systemPrompt,
  tools,
  toolExecutors
});
