import 'package:emol/constant.dart';
import 'package:emol/models/api_response.dart';
import 'package:emol/models/favoriModel.dart';
import 'package:emol/screens/LoginPage.dart';
import 'package:emol/screens/SearchPage.dart';
import 'package:emol/screens/page2.dart';
import 'package:emol/services/FavoriService.dart';
import 'package:emol/services/UserService.dart';
import 'package:emol/utils/Icon_utils.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'package:web_socket_channel/web_socket_channel.dart';

class HomePage extends StatefulWidget {
  final String? idservicemaps; // Paramètre passé au constructeur de HomePage

  HomePage({Key? key, this.idservicemaps}) : super(key: key); // Constructeur

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late GoogleMapController mapController;
  Set<Marker> _markers = Set();
  late WebSocketChannel channel;
  String ville = '';
  bool loadingfavri = true;
  bool loadingfavridelete = false;
  String? id;
  String? id_agent;
  List<FavoriModel> favories = [];
  String? selected_service_id;

   Future<void> getSelect_Id() async {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      setState(() {
        selected_service_id = prefs.getString('selected_service_id');
      });
    }

 @override
void initState() {
  super.initState();
  getSelect_Id().then((_) {
    _getCurrentUserPosition();
    getVille();
    if (selected_service_id == null) {
      _fetchAgentPositions();  // Si l'ID est null, on appelle cette fonction
    } else {
      _fetchAgentPositionsService();
    }
  });


    // _showCurrentLocation();
    //_startListeningToPosition();

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

     clearSelectedServiceId();
  }

  Future<void> clearSelectedServiceId() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  await prefs.remove('selected_service_id');
  setState(() {
    selected_service_id = null;
  });
}

  Future<void> getVille() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      ville = prefs.getString('agent_ville')!;
    });
  }

  Future<void> _getCurrentUserPosition() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      id_agent = prefs.getString('agent_id');
    });
    try {
      LocationPermission permission = await Geolocator.requestPermission();

      if (permission == LocationPermission.denied ||
          permission == LocationPermission.deniedForever) {
        print('Permission de localisation non accordée');
        return;
      }
      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );
      ApiResponse response = await UpdatePositionUsers(
          position.latitude, position.longitude, id_agent!);
      if (response.erreur == null) {
        // ScaffoldMessenger.of(context).showSnackBar(
        //   SnackBar(content: Text('Bienvenu')),
        // );
      } else if (response.erreur == unauthorized) {
        Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(builder: (context) => LoginPage()),
          (route) => false,
        );
      } else {
        setState(() {
          loadingfavri = false;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('${response.erreur}')),
        );
      }
      print(
          'Position actuelle: Latitude = ${position.latitude}, Longitude = ${position.longitude} ,id = ${id_agent}');
    } catch (e) {
      print('Erreur lors de la récupération de la position: $e');
    }
  }

  Future<void> getId() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      id = prefs.getString('agent_id');
    });
    if (id != null) {
      await _fetchFavorie(id!);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('ID de l’agent introuvable')),
      );
    }
  }

  Future<void> _fetchFavorie(String id) async {
    try {
      ApiResponse response = await getFavorieByUser(id);
      if (response.erreur == null) {
        setState(() {
          favories = response.data as List<FavoriModel>;
          loadingfavri = false;
        });
      } else if (response.erreur == unauthorized) {
        Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(builder: (context) => LoginPage()),
          (route) => false,
        );
      } else {
        setState(() {
          loadingfavri = false;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('${response.erreur}')),
        );
      }
    } catch (e) {
      setState(() {
        loadingfavri = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
            content: Text('Erreur lors de la récupération des favoris : $e')),
      );
    }
  }

  @override
  void dispose() {
    // Fermer la connexion WebSocket lorsque le widget est supprimé
    channel.sink.close();
    super.dispose();
  }

  /// 🔹 Récupère les positions des agents avec leurs services depuis l'API
  Future<void> _fetchAgentPositions() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      id_agent = prefs.getString('agent_id');
    });

    print('idddddddd ${id_agent}');
    final response = await http.get(Uri.parse(
        'http://185.182.186.58:4005/api/agent/positions/positions/${id_agent}'));

    if (response.statusCode == 200) {
      print('Réponse de l\'API: ${response.body}');

      final data = json.decode(response.body);
      if (data is List) {
        setState(() {
          _markers = data.map((agent) {
            final latitude =
                double.tryParse(agent['latitude'].toString()) ?? 0.0;
            final longitude =
                double.tryParse(agent['longitude'].toString()) ?? 0.0;

            // Vérifier si l'agent a des services et les formater
            final services = (agent['services'] as List<dynamic>?)
                    ?.map((service) => service['serviceName'])
                    .join(', ') ??
                'Aucun service';
            print('dddddddd $_markers');
            // Assurer que le nom de l'agent n'est pas null
            final agentName = agent['nom'] ?? 'Nom inconnu';

            return Marker(
              markerId: MarkerId(agent['userId']),
              position: LatLng(latitude, longitude),
              infoWindow: InfoWindow(
                title: agentName,
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

  Future<void> _fetchAgentPositionsService() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      id_agent = prefs.getString('agent_id');
    });
    final response = await http.get(Uri.parse(
        'http://185.182.186.58:4005/api/agent/positions/positions/${id_agent}/${selected_service_id}'));

    if (response.statusCode == 200) {
      print('Réponse de l\'API: ${response.body}');

      final data = json.decode(response.body);
      if (data is List) {
        setState(() {
          _markers = data.map((agent) {
            final latitude =
                double.tryParse(agent['latitude'].toString()) ?? 0.0;
            final longitude =
                double.tryParse(agent['longitude'].toString()) ?? 0.0;

            // Vérifier si l'agent a des services et les formater
            final services = (agent['services'] as List<dynamic>?)
                    ?.map((service) => service['serviceName'])
                    .join(', ') ??
                'Aucun service';
            print('dddddddd $_markers');
            // Assurer que le nom de l'agent n'est pas null
            final agentName = agent['nom'] ?? 'Nom inconnu';

            return Marker(
              markerId: MarkerId(agent['userId']),
              position: LatLng(latitude, longitude),
              infoWindow: InfoWindow(
                title: agentName,
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

  Future<BitmapDescriptor> _getCustomMarker() async {
    return await BitmapDescriptor.fromAssetImage(
      ImageConfiguration(size: Size(48, 48)), // Taille de l'icône
      'assets/logo/logo.jpeg', // Chemin de l’image dans les assets
    );
  }

  /// 🔹 Affiche les détails de l'agent dans un Dialog
 void _showAgentDetails(String name, String services) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      List<String> serviceList = services.split(', ');

      return Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Titre avec icône et photo de profil
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        CircleAvatar(
                          backgroundImage: AssetImage('assets/agent_profile.jpg'),
                          radius: 24,
                        ),
                        SizedBox(width: 12),
                        Text(
                          '',
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: Colors.orange,
                          ),
                        ),
                      ],
                    ),
                    IconButton(
                      icon: Icon(Icons.close, color: Colors.orange, size: 28),
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                    ),
                  ],
                ),
                SizedBox(height: 16),

                // Étoiles d'évaluation
                Row(
                  children: [
                    Icon(Icons.star, color: Colors.orange, size: 24),
                    Icon(Icons.star, color: Colors.orange, size: 24),
                    Icon(Icons.star, color: Colors.orange, size: 24),
                    Icon(Icons.star_border, color: Colors.orange, size: 24),
                    Icon(Icons.star_border, color: Colors.orange, size: 24),
                  ],
                ),
                SizedBox(height: 16),

                // Section des services avec icône
                Row(
                  children: [
                    Icon(Icons.business, color: Colors.orange, size: 24),
                    SizedBox(width: 12),
                    Text(
                      'Services associés:',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                        color: Colors.grey[700],
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 12),

                // Afficher les services avec des cartes
                Container(
                  padding: EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    color: Colors.orange[50],
                  ),
                  child: Column(
                    children: serviceList.map((service) {
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 12.0),
                        child: Row(
                          children: [
                            Icon(getIconFromString(service),
                                color: Colors.orange, size: 22),
                            SizedBox(width: 12),
                            Text(
                              service,
                              style: TextStyle(
                                fontSize: 16,
                                color: Colors.black,
                              ),
                            ),
                          ],
                        ),
                      );
                    }).toList(),
                  ),
                ),
                SizedBox(height: 24),

                // Carrousel d'images de l'agent avec chevauchement
                Container(
                  height: 200,
                  child: PageView(
                    controller: PageController(viewportFraction: 0.8), // Chevauchement des images
                    children: [
                      GestureDetector(
                        onTap: () {
                          _showFullImageDialog('assets/logo/s.png');
                        },
                        child: Image.asset('assets/logo/s.png', fit: BoxFit.cover),
                      ),
                      GestureDetector(
                        onTap: () {
                          _showFullImageDialog('assets/logo/logo.jpeg');
                        },
                        child: Image.asset('assets/logo/logo.jpeg', fit: BoxFit.cover),
                      ),
                      GestureDetector(
                        onTap: () {
                          _showFullImageDialog('assets/logo/logo.jpeg');
                        },
                        child: Image.asset('assets/logo/logo.jpeg', fit: BoxFit.cover),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 24),

                // Titre de la description
                Text(
                  'Description',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    color: Colors.grey[700],
                  ),
                ),
                SizedBox(height: 10),

                // Exemple de description
                Text(
                  'L\'agent X est un expert dans son domaine, avec plus de 10 ans d\'expérience',
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.grey[700],
                  ),
                ),
                SizedBox(height: 10),

                // Bouton "Faire une demande"
                Align(
                  alignment: Alignment.centerRight,
                  child: ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.orange,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      padding:
                          EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                    ),
                    icon: Icon(Icons.request_page, color: Colors.white),
                    label: Text(
                      'Faire une demande',
                      style: TextStyle(color: Colors.white, fontSize: 16),
                    ),
                    onPressed: () {
                      print("Faire une demande");
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    },
  );
}

void _showFullImageDialog(String imagePath) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        child: Container(
          width: double.infinity,
          child: Image.asset(imagePath, fit: BoxFit.cover),
        ),
      );
    },
  );
}



  /// 🔹 Met à jour la position d'un agent et affiche ses services
  void _updateAgentPosition(String userId, double latitude, double longitude,
      {List<dynamic>? services, String? name}) async {
    final markerId = MarkerId(userId);
    print(
        'Mise à jour de la position de $userId: lat=$latitude, lon=$longitude');

    final existingMarker = _markers.firstWhere(
      (marker) => marker.markerId == markerId,
      orElse: () =>
          Marker(markerId: markerId, position: LatLng(latitude, longitude)),
    );

    // Formater les services reçus
    final serviceText = services != null
        ? services.map((s) => s['serviceName']).join(', ')
        : 'Aucun service';

    final customIcon = await _getCustomMarker();
    setState(() {
      _markers.remove(existingMarker);
      _markers.add(Marker(
        markerId: markerId,
        position: LatLng(latitude, longitude),
        icon: customIcon,
        infoWindow: InfoWindow(
          title: name ??
              'Nom Inconnu', // Utiliser le nom transmis ou 'Nom Inconnu'
          snippet: 'Services: $serviceText',
        ),
      ));
    });
  }

  Future<void> _deleteFavorie(String id) async {
    try {
      ApiResponse response = await deleteFavorieService(id);
      if (response.erreur == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('okok')),
        );
        _fetchFavorie(id);
      } else if (response.erreur == unauthorized) {
        Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(builder: (context) => LoginPage()),
          (route) => false,
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('${response.erreur}')),
        );
      }
    } catch (e) {
      setState(() {
        loadingfavri = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
            content: Text('Erreur lors de la récupération des favoris : $e')),
      );
    }
  }

  Future<void> _showCurrentLocation() async {
    bool serviceEnabled;
    LocationPermission permission;
    // _startListeningToPosition();
    // Vérifier si le service de localisation est activé
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Activez les services de localisation.')),
      );
      return;
    }

    // Vérifier les permissions
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Permission de localisation refusée.')),
        );
        return;
      }
    }

    if (permission == LocationPermission.deniedForever) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Permission de localisation bloquée.')),
      );
      return;
    }

    // Obtenir la position actuelle
    Position position = await Geolocator.getCurrentPosition();
    LatLng currentPosition = LatLng(position.latitude, position.longitude);

    // Centrer la carte sur la position actuelle
    mapController?.animateCamera(
      CameraUpdate.newLatLngZoom(currentPosition, 16),
    );

    // Ajouter un marqueur pour la position actuelle
    setState(() {
      _markers.add(
        Marker(
          markerId: const MarkerId("current_location"),
          position: currentPosition,
          infoWindow: const InfoWindow(title: "Ma position actuelle"),
          icon: BitmapDescriptor.defaultMarkerWithHue(
              BitmapDescriptor.hueBlue), // Icône bleue prédéfinie
        ),
      );
    });
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
          heightFactor: 0.6,
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      "Tous mes favoris",
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
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
                const Divider(), // Ligne de séparation pour un meilleur design
                Expanded(
                  child: loadingfavri
                      ? const Center(
                          child: CircularProgressIndicator(),
                        )
                      : favories.isEmpty
                          ? const Center(
                              child: Text(
                                "Aucun favori trouvé.",
                                style: TextStyle(
                                  fontSize: 16,
                                  color: Colors.grey,
                                ),
                              ),
                            )
                          : GridView.builder(
                              gridDelegate:
                                  const SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 3,
                                crossAxisSpacing: 8.0,
                                mainAxisSpacing: 8.0,
                                childAspectRatio: 0.75,
                              ),
                              itemCount: favories.length,
                              itemBuilder: (context, index) {
                                final favori = favories[index];
                                return Card(
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12.0),
                                  ),
                                  elevation: 6,
                                  child: Stack(
                                    children: [
                                      Center(
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Icon(
                                              getIconFromString(
                                                  favori.service?.icon ?? ''),
                                              color: Colors.orange,
                                              size: 36,
                                            ),
                                            const SizedBox(height: 10),
                                            Text(
                                              favori.service?.titre
                                                          ?.isNotEmpty ==
                                                      true
                                                  ? favori.service!.titre!
                                                  : "",
                                              style: const TextStyle(
                                                fontSize: 14,
                                                fontWeight: FontWeight.w500,
                                                color: Colors.black87,
                                              ),
                                              textAlign: TextAlign.center,
                                            ),
                                          ],
                                        ),
                                      ),
                                      Positioned(
                                        top: 6,
                                        right: 6,
                                        child: GestureDetector(
                                          onTap: () {
                                            _deleteFavorie(favori.id!);
                                          },
                                          child: const CircleAvatar(
                                            radius: 12,
                                            backgroundColor: Colors.red,
                                            child: Icon(
                                              Icons.close,
                                              size: 16,
                                              color: Colors.white,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
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

  void _startListeningToPosition() {
    Geolocator.getPositionStream(
      locationSettings: LocationSettings(
        accuracy: LocationAccuracy.high,
        distanceFilter: 50,
      ),
    ).listen((Position position) {
      LatLng newPosition = LatLng(position.latitude, position.longitude);

      setState(() {
        _markers.removeWhere(
            (marker) => marker.markerId.value == "current_location");
        _markers.add(Marker(
          markerId: const MarkerId("current_location"),
          position: newPosition,
          infoWindow: const InfoWindow(title: "Ma position actuelle"),
          icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueBlue),
        ));
      });

      // Centrer la carte sur la nouvelle position
      mapController?.animateCamera(
        CameraUpdate.newLatLngZoom(newPosition, 1.0),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.orange,
        title: Text(
          ville,
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
        ),
        centerTitle: true,
      ),
      body: Stack(
        // Ajout d'un Stack pour superposer les éléments
        children: [
          GoogleMap(
            initialCameraPosition: CameraPosition(
              target: LatLng(0.0, 0.0), // Coordonnées de départ
              zoom: 3.0,
            ),
            markers: _markers,
            onMapCreated: (GoogleMapController controller) {
              mapController = controller;
            },
          ),
          Positioned(
            bottom: 16.0,
            left: 16.0,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                FloatingActionButton(
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
                  child: const Icon(
                    Icons.search,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 16.0),
                FloatingActionButton(
                  heroTag: "addServiceButton",
                  backgroundColor: Colors.orange,
                  onPressed: () async {
                    // Navigator.push(
                    //   context,
                    //   MaterialPageRoute(
                    //     builder: (context) => MapScreen(),
                    //   ),
                    // );
                    await getId();
                    _showAllServices();
                  },
                  child: const Icon(
                    Icons.favorite,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 16.0),
                FloatingActionButton(
                  heroTag: "currentLocationButton",
                  backgroundColor: Colors.orange,
                  onPressed: _showCurrentLocation,
                  child: const Icon(
                    Icons.my_location,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
