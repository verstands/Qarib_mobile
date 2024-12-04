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
  String? noms;
  String? id;
  String? email;
  String? telephone;
  String avatarUrl = "https://www.example.com/avatar.jpg"; 
  final ImagePicker _picker = ImagePicker();

  @override
  void initState() {
    super.initState();
    getNom();
    getEmail();
    getTelelephone();
    getid();
  }

  // Fonction pour récupérer les informations stockées dans SharedPreferences
   Future<void> getid() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      id = prefs.getString('agent_id');
    });
  }

   Future<void> getNom() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      noms = prefs.getString('agent_nom');
    });
  }

   Future<void> getEmail() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      email = prefs.getString('agent_email');
    });
  }

   Future<void> getTelelephone() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      telephone = prefs.getString('agent_telephone');
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

  void _showImageSourceDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Choisir une source"),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading: const Icon(Icons.camera_alt),
                title: const Text("Prendre une photo"),
                onTap: () {
                  _takePhoto();
                  Navigator.pop(context);
                },
              ),
              ListTile(
                leading: const Icon(Icons.image),
                title: const Text("Choisir depuis la galerie"),
                onTap: () {
                  _chooseImageFromGallery();
                  Navigator.pop(context);
                },
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Profil",  style: TextStyle(fontWeight: FontWeight.bold)),
        backgroundColor: Colors.orange,
        centerTitle: true,
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 24.0),
        child: Center( 
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center, 
            crossAxisAlignment: CrossAxisAlignment.center, 
            children: [
              GestureDetector(
                onTap: _showImageSourceDialog, 
                child: CircleAvatar(
                  radius: 80.0,
                  backgroundImage: avatarUrl.startsWith('http')
                      ? NetworkImage(avatarUrl)
                      : FileImage(File(avatarUrl)) as ImageProvider,
                  backgroundColor: Colors.grey[200],
                ),
              ),
              const SizedBox(height: 16),
              Text(
                noms ?? '',
                style: const TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                email ?? '',
                style: const TextStyle(
                  fontSize: 18,
                  color: Colors.grey,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                telephone ?? '',
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
                    noms = noms;
                    email = email;
                    avatarUrl = "https://www.example.com/new_avatar.jpg";
                  });
                },
              ),
              
            ],
          ),
        ),
      ),
    );
  }

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
