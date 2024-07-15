import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import '../models/exercise_day.dart'; // Asegúrate de que la ruta sea correcta

class ExerciseHistoryCard extends StatelessWidget {
  final List<ExerciseDay> exerciseDays;

  ExerciseHistoryCard({required this.exerciseDays});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.all(8.0),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Historial de Ejercicio',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            Expanded(
              child: LineChart(
                LineChartData(
                  gridData: FlGridData(show: false),
                  titlesData: FlTitlesData(show: false),
                  borderData: FlBorderData(show: false),
                  lineBarsData: [
                    LineChartBarData(
                      spots: exerciseDays
                          .map((day) =>
                              FlSpot(day.day.toDouble(), day.exerciseIntensity))
                          .toList(),
                      isCurved: true,
                      color: Colors.blue,
                      barWidth: 4,
                      isStrokeCapRound: true,
                      dotData: FlDotData(show: false),
                      belowBarData: BarAreaData(show: false),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
