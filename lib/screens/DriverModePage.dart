import 'package:emol/screens/DriverDashboardPage.dart';
import 'package:flutter/material.dart';

class DriverModePage extends StatefulWidget {
  const DriverModePage({super.key});

  @override
  State<DriverModePage> createState() => _DriverModePageState();
}

class _DriverModePageState extends State<DriverModePage> {
  // Simuler un utilisateur qui est conducteur
  bool isDriver = true; // Vous pouvez changer cette variable en fonction de l'état de l'utilisateur (par exemple, d'une API ou d'une base de données)

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.orange,
        title: const Text("Mode Prestataire"),
        centerTitle: true,
      ),
      body: Center(
        child: isDriver
            ? Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center, // Centrer horizontalement
                children: [
                  Icon(Icons.person, size: 100, color: Colors.orange),
                  const SizedBox(height: 20),
                  const Text(
                    "Bienvenue dans le mode Prestataire Rabby Kikwele",
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                    textAlign: TextAlign.center, // Centrer le texte
                  ),
                  const SizedBox(height: 10),
                  const Text(
                    "Vous avez accès à toutes les fonctionnalités réservées aux prestataire.",
                    style: TextStyle(fontSize: 16),
                    textAlign: TextAlign.center, 
                  ),
                  const SizedBox(height: 30),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ProviderDashboardPage(),
                        ),
                      );
                    },
                    child: const Text("Accéder au tableau de bord"),
                    style: ElevatedButton.styleFrom(
                      foregroundColor: Colors.white, backgroundColor: Colors.orange,
                      padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                    ),
                  ),
                ],
              )
            : const Center(
                child: Text(
                  "Vous n'êtes pas un conducteur.",
                  style: TextStyle(fontSize: 18, color: Colors.red),
                ),
              ),
      ),
    );
  }
}

