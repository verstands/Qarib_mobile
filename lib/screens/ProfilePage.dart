import 'package:flutter/material.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  String username = "Rabby KIkwele";
  String email = "rabby@example.com";
  String avatarUrl = "https://www.example.com/avatar.jpg"; 

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
            Center(
              child: CircleAvatar(
                radius: 80.0,
                backgroundImage: NetworkImage(avatarUrl),
                backgroundColor: Colors.grey[200],
              ),
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
            // Boutons pour modifier les informations du profil
            _buildActionButton(
              icon: Icons.edit,
              label: "Modifier le profil",
              color: Colors.orange,
              onPressed: () {
                setState(() {
                  username = "Rabby KIkwele";
                  email = "rabby@example.com";
                  avatarUrl = "https://www.example.com/new_avatar.jpg";  // URL de l'avatar modifié
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
