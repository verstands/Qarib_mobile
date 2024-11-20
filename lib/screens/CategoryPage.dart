import 'package:emol/screens/ServicePageCatgorie.dart';
import 'package:flutter/material.dart';
import 'package:emol/screens/ServicePga.dart'; // Assurez-vous que cette importation est correcte pour vos besoins

class CategoryPage extends StatelessWidget {
  const CategoryPage({super.key});

  @override
  Widget build(BuildContext context) {
    // Liste d'exemples de catégories
    final List<Map<String, String>> categories = [
      {
        'name': 'Services à la personne',
        'description': 'Aide à domicile, assistance pour les personnes âgées et plus.',
      },
      {
        'name': 'Services professionnels',
        'description': 'Services pour entreprises : comptabilité, marketing, gestion.',
      },
      {
        'name': 'Bien-être',
        'description': 'Yoga, méditation, massages et soins de relaxation.',
      },
      {
        'name': 'Divertissement',
        'description': 'Films, musique, événements et loisirs.',
      },
      {
        'name': 'Voyages',
        'description': 'Planification de voyages, réservations d’hôtel et activités.',
      },
      {
        'name': 'Éducation',
        'description': 'Cours, tutorat et formations diverses.',
      },
    ];

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.orange,
        title: const Text("Catégories"),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Choisissez une catégorie :",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.orange,
              ),
            ),
            const SizedBox(height: 16),

            // Liste des catégories
            Expanded(
              child: ListView.builder(
                itemCount: categories.length,
                itemBuilder: (context, index) {
                  final category = categories[index];
                  return Card(
                    margin: const EdgeInsets.symmetric(vertical: 8.0),
                    child: ListTile(
                      leading: const Icon(Icons.category, color: Colors.orange),
                      title: Text(category['name']!),
                      subtitle: Text(category['description']!),
                      trailing: const Icon(Icons.arrow_forward_ios),
                      onTap: () {
                        // Naviguer vers une page de services basée sur la catégorie
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => ServicePageCategorie(
                              serviceName: category['name']!,
                              serviceDescription: category['description']!,
                            ),
                          ),
                        );
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
