import 'package:flutter/material.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({super.key});

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  // Liste de vrais services avec des icônes
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

  String searchQuery = '';
  final FocusNode _focusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    _focusNode.requestFocus();
  }

  @override
  void dispose() {
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final filteredServices = services.where((service) {
      return service['name']!.toLowerCase().contains(searchQuery.toLowerCase()) ||
             service['description']!.toLowerCase().contains(searchQuery.toLowerCase());
    }).toList();

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.orange,
        title: const Text("Recherche de services"),
        centerTitle: true,
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextField(
              focusNode: _focusNode,
              onChanged: (query) {
                setState(() {
                  searchQuery = query;
                });
              },
              decoration: InputDecoration(
                contentPadding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
                hintText: 'Rechercher un service...',
                prefixIcon: Icon(Icons.search, color: Colors.orange),
                filled: true,
                fillColor: Colors.orange.shade50,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30.0),
                  borderSide: BorderSide.none,
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30.0),
                  borderSide: const BorderSide(color: Colors.orange, width: 2),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30.0),
                  borderSide: BorderSide(color: Colors.orange.shade200, width: 2),
                ),
              ),
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: filteredServices.length,
              itemBuilder: (context, index) {
                final service = filteredServices[index];
                return Card(
                  margin: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
                  elevation: 4,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: ListTile(
                    leading: Icon(service['icon'], color: Colors.orange),
                    title: Text(service['name']!),
                    subtitle: Text(service['description']!),
                    trailing: const Icon(Icons.arrow_forward_ios),
                    onTap: () {
                      // Action lors du clic
                    },
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
