import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  String username = "";
  String email = "";
  String avatarUrl = "https://www.example.com/avatar.jpg"; // Image par défaut
  final ImagePicker _picker = ImagePicker();

  @override
  void initState() {
    super.initState();
    _loadProfileData(); 
  }

  // Fonction pour récupérer les informations stockées dans SharedPreferences
  _loadProfileData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      username = prefs.getString('agent_nom') ?? "Nom non disponible";
      email = prefs.getString('agent_email') ?? "Email non disponible";
      // Tu peux également récupérer l'URL de l'avatar ici si tu en as une dans SharedPreferences
    });
  }

 Future<void> _chooseImageFromGallery() async {
    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      setState(() {
        avatarUrl = image.path;
      });
      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setString('avatar_url', avatarUrl);
    }
  }

  Future<void> _takePhoto() async {
    final XFile? image = await _picker.pickImage(source: ImageSource.camera);
    if (image != null) {
      setState(() {
        avatarUrl = image.path; 
      });
      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setString('avatar_url', avatarUrl);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Profil"),
        backgroundColor: Colors.orange,
        centerTitle: true,
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                GestureDetector(
                  onTap: _chooseImageFromGallery,
                  child: CircleAvatar(
                    radius: 80.0,
                    backgroundImage: avatarUrl.startsWith('http')
                        ? NetworkImage(avatarUrl)
                        : FileImage(File(avatarUrl)) as ImageProvider,
                    backgroundColor: Colors.grey[200],
                  ),
                ),
                
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const SizedBox(width: 16),
                IconButton(
                  icon: Icon(Icons.camera_alt, color: Colors.orange, size: 30),
                  onPressed: _takePhoto,
                ),
                IconButton(
                  icon: Icon(Icons.image, color: Colors.orange, size: 30),
                  onPressed: _chooseImageFromGallery, 
                ),
              ],
            ),
           
            const SizedBox(height: 16),
            Text(
              username,
              style: const TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
            const SizedBox(height: 8),
            // Email de l'utilisateur
            Text(
              email,
              style: const TextStyle(
                fontSize: 18,
                color: Colors.grey,
              ),
            ),
            const SizedBox(height: 40),
            _buildActionButton(
              icon: Icons.edit,
              label: "Modifier le profil",
              color: Colors.orange,
              onPressed: () {
                setState(() {
                  username = username;
                  email = email;
                  avatarUrl = "https://www.example.com/new_avatar.jpg"; 
                });
              },
            ),
            const SizedBox(height: 20),
            // Bouton de déconnexion
            _buildActionButton(
              icon: Icons.exit_to_app,
              label: "Déconnexion",
              color: Colors.red,
              onPressed: () {
                Navigator.pop(context); // Retourne à la page précédente ou à la page d'accueil
              },
            ),
          ],
        ),
      ),
    );
  }

  // Méthode pour créer un bouton d'action avec icône
  Widget _buildActionButton({
    required IconData icon,
    required String label,
    required Color color,
    required VoidCallback onPressed,
  }) {
    return ElevatedButton.icon(
      onPressed: onPressed,
      icon: Icon(icon, size: 20),
      label: Text(label),
      style: ElevatedButton.styleFrom(
        foregroundColor: Colors.white, backgroundColor: color,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(30),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
        textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
      ),
    );
  }
}
