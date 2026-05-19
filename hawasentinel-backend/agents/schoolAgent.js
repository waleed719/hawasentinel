import { BaseAgent } from './baseAgent.js';

const tools = [
  {
    type: "function",
    function: {
      name: "get_affected_schools",
      description: "Returns a list of schools affected by the AQI in a given city",
      parameters: {
        type: "object",
        properties: {
          aqi: { type: "number" },
          city: { type: "string" }
        },
        required: ["aqi", "city"]
      }
    }
  },
  {
    type: "function",
    function: {
      name: "draft_closure_notice",
      description: "Drafts a school closure notice in English, Urdu, and SMS format",
      parameters: {
        type: "object",
        properties: {
          schools: { type: "array", items: { type: "string" } },
          aqi: { type: "number" },
          city: { type: "string" }
        },
        required: ["schools", "aqi", "city"]
      }
    }
  }
];

const toolExecutors = {
  get_affected_schools: async ({ aqi, city }) => {
    // Returns mock list of 8 school names
    return [
      "Beaconhouse Gulberg",
      "LGS Defence",
      "City School Johar Town",
      "Aitchison College",
      "Convent of Jesus and Mary",
      "LACAS Burki",
      "SICAS Main Campus",
      "Roots Millennium DHA"
    ];
  },
  draft_closure_notice: async ({ schools, aqi, city }) => {
    return {
      english: `Due to hazardous AQI levels (${aqi}) in ${city}, the following schools will remain closed tomorrow: ${schools.slice(0, 3).join(', ')} and others. Please stay indoors.`,
      urdu: `خطرناک فضائی آلودگی کی وجہ سے تمام اسکول بند رہیں گے۔ براہ کرم گھروں میں رہیں۔`,
      sms_text: `ALERT: Schools closed tomorrow in ${city} due to AQI ${aqi}. Stay safe.`
    };
  }
};

const systemPrompt = `You are the School Crisis Agent for HawaSentinel. 
Based on AQI data, decide if schools should close and draft notices. 
Always respond with valid JSON only.

Final JSON output shape must exactly match:
{
  "agent": "school",
  "decision": "close" | "monitor" | "open",
  "confidence": 0.0-1.0,
  "affected_schools": ["name1", "name2"],
  "notice": {
    "english": "string",
    "urdu": "string", 
    "sms_text": "string"
  },
  "action_taken": "string describing what was done"
}`;

export const schoolAgent = new BaseAgent({
  name: "schoolAgent",
  systemPrompt,
  tools,
  toolExecutors
});
