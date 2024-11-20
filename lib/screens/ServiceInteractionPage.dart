import 'package:flutter/material.dart';

class ServiceInteractionPage extends StatefulWidget {
  final String serviceName;

  const ServiceInteractionPage({super.key, required this.serviceName});

  @override
  State<ServiceInteractionPage> createState() => _ServiceInteractionPageState();
}

class _ServiceInteractionPageState extends State<ServiceInteractionPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.orange,
        title: Text("Interagir avec ${widget.serviceName}"),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Titre principal
              Text(
                "Bienvenue sur la page d'interaction pour ${widget.serviceName}.",
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.orange,
                ),
              ),
              const SizedBox(height: 16),
              
              // Section des actions disponibles
              const Text(
                "Options disponibles :",
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Colors.black87,
                ),
              ),
              const SizedBox(height: 16),

              // Boutons d'actions avec des noms plus appropriés
              _buildActionButton(context, "Demander de l'aide", Icons.help_outline),
              _buildActionButton(context, "Configurer le service", Icons.settings),
              _buildActionButton(context, "Voir les informations", Icons.info),
              
              const SizedBox(height: 16),
              const Divider(),
              
              // Informations supplémentaires
              const Text(
                "Informations supplémentaires :",
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Colors.black87,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                "Ici, vous pouvez ajouter des détails concernant l'interaction avec ${widget.serviceName}, comme des instructions ou des informations complémentaires.",
                style: const TextStyle(fontSize: 14, color: Colors.black54),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Méthode pour créer des boutons d'actions avec espace à gauche et à droite
  Widget _buildActionButton(BuildContext context, String actionLabel, IconData icon) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: ElevatedButton.icon(
        onPressed: () {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text("$actionLabel effectuée !")),
          );
        },
        icon: Icon(icon),
        label: Text(actionLabel),
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.orange,
          padding: const EdgeInsets.symmetric(vertical: 14.0, horizontal: 20.0), // Espace gauche et droit ajouté ici
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8.0),
          ),
        ),
      ),
    );
  }
}
