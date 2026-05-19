import 'package:flutter/material.dart';
import '../services/api_service.dart';
import '../models/simulation_result.dart';

class AppState with ChangeNotifier {
  final ApiService _apiService = ApiService();
  
  bool _isLoading = false;
  bool get isLoading => _isLoading;

  SimulationResult? _currentSimulation;
  SimulationResult? get currentSimulation => _currentSimulation;

  Future<void> triggerSimulation(String scenario) async {
    _isLoading = true;
    notifyListeners();

    _currentSimulation = await _apiService.runSimulation(scenario);

    _isLoading = false;
    notifyListeners();
  }
}
