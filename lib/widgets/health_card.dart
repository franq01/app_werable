import 'package:flutter/material.dart';

class HealthCard extends StatelessWidget {
  final dynamic
      healthData; // Asegúrate de reemplazar 'dynamic' con el tipo correcto de tus datos de salud

  HealthCard({required this.healthData});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Health Data',
              style: Theme.of(context)
                  .textTheme
                  .headlineSmall, // Cambiar headline6 a headlineSmall
            ),
            SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Steps: ${healthData.steps}',
                  style: TextStyle(fontSize: 16),
                ),
                Text(
                  'Heart Rate: ${healthData.heartRate}',
                  style: TextStyle(fontSize: 16),
                ),
              ],
            ),
            SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Calories: ${healthData.calories}',
                  style: TextStyle(fontSize: 16),
                ),
                Text(
                  'Distance: ${healthData.distance}',
                  style: TextStyle(fontSize: 16),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
