import { BaseAgent } from './baseAgent.js';

const tools = [
  {
    type: "function",
    function: {
      name: "assess_crop_burning_risk",
      description: "Assess the risk of crop burning based on AQI and wind speed",
      parameters: {
        type: "object",
        properties: {
          aqi: { type: "number" },
          wind_speed: { type: "number" }
        },
        required: ["aqi", "wind_speed"]
      }
    }
  },
  {
    type: "function",
    function: {
      name: "issue_burning_ban",
      description: "Issue a ban on crop burning and notify farmers",
      parameters: {
        type: "object",
        properties: {
          region: { type: "string" },
          duration_days: { type: "number" }
        },
        required: ["region", "duration_days"]
      }
    }
  }
];

const toolExecutors = {
  assess_crop_burning_risk: async ({ aqi, wind_speed }) => {
    let risk_level = "low";
    if (aqi > 300 || wind_speed < 5) risk_level = "high";
    else if (aqi > 150) risk_level = "medium";

    return {
      risk_level,
      recommend_ban: risk_level === "high" || risk_level === "medium",
      fine_amount: risk_level === "high" ? 50000 : 0
    };
  },
  issue_burning_ban: async ({ region, duration_days }) => {
    return {
      ban_issued: true,
      notified_farmers_count: 1500,
      patrols_deployed: true,
      message: `Crop burning is strictly banned in ${region} for the next ${duration_days} days.`
    };
  }
};

const systemPrompt = `You are the Farmer Regulatory Agent for HawaSentinel.
Assess the risk of crop burning based on AQI and wind speed and recommend bans.
Always respond with valid JSON only.

Final JSON output shape must exactly match:
{
  "agent": "farmer",
  "decision": "ban" | "warn" | "allow",
  "confidence": 0.0-1.0,
  "risk_assessment": {
    "risk_level": "high",
    "recommend_ban": true,
    "fine_amount": 50000
  },
  "ban_details": {
    "ban_issued": true,
    "notified_farmers_count": 1500,
    "patrols_deployed": true
  },
  "action_taken": "string describing what was done"
}`;

export const farmerAgent = new BaseAgent({
  name: "farmerAgent",
  systemPrompt,
  tools,
  toolExecutors
});
