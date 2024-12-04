import 'package:emol/screens/HomePage.dart';
import 'package:emol/utils/Menu.dart';
import 'package:flutter/material.dart';

class ServicePageCocher extends StatefulWidget {
  const ServicePageCocher({super.key});

  @override
  State<ServicePageCocher> createState() => _ServicePageCocherState();
}

class _ServicePageCocherState extends State<ServicePageCocher> {
  // Liste des services avec des icônes et des descriptions
  final List<Map<String, dynamic>> services = [
    {'name': 'Plombier', 'description': 'Réparation et installation de plomberie.', 'icon': Icons.build},
    {'name': 'Electricien', 'description': 'Installation et dépannage électrique.', 'icon': Icons.electrical_services},
    {'name': 'Jardinier', 'description': 'Entretien et création d’espaces verts.', 'icon': Icons.grass},
    {'name': 'Disinsection service', 'description': 'Traitement contre les nuisibles.', 'icon': Icons.local_hospital},
    {'name': 'Peintre', 'description': 'Peinture et rénovation de surfaces.', 'icon': Icons.brush},
    {'name': 'Maçon', 'description': 'Travaux de construction et maçonnerie.', 'icon': Icons.construction},
    {'name': 'Menuisier', 'description': 'Fabrication et réparation de meubles.', 'icon': Icons.chair},
    {'name': 'Couturier', 'description': 'Confection et retouche de vêtements.', 'icon': Icons.dry_cleaning},
    {'name': 'Avocat', 'description': 'Conseils et représentation juridique.', 'icon': Icons.account_balance},
    {'name': 'Cameraman', 'description': 'Captation et montage vidéo.', 'icon': Icons.videocam},
    {'name': 'Coach de sport', 'description': 'Coaching et entraînement personnalisé.', 'icon': Icons.fitness_center},
    {'name': 'Femme/homme de ménage', 'description': 'Entretien ménager pour particuliers et professionnels.', 'icon': Icons.cleaning_services},
    {'name': 'Coiffure/Beauté', 'description': 'Soins de beauté et coiffure à domicile.', 'icon': Icons.person},
    {'name': 'Cours de soutien', 'description': 'Soutien scolaire pour toutes les matières.', 'icon': Icons.school},
    {'name': 'Cuisinier', 'description': 'Chef cuisinier à domicile.', 'icon': Icons.restaurant},
    {'name': 'Réparation mobile', 'description': 'Réparation et dépannage de smartphones.', 'icon': Icons.phone_iphone},
    {'name': 'Réparation électroménager', 'description': 'Dépannage d’appareils électroménagers.', 'icon': Icons.device_thermostat},
    {'name': 'Réparation PC et Mac', 'description': 'Maintenance et réparation informatique.', 'icon': Icons.computer},
    {'name': 'Mécanicien', 'description': 'Réparation et entretien automobile.', 'icon': Icons.car_repair},
    {'name': 'Cycliste', 'description': 'Service de livraison à vélo.', 'icon': Icons.pedal_bike},
    {'name': 'Electricien (véhicule/trottinette)', 'description': 'Dépannage électrique pour véhicules électriques.', 'icon': Icons.two_wheeler},
    {'name': 'Distributeur Légumes', 'description': 'Vente directe de légumes frais.', 'icon': Icons.local_grocery_store},
    {'name': 'Distributeur Fruits', 'description': 'Vente directe de fruits frais.', 'icon': Icons.local_grocery_store},
    {'name': 'Fast food', 'description': 'Livraison rapide de repas.', 'icon': Icons.fastfood},
    {'name': 'Service de déménagement', 'description': 'Aide au déménagement et transport.', 'icon': Icons.transfer_within_a_station},
    {'name': 'Lavage auto', 'description': 'Nettoyage complet de véhicules.', 'icon': Icons.local_car_wash},
    {'name': 'Lavage linge', 'description': 'Service de blanchisserie et pressing.', 'icon': Icons.local_laundry_service},
    {'name': 'Coursier/livreur', 'description': 'Livraison rapide pour particuliers et entreprises.', 'icon': Icons.local_shipping},
  ];

  // Liste des services sélectionnés
  final Map<String, bool> selectedServices = {};

  @override
  void initState() {
    super.initState();
    // Initialiser toutes les cases à cocher comme décochées
    for (var service in services) {
      selectedServices[service['name']] = false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.orange,
        title: const Text("Choisir des services"),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Liste des services avec cases à cocher
            Expanded(
              child: ListView.builder(
                itemCount: services.length,
                itemBuilder: (context, index) {
                  final service = services[index];
                  return Card(
                    margin: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
                    elevation: 4,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: ListTile(
                      leading: Icon(service['icon'], color: Colors.orange),
                      title: Text(service['name']),
                      subtitle: Text(service['description']),
                      trailing: Checkbox(
                        value: selectedServices[service['name']],
                        activeColor: Colors.orange,
                        onChanged: (bool? value) {
                          setState(() {
                            selectedServices[service['name']] = value ?? false;
                          });
                        },
                      ),
                    ),
                  );
                },
              ),
            ),
            // Bouton de validation
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                   Navigator.of(context).pushAndRemoveUntil(
                          MaterialPageRoute(builder: (context) => MenuUtils()),
                          (route) => false);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.orange,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30.0),
                  ),
                  padding: const EdgeInsets.symmetric(vertical: 16.0),
                ),
                child: const Text(
                  "Valider",
                  style: TextStyle(fontSize: 16),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}