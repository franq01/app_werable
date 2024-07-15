import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:provider/provider.dart';
import './screens/home_screen.dart';
import './screens/mi_profile_scren.dart';
import './screens/settings_screen.dart';
import './screens/health_screen.dart';
import './screens/stats_screen.dart';
import './screens/profile_screen.dart';
import './providers/health_provider.dart';
import './widgets/time_provider.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (ctx) => HealthProvider()),
        ChangeNotifierProvider(create: (ctx) => TimeProvider()),
      ],
      child: MaterialApp(
        title: 'Health Wearable App',
        theme: ThemeData(
          primarySwatch: Colors.teal,
          visualDensity: VisualDensity.adaptivePlatformDensity,
        ),
        home: InitialScreen(), // Cambia esto a InitialScreen
        routes: {
          '/settings': (ctx) => SettingsScreen(),
          '/health': (ctx) => HealthScreen(),
          '/stats': (ctx) => StatsScreen(),
          '/profile': (ctx) => ProfileScreen(),
        },
      ),
    );
  }
}

class InitialScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }
        if (snapshot.hasData) {
          return HomeScreen();
        }
        return LoginScreen();
      },
    );
  }
}
