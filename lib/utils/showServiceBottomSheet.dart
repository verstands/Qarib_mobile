import 'package:flutter/material.dart';

// Modèle de service
class Service {
  final String name;
  final IconData icon;

  Service({required this.name, required this.icon});
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  // Exemple de liste de services (à remplacer par vos données réelles)
  final List<Service> _services = [
    Service(name: "Service 1", icon: Icons.star),
    Service(name: "Service 2", icon: Icons.ac_unit),
    Service(name: "Service 3", icon: Icons.access_alarm),
    // Ajoutez d'autres services selon votre besoin
  ];

  void _showServiceBottomSheet() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white.withOpacity(0.9),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(20),
        ),
      ),
      builder: (context) {
        return FractionallySizedBox(
          heightFactor: 0.7,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      "Services disponibles",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.close),
                      onPressed: () {
                        Navigator.pop(context);
                      },
                    ),
                  ],
                ),
                const SizedBox(height: 8.0),
                Expanded(
                  child: GridView.builder(
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 3,
                      crossAxisSpacing: 8.0,
                      mainAxisSpacing: 8.0,
                    ),
                    itemCount: _services.length,
                    itemBuilder: (context, index) {
                      final service = _services[index];
                      return GestureDetector(
                        onTap: () {
                          // Ajoutez une action ici lors du clic sur un service
                        },
                        child: Container(
                          decoration: BoxDecoration(
                            color: Colors.orange.shade100,
                            borderRadius: BorderRadius.circular(12.0),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.1),
                                blurRadius: 5,
                                spreadRadius: 2,
                              ),
                            ],
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(service.icon, size: 40.0, color: Colors.orange),
                              const SizedBox(height: 8.0),
                              Text(
                                service.name,
                                style: const TextStyle(fontWeight: FontWeight.bold),
                                textAlign: TextAlign.center,
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Page d'accueil"),
      ),
      body: Center(
        child: const Text('Bienvenue sur la page d\'accueil'),
      ),
      floatingActionButton: FloatingActionButton(
        heroTag: "addServiceButton",
        backgroundColor: Colors.orange,
        onPressed: _showServiceBottomSheet, // Appeler directement la fonction
        child: const Icon(Icons.favorite),
      ),
    );
  }
}
