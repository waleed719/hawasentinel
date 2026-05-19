import { BaseAgent } from './baseAgent.js';

const tools = [
  {
    type: "function",
    function: {
      name: "get_pm25_hotspots",
      description: "Identifies dangerous PM2.5 zones in a given city",
      parameters: {
        type: "object",
        properties: {
          city: { type: "string" }
        },
        required: ["city"]
      }
    }
  },
  {
    type: "function",
    function: {
      name: "suggest_safe_routes",
      description: "Suggest safe corridors and areas to avoid based on hotspots",
      parameters: {
        type: "object",
        properties: {
          hotspots: {
            type: "array",
            items: {
              type: "object",
              properties: {
                zone: { type: "string" },
                pm25: { type: "number" },
                risk: { type: "string" }
              }
            }
          }
        },
        required: ["hotspots"]
      }
    }
  }
];

const toolExecutors = {
  get_pm25_hotspots: async ({ city }) => {
    return [
      { zone: "Gulberg", pm25: 340, risk: "hazardous" },
      { zone: "DHA", pm25: 180, risk: "unhealthy" },
      { zone: "Johar Town", pm25: 420, risk: "hazardous" }
    ];
  },
  suggest_safe_routes: async ({ hotspots }) => {
    const avoid_zones = hotspots.filter(h => h.risk === "hazardous").map(h => h.zone);
    return {
      avoid_zones,
      safe_corridors: ["Canal Road", "Airport Road"],
      recommended_breaks: avoid_zones.length > 0 ? 3 : 1
    };
  }
};

const systemPrompt = `You are the Gig Worker Safety Agent for HawaSentinel.
Identify dangerous PM2.5 zones and suggest safe routing for delivery riders.
Always respond with valid JSON only.

Final JSON output shape must exactly match:
{
  "agent": "rider",
  "decision": "restrict_movement" | "use_masks" | "normal",
  "confidence": 0.0-1.0,
  "hotspots": [
    { "zone": "Gulberg", "pm25": 340, "risk": "hazardous" }
  ],
  "routing": {
    "avoid_zones": ["Gulberg", "Johar Town"],
    "safe_corridors": ["Canal Road", "Airport Road"],
    "recommended_breaks": 3
  },
  "action_taken": "string describing what was done"
}`;

export const riderAgent = new BaseAgent({
  name: "riderAgent",
  systemPrompt,
  tools,
  toolExecutors
});
