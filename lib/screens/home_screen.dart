import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../providers/health_provider.dart';
import '../widgets/custom_app_bar.dart';
import '../widgets/custom_drawer.dart';

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final healthData = Provider.of<HealthProvider>(context).healthData;

    return Scaffold(
      appBar: CustomAppBar(title: 'Inicio'),
      backgroundColor: Color.fromARGB(255, 196, 232, 238), // Fondo claro
      drawer: CustomDrawer(),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Gráfico de pasos
              Card(
                elevation: 4,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    children: [
                      const Text(
                        'Pasos Dados',
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 30),
                      Container(
                        height: 200,
                        child: LineChart(
                          LineChartData(
                            lineBarsData: [
                              LineChartBarData(
                                spots: const [
                                  FlSpot(0, 0),
                                  FlSpot(1, 3),
                                  FlSpot(2, 10),
                                  FlSpot(3, 7),
                                  FlSpot(4, 12),
                                  FlSpot(5, 10),
                                  FlSpot(6, 15),
                                ],
                                isCurved: true,
                                color: Colors.teal,
                                barWidth: 4,
                                isStrokeCapRound: true,
                                belowBarData: BarAreaData(
                                  show: true,
                                  color: Colors.teal.withOpacity(0.3),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16),
              MyIconGrid(),
              const SizedBox(height: 20),
              // Ritmo cardiaco
              Card(
                elevation: 4,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Row(
                        children: [
                          Icon(FontAwesomeIcons.heartbeat,
                              color: Colors.red, size: 24),
                          SizedBox(width: 8),
                          Text(
                            '72 BPM',
                            style: TextStyle(
                                fontSize: 20, fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                      const SizedBox(height: 5),
                      Row(
                        children: [
                          const SizedBox(
                            width: 10,
                          ),
                          Expanded(
                            child: Container(
                              height: 200,
                              child: LineChart(
                                LineChartData(
                                  lineBarsData: [
                                    LineChartBarData(
                                      spots: const [
                                        FlSpot(0, 70),
                                        FlSpot(1, 72),
                                        FlSpot(2, 75),
                                        FlSpot(3, 73),
                                        FlSpot(4, 76),
                                        FlSpot(5, 72),
                                        FlSpot(6, 74),
                                      ],
                                      isCurved: true,
                                      color: Colors.red,
                                      barWidth: 4,
                                      isStrokeCapRound: true,
                                      belowBarData: BarAreaData(
                                        show: true,
                                        color: Colors.red.withOpacity(0.3),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class MyIconGrid extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity, // Ajusta el ancho al máximo disponible
      padding: const EdgeInsets.all(16), // Espacio alrededor del recuadro
      decoration: BoxDecoration(
        color: Colors.white, // Color del fondo del recuadro
        borderRadius: BorderRadius.circular(8), // Bordes redondeados
      ),
      child: Column(
        children: [
          _buildIconWithText('Calorías Quemadas', '320 kcal', Colors.red,
              FontAwesomeIcons.fire),
          _buildIconWithText(
              'KM recorridos',
              '20 KM',
              const Color.fromARGB(255, 15, 131, 185),
              FontAwesomeIcons.shoePrints),
        ],
      ),
    );
  }

  Widget _buildIconWithText(
      String label, String value, Color iconColor, IconData icon) {
    return Row(
      mainAxisAlignment:
          MainAxisAlignment.spaceBetween, // Espaciado uniforme entre los íconos
      children: [
        Icon(icon, size: 28, color: iconColor),
        Text(label,
            style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
        Text(value,
            style:
                const TextStyle(fontSize: 14, fontWeight: FontWeight.normal)),
      ],
    );
  }
}
