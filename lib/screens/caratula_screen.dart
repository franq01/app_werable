import 'package:permission_handler/permission_handler.dart';
import 'package:flutter/material.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:firebase_auth/firebase_auth.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

class CaratulaScreen extends StatefulWidget {
  @override
  _CaratulaScreenState createState() => _CaratulaScreenState();
}

class _CaratulaScreenState extends State<CaratulaScreen> {
  final User? user = FirebaseAuth.instance.currentUser;
  List<String> _imageUrls = [];
  File? _selectedImage;

  @override
  void initState() {
    super.initState();
    _loadImages();
  }

  Future<void> _loadImages() async {
    try {
      final storageRef = firebase_storage.FirebaseStorage.instance
          .ref()
          .child('caratulas/${user!.uid}');
      final firebase_storage.ListResult result = await storageRef.listAll();
      final List<String> urls =
          await Future.wait(result.items.map((ref) => ref.getDownloadURL()));
      setState(() {
        _imageUrls = urls;
      });
    } catch (e) {
      print('Error al cargar las imágenes: $e');
    }
  }

  Future<void> _pickImage() async {
    final status = await [Permission.storage, Permission.camera].request();

    if (status[Permission.storage]!.isGranted &&
        status[Permission.camera]!.isGranted) {
      final pickedFile =
          await ImagePicker().pickImage(source: ImageSource.gallery);
      if (pickedFile != null) {
        setState(() {
          _selectedImage = File(pickedFile.path);
        });
        _uploadImageToFirebase();
      }
    } else {
      print('Permission denied');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Permisos no concedidos')),
      );
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
      _loadImages(); // Recargar las imágenes después de subir una nueva
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
      appBar: AppBar(
        title: Text('Caratulas'),
        actions: [
          IconButton(
            icon: Icon(Icons.add_a_photo),
            onPressed: _pickImage,
          ),
        ],
      ),
      body: _imageUrls.isEmpty
          ? Center(child: Text('No hay imágenes disponibles'))
          : GridView.builder(
              padding: const EdgeInsets.all(8.0),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 8.0,
                mainAxisSpacing: 8.0,
              ),
              itemCount: _imageUrls.length,
              itemBuilder: (context, index) {
                return Image.network(_imageUrls[index]);
              },
            ),
    );
  }
}
