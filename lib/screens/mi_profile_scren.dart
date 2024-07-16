import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'home_screen.dart';
import '../screens/register_screen.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  bool _isLoading = false;

  void _signInWithEmailAndPassword() async {
    setState(() {
      _isLoading = true;
    });
    try {
      await _auth.signInWithEmailAndPassword(
          email: _emailController.text, password: _passwordController.text);
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => HomeScreen()),
      );
    } on FirebaseAuthException catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error al iniciar sesión: ${e.message}'),
        ),
      );
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFF5F5F5),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 32.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CircleAvatar(
                radius: 60,
                backgroundColor: Colors.transparent,
                child: FaIcon(
                  FontAwesomeIcons.userAlt,
                  size: 100,
                  color: Color(0xFF4CAF50),
                ),
              ),
              SizedBox(height: 20),
              Text(
                'Iniciar Sesión',
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF4CAF50),
                ),
              ),
              SizedBox(height: 20),
              TextField(
                controller: _emailController,
                decoration: InputDecoration(
                  prefixIcon: Icon(Icons.email, color: Color(0xFF4CAF50)),
                  labelText: 'Correo Electrónico',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                ),
              ),
              SizedBox(height: 10),
              TextField(
                controller: _passwordController,
                obscureText: true,
                decoration: InputDecoration(
                  prefixIcon: Icon(Icons.lock, color: Color(0xFF4CAF50)),
                  labelText: 'Contraseña',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                ),
              ),
              SizedBox(height: 20),
              _isLoading
                  ? CircularProgressIndicator()
                  : ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        padding: EdgeInsets.symmetric(vertical: 15.0),
                        backgroundColor: Color(0xFF4CAF50),
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8.0),
                        ),
                      ),
                      onPressed: _signInWithEmailAndPassword,
                      child: Text(
                        'Iniciar Sesión',
                        style: TextStyle(fontSize: 16),
                      ),
                    ),
              SizedBox(height: 10),
              TextButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => RegisterScreen()),
                  );
                },
                child: Text(
                  '¿No tienes cuenta? Regístrate',
                  style: TextStyle(color: Color(0xFF4CAF50)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
