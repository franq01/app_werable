import 'package:flutter/material.dart';
import '../models/health_data.dart';
import '../models/exercise_day.dart';

class HealthProvider with ChangeNotifier {
  HealthData _healthData = HealthData(
    steps: 0,
    distance: 0.0,
    calories: 0.0,
    heartRate: 0,
    healthScore: 0,
  );

  List<ExerciseDay> _exerciseDays = []; // Lista de días de ejercicio

  HealthData get healthData => _healthData;

  List<ExerciseDay> get exerciseDays => _exerciseDays;

  void updateHealthData(HealthData newData) {
    _healthData = newData;
    notifyListeners();
  }

  void addExerciseDay(ExerciseDay newDay) {
    _exerciseDays.add(newDay);
    notifyListeners(); // Notificar a los listeners sobre el cambio
  }
}
