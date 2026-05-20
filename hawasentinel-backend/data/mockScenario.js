export const NOV_2024_EPISODE = [
  { time: 0,  aqi: 280, fires: 5,  wind: "NE 8kmph",  label: "Early Warning" },
  { time: 30, aqi: 380, fires: 12, wind: "NE 11kmph", label: "Deteriorating" },
  { time: 60, aqi: 540, fires: 23, wind: "NE 14kmph", label: "Hazardous" },
  { time: 90, aqi: 700, fires: 31, wind: "NE 16kmph", label: "Crisis Peak" }
];

export const FAST_REPLAY_MOCK = {
  "timestamp": new Date().toISOString(),
  "crisis_level": "HAZARDOUS",
  "input_data": {
    "city": "Lahore",
    "aqi": 540,
    "fires": 23,
    "wind": "NE 14kmph",
    "source": "fast_replay"
  },
  "agents": {
    "school": {
      "agent": "schoolAgent",
      "decision": "close",
      "confidence": 0.95,
      "affected_schools": ["Beaconhouse Gulberg", "LGS Defence", "City School Johar Town"],
      "notice": {
        "english": "Due to hazardous AQI levels (540) in Lahore, schools will remain closed.",
        "urdu": "خطرناک فضائی آلودگی کی وجہ سے اسکول بند رہیں گے",
        "sms_text": "ALERT: Schools closed tomorrow due to AQI 540. Stay safe."
      },
      "action_taken": "Issued closure notices to 8 schools via SMS and Email."
    },
    "hospital": {
      "agent": "hospitalAgent",
      "decision": "surge_expected",
      "confidence": 0.88,
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
      "action_taken": "Predicted critical surge. Reallocated 25 beds and ordered 50 nebulizers."
    },
    "rider": {
      "agent": "riderAgent",
      "decision": "reroute",
      "confidence": 0.9,
      "routing": {
        "avoid_zones": ["Gulberg", "DHA", "Mall Road"],
        "safe_corridors": ["Canal Road", "Ring Road"]
      },
      "masks_required": true,
      "action_taken": "Rerouted 150 active riders and enforced N95 mask mandate."
    },
    "farmer": {
      "agent": "farmerAgent",
      "decision": "ban",
      "confidence": 0.92,
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
      "action_taken": "Issued crop burning ban to 1500 farmers and deployed patrols."
    },
    "traffic": {
      "agent": "trafficPoliceAgent",
      "decision": "close_routes",
      "confidence": 0.85,
      "visibility_evaluation": {
        "visibility_status": "zero",
        "accident_risk": "critical",
        "suggested_speed_limit": 0
      },
      "traffic_management": {
        "routes_closed": 3,
        "diversions_active": true,
        "broadcast_message": "Traffic alert: Motorway M2 is closed due to zero visibility."
      },
      "action_taken": "Closed 3 major highways due to zero visibility and dispatched wardens."
    },
    "factory": {
      "agent": "factoryAgent",
      "decision": "shutdown",
      "confidence": 0.89,
      "emission_report": {
        "emission_status": "severe_violation",
        "violators_identified": 3
      },
      "shutdown_details": {
        "shutdown_orders_issued": 3,
        "epa_teams_dispatched": 3,
        "notification": "Shutdown orders issued for Steel Mill A, Cement Factory B, Textile Plant C."
      },
      "action_taken": "Shut down 3 non-compliant factories in the industrial zone."
    }
  },
  "summary": {
    "total_actions": 6,
    "schools_affected": 3,
    "hospital_beds_added": 25,
    "zones_restricted": 3,
    "farmers_notified": 1500,
    "routes_closed": 3,
    "factories_shutdown": 3
  }
};
