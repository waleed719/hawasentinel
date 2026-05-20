import { schoolAgent } from './schoolAgent.js';
import { hospitalAgent } from './hospitalAgent.js';
import { riderAgent } from './riderAgent.js';
import { farmerAgent } from './farmerAgent.js';
import { trafficPoliceAgent } from './trafficPoliceAgent.js';
import { factoryAgent } from './factoryAgent.js';

export async function runOrchestrator(aqiData) {
  // 1. Run all 6 agents sequentially to avoid overloading the local Ollama model
  const schoolResult = await schoolAgent.run(aqiData);
  const hospitalResult = await hospitalAgent.run(aqiData);
  const riderResult = await riderAgent.run(aqiData);
  const farmerResult = await farmerAgent.run(aqiData);
  const trafficResult = await trafficPoliceAgent.run(aqiData);
  const factoryResult = await factoryAgent.run(aqiData);

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
      rider: riderResult,
      farmer: farmerResult,
      traffic: trafficResult,
      factory: factoryResult
    },
    summary: {
      total_actions: 6,
      schools_affected: schoolResult.affected_schools?.length || 0,
      hospital_beds_added: hospitalResult.reallocation?.beds_added || 0,
      zones_restricted: riderResult.routing?.avoid_zones?.length || 0,
      farmers_notified: farmerResult.ban_details?.notified_farmers_count || 0,
      routes_closed: trafficResult.traffic_management?.routes_closed || 0,
      factories_shutdown: factoryResult.shutdown_details?.shutdown_orders_issued || 0
    }
  };
}
