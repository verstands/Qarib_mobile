import 'package:emol/screens/SearchPage.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late GoogleMapController mapController;

  // Coordonnées initiales (centre de la carte)
  final LatLng _initialPosition = const LatLng(48.8566, 2.3522); // Paris

  // Liste des services avec icônes et coordonnées
  final List<Service> _services = [
    Service(
      name: "Plombier",
      position: const LatLng(48.8566, 2.3522),
      icon: Icons.build,
    ),
    Service(
      name: "Electricien",
      position: const LatLng(48.8666, 2.3333),
      icon: Icons.local_shipping,
    ),
    Service(
      name: "Jardinier",
      position: const LatLng(48.8766, 2.3422),
      icon: Icons.cleaning_services,
    ),
    Service(
      name: "Disinsection service",
      position: const LatLng(48.8866, 2.3522),
      icon: Icons.local_hospital,
    ),
    // Ajout des nouveaux services pour Indrive
    Service(
      name: "Peintre",
      position: const LatLng(
          48.8576, 2.3622), // Exemple de position pour le service moto
      icon: Icons.brush,
    ),
    Service(
      name: "Maçon",
      position: const LatLng(
          48.8676, 2.3733), // Exemple de position pour le service vélo
      icon: Icons.construction,
    ),
    Service(
      name: "Menuisier",
      position: const LatLng(
          48.8776, 2.3844), // Exemple de position pour le service scooter
      icon: Icons.chair,
    ),
    Service(
      name: "Couturier",
      position: const LatLng(48.8876,
          2.3955), // Exemple de position pour le service véhicule électrique
      icon: Icons.dry_cleaning,
    ),
    Service(
      name: "Avocat",
      position: const LatLng(
          48.8976, 2.4066), // Exemple de position pour le service taxi
      icon: Icons.account_balance,
    ),
    Service(
      name: "Cameraman",
      position: const LatLng(
          48.9076, 2.4177), // Exemple de position pour l'assistance routière
      icon: Icons.videocam,
    ),
  ];

  final TextEditingController _serviceNameController = TextEditingController();

  Set<Marker> get _markers {
    return _services.map((service) {
      return Marker(
        markerId: MarkerId(service.name),
        position: service.position,
        infoWindow: InfoWindow(
          title: service.name,
        ),
        icon: BitmapDescriptor.defaultMarkerWithHue(
            BitmapDescriptor.hueAzure), // Couleur de l'icône
      );
    }).toSet();
  }

  void _onMapCreated(GoogleMapController controller) {
    mapController = controller;
  }

  void _showSearchBottomSheet() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: false,
      backgroundColor: Colors.white.withOpacity(0.9), // Légèrement transparent
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(20),
        ),
      ),
      builder: (context) {
        return FractionallySizedBox(
          heightFactor: 0.5, // 50% de la hauteur de l'écran
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      "Rechercher un lieu ou un service",
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    IconButton(
                      onPressed: () =>
                          Navigator.pop(context), // Fermer la feuille
                      icon: const Icon(Icons.close, color: Colors.grey),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                TextField(
                  decoration: InputDecoration(
                    hintText: "Entrez un lieu ou un service",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    prefixIcon: const Icon(Icons.search),
                  ),
                  onChanged: (value) {
                    // Implémentez ici la logique de recherche
                  },
                ),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: () {
                    // Action pour rechercher
                    Navigator.pop(context); // Fermer la feuille
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.orange,
                  ),
                  child: const Text("Rechercher"),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

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
          heightFactor:
              0.7, // Augmente la taille pour permettre plus de contenu
          child: Padding(
            padding:
                const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Titre avec l'icône de fermeture
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

                // Contenu défilant (scrollable)
                Expanded(
                  child: GridView.builder(
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 3, // 3 services par ligne
                      crossAxisSpacing: 8.0,
                      mainAxisSpacing: 8.0,
                    ),
                    itemCount: _services.length,
                    itemBuilder: (context, index) {
                      final service = _services[index];
                      return GestureDetector(
                        onTap: () {
                          // Action lors du clic sur un service
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
                              Icon(service.icon,
                                  size: 40.0, color: Colors.orange),
                              const SizedBox(height: 8.0),
                              Text(
                                service.name,
                                style: const TextStyle(
                                    fontWeight: FontWeight.bold),
                                textAlign: TextAlign.center,
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),

                // Bouton "Voir tout"
                ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const SearchPage(),
                      ),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.orange,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12.0),
                    ),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize
                        .min, // Adapte la taille pour s'ajuster au contenu
                    children: [
                      const Icon(Icons.list,
                          color: Colors.white), // Icône ajoutée
                      const SizedBox(
                          width: 8.0), // Espace entre l'icône et le texte
                      const Text(
                        "Voir tout",
                        style: TextStyle(color: Colors.white),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void _showAllServices() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(20),
        ),
      ),
      builder: (context) {
        return FractionallySizedBox(
          heightFactor: 0.9, // Occupe presque tout l'écran
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      "Tous les services",
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
                Expanded(
                  child: ListView.builder(
                    itemCount: _services.length,
                    itemBuilder: (context, index) {
                      final service = _services[index];
                      return ListTile(
                        leading: Icon(service.icon, color: Colors.orange),
                        title: Text(service.name),
                        onTap: () {
                          // Action lors de la sélection d'un service
                        },
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
        backgroundColor: Colors.orange,
        title: const Text(
          "Kinshasa",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: Stack(
      children: [
        GoogleMap(
          onMapCreated: _onMapCreated,
          initialCameraPosition: CameraPosition(
            target: _initialPosition,
            zoom: 13,
          ),
          markers: _markers,
        ),
        Positioned(
          bottom: 80.0, 
          left: 16.0, 
          child: FloatingActionButton(
            heroTag: "searchButton",
            backgroundColor: Colors.orange,
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const SearchPage(),
                ),
              );
            },
            child: const Icon(Icons.search), 
          ),
        ),
        Positioned(
          bottom: 16.0, 
          left: 16.0, 
          child: FloatingActionButton(
            heroTag: "addServiceButton",
            backgroundColor: Colors.orange,
            onPressed: _showServiceBottomSheet, 
            child: const Icon(Icons.car_repair), 
          ),
        ),
      ],
    ),
  );
  }
}

class Service {
  final String name;
  final LatLng position;
  final IconData icon;

  Service({
    required this.name,
    required this.position,
    required this.icon,
  });
}
