class SimulationResult {
  final String timestamp;
  final String crisisLevel;
  final InputData inputData;
  final Agents agents;

  SimulationResult({
    required this.timestamp,
    required this.crisisLevel,
    required this.inputData,
    required this.agents,
  });

  factory SimulationResult.fromJson(Map<String, dynamic> json) {
    return SimulationResult(
      timestamp: json['timestamp'] ?? '',
      crisisLevel: json['crisis_level'] ?? 'NORMAL',
      inputData: InputData.fromJson(json['input_data'] ?? {}),
      agents: Agents.fromJson(json['agents'] ?? {}),
    );
  }
}

class InputData {
  final int aqi;
  final int fires;
  final String wind;
  final String city;

  InputData({required this.aqi, required this.fires, required this.wind, required this.city});

  factory InputData.fromJson(Map<String, dynamic> json) {
    return InputData(
      aqi: json['aqi'] ?? 0,
      fires: json['fires'] ?? 0,
      wind: json['wind'] ?? '',
      city: json['city'] ?? 'Unknown',
    );
  }
}

class Agents {
  final AgentResult school;
  final AgentResult hospital;
  final AgentResult rider;

  Agents({required this.school, required this.hospital, required this.rider});

  factory Agents.fromJson(Map<String, dynamic> json) {
    return Agents(
      school: AgentResult.fromJson(json['school'] ?? {}),
      hospital: AgentResult.fromJson(json['hospital'] ?? {}),
      rider: AgentResult.fromJson(json['rider'] ?? {}),
    );
  }
}

class AgentResult {
  final String agentName;
  final String decision;
  final String actionTaken;
  final Map<String, dynamic> rawData;

  AgentResult({
    required this.agentName,
    required this.decision,
    required this.actionTaken,
    required this.rawData,
  });

  factory AgentResult.fromJson(Map<String, dynamic> json) {
    return AgentResult(
      agentName: json['agent'] ?? 'unknown',
      decision: json['decision'] ?? 'unknown',
      actionTaken: json['action_taken'] ?? 'No action taken.',
      rawData: json,
    );
  }
}
