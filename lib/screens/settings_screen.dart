import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'dart:io';
import '../widgets/custom_app_bar.dart';
import '../widgets/custom_drawer.dart';
import '../widgets/settings_option_widget.dart';
import '../screens/mi_profile_scren.dart';
import '../screens/caratula_screen.dart';

class SettingsScreen extends StatefulWidget {
  @override
  _SettingsScreenState createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  final User? user = FirebaseAuth.instance.currentUser;
  File? _selectedImage;

  Future<void> _pickImage() async {
    final pickedFile =
        await ImagePicker().pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _selectedImage = File(pickedFile.path);
      });
      _uploadImageToFirebase();
    }
  }

  Future<void> _uploadImageToFirebase() async {
    if (_selectedImage == null) return;

    try {
      final storageRef = firebase_storage.FirebaseStorage.instance.ref().child(
          'caratulas/${user!.uid}/${DateTime.now().millisecondsSinceEpoch}.jpg');

      await storageRef.putFile(_selectedImage!);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Imagen subida con éxito')),
      );
    } catch (e) {
      print('Error al subir la imagen: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error al subir la imagen')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(title: 'Settings'),
      drawer: CustomDrawer(),
      body: Container(
        color: Colors.grey[200],
        child: ListView(
          children: [
            _buildTopBox(),
            _buildHorizontalIcons(context),
            _buildVerticalOptions(context),
          ],
        ),
      ),
    );
  }

  Widget _buildTopBox() {
    return Container(
      color: Color(0xFF00C5CD),
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          Icon(FontAwesomeIcons.solidClock, size: 40, color: Colors.white),
          SizedBox(width: 16),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(user?.email ?? 'Usuario',
                  style: TextStyle(color: Colors.white, fontSize: 18)),
              Text('Versión del dispositivo: V9.0.3',
                  style: TextStyle(color: Colors.white, fontSize: 14)),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildHorizontalIcons(BuildContext context) {
    return Container(
      color: Colors.white,
      padding: EdgeInsets.symmetric(vertical: 16, horizontal: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          _buildIconOption(context, 'pantalla', FontAwesomeIcons.lightbulb),
          _buildIconOption(context, 'no molestar', FontAwesomeIcons.bellSlash),
          _buildIconOption(context, 'caratula', FontAwesomeIcons.clock),
          _buildIconOption(context, 'recordatorio', FontAwesomeIcons.chair),
          _buildIconOption(context, 'mi perfil', FontAwesomeIcons.person)
        ],
      ),
    );
  }

  Widget _buildIconOption(BuildContext context, String title, IconData icon) {
    return InkWell(
      onTap: () {
        if (title == 'caratula') {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => CaratulaScreen()),
          );
        }
      },
      child: Column(
        children: [
          Icon(icon, color: Colors.teal, size: 30),
          SizedBox(height: 8),
          Text(title, style: TextStyle(fontSize: 12)),
        ],
      ),
    );
  }

  Widget _buildVerticalOptions(BuildContext context) {
    return Column(
      children: [
        SettingsOptionWidget(title: 'buscar pulsera'),
        SettingsOptionWidget(title: 'fotografia a control remoto'),
        SettingsOptionWidget(title: 'tienda de herramientas'),
        SettingsOptionWidget(title: 'reestablecer dispositivo'),
        SettingsOptionWidget(title: 'desconectar dispositivo'),
        SettingsOptionWidget(title: 'otras opciones'),
        GestureDetector(
          onTap: () async {
            await FirebaseAuth.instance.signOut();
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => LoginScreen()),
            );
          },
          child: SettingsOptionWidget(title: 'cerrar sesión'),
        ),
      ],
    );
  }
}
