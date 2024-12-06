import 'package:emol/screens/CallsInProgressPage.dart';
import 'package:emol/screens/EvaluationsPage.dart';
import 'package:emol/screens/MyServicesPage.dart';
import 'package:flutter/material.dart';

class ProviderDashboardPage extends StatelessWidget {
  const ProviderDashboardPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.orangeAccent,
        title: const Text(
          "Tableau de bord du prestataire",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        elevation: 10,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Titre de bienvenue
              const Text(
                "Bienvenue, Rabby Kikwele !",
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.orangeAccent,
                ),
              ),
              const SizedBox(height: 20),

              // Statistiques du prestataire (ex. services actifs, évaluations, etc.)
              Card(
                elevation: 8,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
                color: Colors.white,
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    children: [
                      _buildStatRow("Total des services", "8", Icons.card_giftcard),
                      _buildStatRow("Services en cours", "8", Icons.work),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 30),

              // Fonctionnalités disponibles
              const Text(
                "Fonctionnalités disponibles :",
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.orangeAccent,
                ),
              ),
              const SizedBox(height: 10),

              // Liste des boutons d'actions
              Column(
                children: [
                  DashboardOption(
                    icon: Icons.card_giftcard,
                    label: "Voir mes services",
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>  MyServicesPage(),
                        ),
                      );
                    },
                  ),
                  DashboardOption(
                    icon: Icons.notifications, // Icône de notification
                    label: "Notifications (2)",  // Nouveau label
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>  CallsInProgressPage(),
                        ),
                      );
                    },
                  ),
                  DashboardOption(
                    icon: Icons.star,
                    label: "Voir mes évaluations",
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>  EvaluationsPage(),
                        ),
                      );
                    },
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Méthode pour créer une ligne de statistiques avec icône et texte
  Widget _buildStatRow(String label, String value, IconData icon) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Icon(icon, color: Colors.orangeAccent, size: 20),
              const SizedBox(width: 8),
              Text(
                label,
                style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
              ),
            ],
          ),
          Text(
            value,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.orangeAccent,
            ),
          ),
        ],
      ),
    );
  }
}

class DashboardOption extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;

  const DashboardOption({
    super.key,
    required this.icon,
    required this.label,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8.0),
      elevation: 6,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: ListTile(
        leading: Icon(icon, color: Colors.orangeAccent),
        title: Text(
          label,
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
        ),
        trailing: const Icon(Icons.arrow_forward_ios, color: Colors.orangeAccent),
        onTap: onTap,
      ),
    );
  }
}