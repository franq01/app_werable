import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import '../widgets/time_provider.dart';
import '../widgets/custom_drawer.dart';

class HealthScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => TimeProvider(),
      builder: (context, child) {
        return Scaffold(
          appBar: AppBar(
            title: const Text(
              'Motion',
              style: TextStyle(color: Colors.white, fontSize: 25),
            ),
            backgroundColor: Colors.teal,
          ),
          drawer: CustomDrawer(),
          body: Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [Colors.teal, Colors.blueGrey],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
            ),
            child: Padding(
              padding: const EdgeInsets.all(10.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      TextButton.icon(
                        onPressed: () {},
                        icon: FaIcon(FontAwesomeIcons.walking,
                            color: Colors.white),
                        label: const Text('Caminando',
                            style: TextStyle(color: Colors.white)),
                      ),
                      TextButton.icon(
                        onPressed: () {},
                        icon: FaIcon(FontAwesomeIcons.running,
                            color: Colors.white),
                        label: const Text('Corriendo',
                            style: TextStyle(color: Colors.white)),
                      ),
                      TextButton.icon(
                        onPressed: () {},
                        icon: FaIcon(FontAwesomeIcons.biking,
                            color: Colors.white),
                        label: const Text('Bicicleta',
                            style: TextStyle(color: Colors.white)),
                      ),
                    ],
                  ),
                  const SizedBox(height: 80),
                  Center(
                    child: Column(
                      children: [
                        Consumer<TimeProvider>(
                          builder: (context, timeProvider, child) {
                            return Text(
                              timeProvider.formattedTime,
                              style: const TextStyle(
                                fontSize: 50,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            );
                          },
                        ),
                        const Text(
                          'Kilómetros recorridos',
                          style: TextStyle(fontSize: 20, color: Colors.white70),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 10),
                  Expanded(
                    child: Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const SizedBox(height: 10),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              ElevatedButton(
                                onPressed: () {
                                  Provider.of<TimeProvider>(context,
                                          listen: false)
                                      .startTimer();
                                },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.teal,
                                  shape: const CircleBorder(),
                                  padding: const EdgeInsets.all(20),
                                ),
                                child: const Text(
                                  'START',
                                  style: TextStyle(
                                      fontSize: 24, color: Colors.white),
                                ),
                              ),
                              const SizedBox(width: 20),
                              ElevatedButton(
                                onPressed: () {
                                  Provider.of<TimeProvider>(context,
                                          listen: false)
                                      .stopTimer();
                                },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.red,
                                  shape: const CircleBorder(),
                                  padding: const EdgeInsets.all(20),
                                ),
                                child: const Text(
                                  'STOP',
                                  style: TextStyle(
                                      fontSize: 24, color: Colors.white),
                                ),
                              ),
                              const SizedBox(width: 20),
                              ElevatedButton(
                                onPressed: () {
                                  Provider.of<TimeProvider>(context,
                                          listen: false)
                                      .resetTimer();
                                },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.grey,
                                  shape: const CircleBorder(),
                                  padding: const EdgeInsets.all(20),
                                ),
                                child: const Text(
                                  'RESET',
                                  style: TextStyle(
                                      fontSize: 24, color: Colors.white),
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
      },
    );
  }
}
