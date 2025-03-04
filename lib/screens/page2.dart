import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:web_socket_channel/web_socket_channel.dart';

class MapScreen extends StatefulWidget {
  MapScreen(String? id);

  @override
  _MapScreenState createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  late GoogleMapController mapController;
  Set<Marker> _markers = Set();
  late WebSocketChannel channel;

  @override
  void initState() {
    super.initState();
    _fetchAgentPositions();

    // Connexion WebSocket pour recevoir les mises à jour de position
    channel = WebSocketChannel.connect(
      Uri.parse('ws://185.182.186.58:4005'),
    );

    // Écoute des mises à jour via WebSocket
    channel.stream.listen(
      (message) {
        print('Message reçu via WebSocket: $message');
        final data = json.decode(message);

        // Vérification de la structure des données
        if (data is Map &&
            data.containsKey('userId') &&
            data.containsKey('latitude') &&
            data.containsKey('longitude') &&
            data.containsKey('nom')) {
          final latitude = (data['latitude'] is int)
              ? (data['latitude'] as int).toDouble()
              : data['latitude'];
          final longitude = (data['longitude'] is int)
              ? (data['longitude'] as int).toDouble()
              : data['longitude'];
          final services = data['services'] ?? []; // Récupérer les services
          final name = data['noms']; // Ajouter le nom ici

          setState(() {
            _updateAgentPosition(data['userId'], latitude, longitude,
                services: services, name: name); // Passer le nom ici
          });
        } else {
          print('Données WebSocket mal formatées');
        }
      },
      onError: (error) {
        print('Erreur WebSocket: $error');
      },
      onDone: () {
        print('Connexion WebSocket fermée');
      },
    );
  }

  @override
  void dispose() {
    // Fermer la connexion WebSocket lorsque le widget est supprimé
    channel.sink.close();
    super.dispose();
  }

  /// 🔹 Récupère les positions des agents avec leurs services depuis l'API
  Future<void> _fetchAgentPositions() async {
    final response = await http.get(
        Uri.parse('http://185.182.186.58:4005/api/agent/positions/positions'));

    if (response.statusCode == 200) {
      print('Réponse de l\'API: ${response.body}');

      final data = json.decode(response.body);
      if (data is List) {
        setState(() {
          _markers = data.map((agent) {
            final latitude = (agent['latitude'] is int)
                ? (agent['latitude'] as int).toDouble()
                : agent['latitude'];
            final longitude = (agent['longitude'] is int)
                ? (agent['longitude'] as int).toDouble()
                : agent['longitude'];

            // Vérifier si l'agent a des services et les formater
            final services = (agent['services'] as List<dynamic>?)
                    ?.map((service) => service['serviceName'])
                    .join(', ') ??
                'Aucun service';

            // Assurer que le nom de l'agent n'est pas null
            final agentName = agent['nom'] ?? 'Nom inconnu';

            return Marker(
              markerId: MarkerId(agent['userId']),
              position: LatLng(latitude, longitude),
              infoWindow: InfoWindow(
                title: agentName, // Nom de l'agent
                snippet: 'Services: $services', // Liste des services
              ),
              onTap: () {
                // Affiche un Dialog avec les services de l'agent
                _showAgentDetails(agentName, services);
              },
            );
          }).toSet();
        });
      } else {
        print('Erreur: Données mal formatées, attendait une liste.');
      }
    } else {
      throw Exception('Échec de la récupération des positions');
    }
  }

  /// 🔹 Affiche les détails de l'agent dans un Dialog
  void _showAgentDetails(String name, String services) {
    showDialog(
      context: context, // Utiliser le contexte actuel
      builder: (BuildContext context) {
        // Séparer les services en une liste, en cas de retour à la ligne
        List<String> serviceList = services.split(', ');

        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius:
                BorderRadius.circular(16), // Coins arrondis plus marqués
          ),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Titre avec icône
                Row(
                  children: [
                    Icon(Icons.person,
                        color: Colors.blueAccent,
                        size: 28), // Icône de la personne
                    SizedBox(width: 10),
                    Text(
                      name,
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: Colors.blueAccent, // Couleur du titre
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 12),
                // Section des services avec icône
                Row(
                  children: [
                    Icon(Icons.business,
                        color: Colors.green, size: 22), // Icône de service
                    SizedBox(width: 10),
                    Text(
                      'Services associés:',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: Colors.grey[700],
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 8),
                // Afficher les services un par un avec une icône pour chaque service
                Column(
                  children: serviceList.map((service) {
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 8.0),
                      child: Row(
                        children: [
                          // Icône spécifique selon le service
                          Icon(_getServiceIcon(service),
                              color: Colors.blueAccent,
                              size: 20), // Icône dynamique
                          SizedBox(width: 10),
                          Text(
                            service,
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.black,
                            ),
                          ),
                        ],
                      ),
                    );
                  }).toList(),
                ),
                SizedBox(height: 20),
                // Bouton de fermeture avec icône
                Align(
                  alignment: Alignment.centerRight,
                  child: ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blueAccent, // Couleur du bouton
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(
                            12), // Coins arrondis du bouton
                      ),
                    ),
                    icon: Icon(Icons.close,
                        color: Colors.white), // Icône de fermeture
                    label: Text(
                      'Fermer',
                      style: TextStyle(color: Colors.white),
                    ),
                    onPressed: () {
                      Navigator.of(context).pop();
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

  IconData _getServiceIcon(String service) {
    switch (service) {
      case 'Service 1':
        return Icons.access_alarm; // Exemple d'icône pour un service spécifique
      case 'Service 2':
        return Icons.account_balance; // Exemple d'icône pour un autre service
      case 'Service 3':
        return Icons.cake; // Exemple d'icône pour un autre service
      default:
        return Icons
            .help_outline; // Icône par défaut si le service ne correspond pas
    }
  }

   Future<BitmapDescriptor> _getCustomMarker() async {
    return await BitmapDescriptor.fromAssetImage(
      const ImageConfiguration(size: Size(48, 48)), // Taille de l'icône
      'assets/image/logo.jpeg', // Chemin de l’image dans les assets
    );
  }

  /// 🔹 Met à jour la position d'un agent et affiche ses services
  void _updateAgentPosition(String userId, double latitude, double longitude,
    {List<dynamic>? services, String? name}) async {
  final markerId = MarkerId(userId);
  print('Mise à jour de la position de $userId: lat=$latitude, lon=$longitude');

  final existingMarker = _markers.firstWhere(
    (marker) => marker.markerId == markerId,
    orElse: () =>
        Marker(markerId: markerId, position: LatLng(latitude, longitude)),
  );

  final serviceText = services != null
      ? services.map((s) => s['serviceName']).join(', ')
      : 'Aucun service';

  try {
    // Charger l'icône personnalisée
    final customIcon = await _getCustomMarker();

    setState(() {
      _markers.add(Marker(
        markerId: markerId,
        position: LatLng(latitude, longitude),
        icon: customIcon,
        infoWindow: InfoWindow(
          title: name ?? 'Nom Inconnu',
          snippet: 'Services: ${services?.join(', ') ?? 'Aucun service'}',
        ),
      ));
    });
  } catch (e) {
    print("Erreur lors du chargement de l'icône: $e");
  }
}


 

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Carte des agents')),
      body: GoogleMap(
        initialCameraPosition: CameraPosition(
          target: LatLng(0.0, 0.0), // Coordonnées de départ
          zoom: 2.0,
        ),
        markers: _markers,
        onMapCreated: (GoogleMapController controller) {
          mapController = controller;
        },
      ),
    );
  }
}
