import { BaseAgent } from './baseAgent.js';

const tools = [
  {
    type: "function",
    function: {
      name: "predict_surge",
      description: "Predict ER surge based on AQI and baseline beds",
      parameters: {
        type: "object",
        properties: {
          aqi: { type: "number" },
          baseline_beds: { type: "number" }
        },
        required: ["aqi", "baseline_beds"]
      }
    }
  },
  {
    type: "function",
    function: {
      name: "reallocate_beds",
      description: "Reallocate hospital beds and order nebulizers",
      parameters: {
        type: "object",
        properties: {
          extra_beds_needed: { type: "number" },
          hospital_name: { type: "string" }
        },
        required: ["extra_beds_needed", "hospital_name"]
      }
    }
  }
];

const toolExecutors = {
  predict_surge: async ({ aqi, baseline_beds }) => {
    let multiplier = 1.3;
    if (aqi > 500) multiplier = 3.4;
    else if (aqi > 300) multiplier = 2.1;

    const predicted_admissions = Math.round(baseline_beds * multiplier);
    const extra_beds_needed = Math.max(0, predicted_admissions - baseline_beds);

    return {
      predicted_admissions,
      surge_multiplier: multiplier,
      extra_beds_needed
    };
  },
  reallocate_beds: async ({ extra_beds_needed, hospital_name }) => {
    return {
      reallocated: true,
      beds_added: extra_beds_needed,
      total_capacity: extra_beds_needed + 40, // 40 as a mock baseline capacity
      nebulizers_ordered: Math.round(extra_beds_needed * 2)
    };
  }
};

const systemPrompt = `You are the Hospital Surge Agent for HawaSentinel.
Predict ER surge from AQI data and recommend bed reallocation.
Always respond with valid JSON only.

Final JSON output shape must exactly match:
{
  "agent": "hospital",
  "decision": "surge_expected" | "monitor" | "normal",
  "confidence": 0.0-1.0,
  "surge_prediction": {
    "multiplier": 3.4,
    "predicted_admissions": 136,
    "extra_beds_needed": 25
  },
  "reallocation": {
    "beds_added": 25,
    "total_capacity": 65,
    "nebulizers_ordered": 50
  },
  "action_taken": "string describing what was done"
}`;

export const hospitalAgent = new BaseAgent({
  name: "hospitalAgent",
  systemPrompt,
  tools,
  toolExecutors
});
