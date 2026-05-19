import { schoolAgent } from './schoolAgent.js';
import { hospitalAgent } from './hospitalAgent.js';
import { riderAgent } from './riderAgent.js';

export async function runOrchestrator(aqiData) {
  // 1. Run all 3 agents sequentially to avoid overloading the local Ollama model
  const schoolResult = await schoolAgent.run(aqiData);
  const hospitalResult = await hospitalAgent.run(aqiData);
  const riderResult = await riderAgent.run(aqiData);

  // 2. Determine overall crisis level
  const crisisLevel = aqiData.aqi > 500 ? "CRITICAL" 
                    : aqiData.aqi > 300 ? "HAZARDOUS" 
                    : aqiData.aqi > 150 ? "WARNING" 
                    : "NORMAL";

  // 3. Return combined JSON
  return {
    timestamp: new Date().toISOString(),
    crisis_level: crisisLevel,
    input_data: aqiData,
    agents: {
      school: schoolResult,
      hospital: hospitalResult,
      rider: riderResult
    },
    summary: {
      total_actions: 3,
      schools_affected: schoolResult.affected_schools?.length || 0,
      hospital_beds_added: hospitalResult.reallocation?.beds_added || 0,
      zones_restricted: riderResult.routing?.avoid_zones?.length || 0
    }
  };
}
