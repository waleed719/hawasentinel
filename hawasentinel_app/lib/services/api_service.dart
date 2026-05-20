import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/simulation_result.dart';

class ApiService {
  static const String baseUrl = 'http://51.20.56.63:3000/api'; // EC2
  // static const String baseUrl = 'http://192.168.100.186:3000/api'; // Local IP for demo recording

  Future<SimulationResult?> runSimulation(String scenario) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/simulate'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'scenario': scenario}),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        if (data['status'] == 'success') {
          return SimulationResult.fromJson(data['data']);
        }
      }
      print('API Error: ${response.statusCode} - ${response.body}');
      return null;
    } catch (e) {
      print('Network Error: $e');
      return null;
    }
  }
}
