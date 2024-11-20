import 'package:flutter/material.dart';

class ServicePageCategorie extends StatelessWidget {
  final String serviceName;
  final String serviceDescription;

  // Constructeur pour récupérer le nom et la description de la catégorie sélectionnée
  const ServicePageCategorie({
    super.key,
    required this.serviceName,
    required this.serviceDescription,
  });

  @override
  Widget build(BuildContext context) {
    // Liste des services associés à la catégorie (vous pouvez les ajuster selon la catégorie choisie)
    final List<Map<String, String>> services = [
      {
        'name': 'Aide à domicile',
        'description': 'Service d’assistance pour les personnes âgées ou handicapées.',
      },
      {
        'name': 'Repassage à domicile',
        'description': 'Service de repassage pour votre linge, à domicile.',
      },
      {
        'name': 'Accompagnement pour sorties',
        'description': 'Aide pour accompagner les personnes âgées dans leurs sorties.',
      },
    ];

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.orange,
        title: Text(serviceName), // Le nom de la catégorie sélectionnée
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              serviceDescription, // Description de la catégorie
              style: const TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 20),
            const Text(
              "Services disponibles :",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            
            // Liste des services
            Expanded(
              child: ListView.builder(
                itemCount: services.length,
                itemBuilder: (context, index) {
                  final service = services[index];
                  return Card(
                    margin: const EdgeInsets.symmetric(vertical: 8.0),
                    child: ListTile(
                      leading: const Icon(Icons.business, color: Colors.orange),
                      title: Text(service['name']!),
                      subtitle: Text(service['description']!),
                      trailing: const Icon(Icons.arrow_forward_ios),
                      onTap: () {
                        // Ajoutez la logique pour la page du service spécifique si nécessaire
                      },
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
