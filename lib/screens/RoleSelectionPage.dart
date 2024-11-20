import 'package:emol/screens/HomePage.dart';
import 'package:emol/screens/SaisieCodePage.dart';
import 'package:emol/screens/UploadPhotoPage.dart';
import 'package:emol/utils/Menu.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class RoleSelectionPage extends StatefulWidget {
  const RoleSelectionPage({super.key});

  @override
  _RoleSelectionPageState createState() => _RoleSelectionPageState();
}

class _RoleSelectionPageState extends State<RoleSelectionPage> {

  Future<void> _saveUserRole(String role) async {
    // Enregistre le rôle dans SharedPreferences
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('role', role);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center, 
          children: [
            const Text(
              "Quel rôle souhaitez-vous choisir ?",
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.orangeAccent,
              ),
              textAlign: TextAlign.center, // Assure que le texte est centré horizontalement
            ),
            const SizedBox(height: 40),

            ElevatedButton(
              onPressed: () async {
                await _saveUserRole('prestateur');
          
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const UploadPhotoPage(),
                  ),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.orangeAccent,
                padding: const EdgeInsets.symmetric(horizontal: 55, vertical: 40),
                shape: const CircleBorder(), // Utiliser un CircleBorder pour un bouton rond
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const CircleAvatar(
                    radius: 30, // Taille de l'icône
                    backgroundColor: Colors.white,
                    child: Icon(Icons.business_center, color: Colors.orangeAccent, size: 30),
                  ),
                  const SizedBox(height: 10),
                  const Text(
                    'Je suis un prestataire de service',
                    style: TextStyle(fontSize: 16, color: Colors.white),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),

            // Bouton pour s'inscrire comme utilisateur (demandeur de service et utilisateur simple)
            ElevatedButton(
              onPressed: () async {
                // Enregistrer le rôle comme 'user'
                await _saveUserRole('user');
                // Rediriger vers la page suivante
                 Navigator.of(context).pushAndRemoveUntil(
                          MaterialPageRoute(builder: (context) => MenuUtils()),
                          (route) => false);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.orangeAccent,
                padding: const EdgeInsets.symmetric(horizontal: 55, vertical: 40),
                shape: const CircleBorder(), // Utiliser un CircleBorder pour un bouton rond
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const CircleAvatar(
                    radius: 30, // Taille de l'icône
                    backgroundColor: Colors.white,
                    child: Icon(Icons.account_circle, color: Colors.orangeAccent, size: 30),
                  ),
                  const SizedBox(height: 10),
                  const Text(
                    'Je suis un utilisateur / demandeur de service',
                    style: TextStyle(fontSize: 16, color: Colors.white),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
