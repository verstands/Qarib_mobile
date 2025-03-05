import 'dart:io';
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
  List<File> _servicePhotos =
      []; // Liste pour stocker plusieurs photos de service
  final ImagePicker _picker = ImagePicker();
  TextEditingController _serviceDescriptionController =
      TextEditingController(); // Pour la description

  Future<void> _pickImage(bool isProfilePhoto) async {
    final XFile? image = await _picker.pickImage(
      source: ImageSource.gallery,
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

  Future<void> _pickServicePhoto() async {
    final XFile? image = await _picker.pickImage(
      source: ImageSource.gallery,
    );

    if (image != null) {
      setState(() {
        _servicePhotos
            .add(File(image.path)); // Ajout de la nouvelle photo à la liste
      });
    }
  }

  Future<void> _takeServicePhoto() async {
    final XFile? image = await _picker.pickImage(
      source: ImageSource.camera,
    );

    if (image != null) {
      setState(() {
        _servicePhotos
            .add(File(image.path)); // Ajout de la nouvelle photo à la liste
      });
    }
  }

  void _removeServicePhoto(int index) {
    setState(() {
      _servicePhotos.removeAt(index); // Supprime la photo de la liste
    });
  }

  void _submit() {
    if (_profilePhoto != null &&
        _idCardPhoto != null &&
        _servicePhotos.isNotEmpty) {
      print('Photos soumises avec succès !');
      print('Description du service: ${_serviceDescriptionController.text}');
      // Vous pouvez maintenant sauvegarder ces informations dans votre base de données
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
              'Veuillez sélectionner toutes les photos et ajouter une description.'),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Téléchargez vos photos',
            style: TextStyle(color: Colors.white)),
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
              const SizedBox(height: 20),
              const Text(
                "Ajoutez des photos pour le service :",
                style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87),
              ),
              const SizedBox(height: 20),
              Row(
                children: [
                  IconButton(
                    icon: const Icon(Icons.photo_library, color: Colors.orange),
                    onPressed: _pickServicePhoto,
                  ),
                  IconButton(
                    icon: const Icon(Icons.camera_alt, color: Colors.orange),
                    onPressed: _takeServicePhoto,
                  ),
                ],
              ),
              const SizedBox(height: 10),
              // Affichage des photos de service avec la croix pour suppression
              if (_servicePhotos.isNotEmpty)
                GridView.builder(
                  shrinkWrap: true,
                  itemCount: _servicePhotos.length,
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3,
                    crossAxisSpacing: 10,
                    mainAxisSpacing: 10,
                  ),
                  itemBuilder: (context, index) {
                    return Stack(
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(10),
                          child: Image.file(
                            _servicePhotos[index],
                            fit: BoxFit.cover,
                            height: 100, // Ajuste la hauteur de l'image
                            width: 100, // Ajuste la largeur de l'image
                          ),
                        ),
                        Positioned(
                          top:
                              5, // Ajuste la position de l'icône pour mieux l'intégrer à l'image
                          right: 5,
                          child: IconButton(
                            icon: const Icon(Icons.close,
                                color: Colors.red,
                                size: 18), // Taille plus petite pour l'icône
                            onPressed: () => _removeServicePhoto(index),
                          ),
                        ),
                      ],
                    );
                  },
                ),

              const SizedBox(height: 20),
              // Champ de description pour le service
              TextField(
                controller: _serviceDescriptionController,
                maxLines: 3,
                decoration: InputDecoration(
                  labelText: 'Description du service',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 40),
              Center(
                child: ElevatedButton(
                  onPressed: _submit,
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
                  child: const Text('Soumettre',
                      style: TextStyle(color: Colors.white)),
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
