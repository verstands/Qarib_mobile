import 'dart:io';
import 'package:emol/screens/ServicePga.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class UploadPhotoPage extends StatefulWidget {
  const UploadPhotoPage({super.key});

  @override
  State<UploadPhotoPage> createState() => _UploadPhotoPageState();
}

class _UploadPhotoPageState extends State<UploadPhotoPage> {
  File? _profilePhoto; 
  File? _idCardPhoto; 
  final ImagePicker _picker = ImagePicker();

  Future<void> _pickImage(bool isProfilePhoto) async {
    final XFile? image = await _picker.pickImage(
      source:
          ImageSource.gallery, 
    );

    if (image != null) {
      setState(() {
        if (isProfilePhoto) {
          _profilePhoto = File(image.path);
        } else {
          _idCardPhoto = File(image.path);
        }
      });
    }
  }

  Future<void> _takePhoto(bool isProfilePhoto) async {
    final XFile? image = await _picker.pickImage(
      source: ImageSource.camera,
    );

    if (image != null) {
      setState(() {
        if (isProfilePhoto) {
          _profilePhoto = File(image.path);
        } else {
          _idCardPhoto = File(image.path);
        }
      });
    }
  }

  void _submit() {
    if (_profilePhoto != null && _idCardPhoto != null) {
      print('Photos soumises avec succès !');
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content:
              Text('Veuillez sélectionner les deux photos avant de continuer.'),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Téléchargez vos photos'),
        backgroundColor: Colors.orangeAccent,
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                "Téléchargez ou prenez une photo :",
                style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87),
              ),
              const SizedBox(height: 20),
              _buildUploadSection(
                title: 'Photo de profil :',
                onGalleryTap: () => _pickImage(true),
                onCameraTap: () => _takePhoto(true),
                imageFile: _profilePhoto,
              ),
              const SizedBox(height: 20),
              _buildUploadSection(
                title: 'Carte d\'identité :',
                onGalleryTap: () => _pickImage(false),
                onCameraTap: () => _takePhoto(false),
                imageFile: _idCardPhoto,
              ),
              const SizedBox(height: 40),
              Center(
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const ServicePageCocher(),
                      ),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.orangeAccent,
                    padding: const EdgeInsets.symmetric(
                        horizontal: 50, vertical: 15),
                    textStyle: const TextStyle(
                        fontSize: 16, fontWeight: FontWeight.bold),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                  ),
                  child: const Text('Soumettre'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildUploadSection({
    required String title,
    required VoidCallback onGalleryTap,
    required VoidCallback onCameraTap,
    File? imageFile,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title,
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500)),
        const SizedBox(height: 10),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                IconButton(
                  icon: const Icon(Icons.photo_library, color: Colors.orange),
                  onPressed: onGalleryTap,
                ),
                IconButton(
                  icon: const Icon(Icons.camera_alt, color: Colors.orange),
                  onPressed: onCameraTap,
                ),
              ],
            ),
            if (imageFile != null)
              ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: Image.file(
                  imageFile,
                  height: 100,
                  width: 100,
                  fit: BoxFit.cover,
                ),
              ),
          ],
        ),
        const SizedBox(height: 10),
        const Divider(color: Colors.black26, thickness: 1),
      ],
    );
  }
}
