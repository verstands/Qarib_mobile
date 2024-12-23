import 'dart:typed_data';
import 'dart:ui';

import 'package:emol/constant.dart';
import 'package:emol/models/ServiceByUserModel.dart';
import 'package:emol/models/api_response.dart';
import 'package:emol/models/favoriModel.dart';
import 'package:emol/screens/LoginPage.dart';
import 'package:emol/screens/SearchPage.dart';
import 'package:emol/screens/page2.dart';
import 'package:emol/services/FavoriService.dart';
import 'package:emol/services/ServiceService.dart';
import 'package:emol/sockets/socket_service.dart';
import 'package:emol/utils/Icon_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late GoogleMapController mapController;
  final LatLng _initialPosition = const LatLng(48.8566, 2.3522);
  List<ServiceByUserModel> _services = [];
  final TextEditingController _serviceNameController = TextEditingController();
  final SocketService _socketService = SocketService();
  List<Map<String, dynamic>> userPositions = [];
  String ville = '';
  List<FavoriModel> favories = [];
  bool loadingfavri = true;
  String? id;

  Future<void> getVille() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      ville = prefs.getString('agent_ville')!;
    });
  }

  Set<Marker> _markers = {};

  @override
  void initState() {
    super.initState();
    getVille();
    _socketService.initializeSocket();
    _socketService.socket.on('userPositionUpdate', (data) {
      setState(() {
        userPositions.add({
          'userId': data['userId'],
          'latitude': data['latitude'],
          'longitude': data['longitude'],
        });
      });
    });
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _moveCameraToFitServices();
      _showCurrentLocation();
      _addServiceMarkers(); // Ajouter les marqueurs avec icônes
      _startListeningToPosition(); // Commencer à écouter la position
    });
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
    print('okkkkkkkkkkkkkkksss');

    try {
      ApiResponse response = await getFavorieByUser(id);
      if (response.erreur == null) {
        setState(() {
          favories = response.data as List<FavoriModel>;
          loadingfavri = false;
        });
        print('okkkkkkkkkkkkkkk');
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
    _socketService.disconnectSocket();
    super.dispose();
  }

  Future<void> _addServiceMarkers() async {
    Set<Marker> newMarkers = {};
    for (var service in _services) {
      final icon = await _getMarkerIcon(
          Colors.orange); // Icône personnalisée avec couleur orange
      newMarkers.add(Marker(
        markerId: MarkerId(service.id ?? ""),
        infoWindow: InfoWindow(title: service.user?.noms),
        icon:
            BitmapDescriptor.fromBytes(icon), // Utilisation de l'icône générée
      ));
    }
    setState(() {
      _markers = newMarkers;
    });
  }

  void _onMapCreated(GoogleMapController controller) {
    mapController = controller;
    _moveCameraToFitServices();
  }

  void _moveCameraToFitServices() {
    if (_markers.isEmpty) return;

    LatLngBounds bounds = _markers.fold(
      LatLngBounds(
        southwest: _markers.first.position,
        northeast: _markers.first.position,
      ),
      (LatLngBounds current, Marker marker) {
        return LatLngBounds(
          southwest: LatLng(
            current.southwest.latitude < marker.position.latitude
                ? current.southwest.latitude
                : marker.position.latitude,
            current.southwest.longitude < marker.position.longitude
                ? current.southwest.longitude
                : marker.position.longitude,
          ),
          northeast: LatLng(
            current.northeast.latitude > marker.position.latitude
                ? current.northeast.latitude
                : marker.position.latitude,
            current.northeast.longitude > marker.position.longitude
                ? current.northeast.longitude
                : marker.position.longitude,
          ),
        );
      },
    );

    setState(() {
      mapController.animateCamera(CameraUpdate.newLatLngBounds(bounds, 50));
    });
  }

  Future<Uint8List> _getMarkerIcon(Color color) async {
    final Icon icon =
        Icon(Icons.circle, color: color, size: 40.0); // Icône ronde
    final RenderRepaintBoundary boundary = RenderRepaintBoundary();
    final repaintWidget = RepaintBoundary(
      child: Icon(icon.icon, color: color, size: 40.0),
    );

    boundary.paint(context as PaintingContext, Offset.zero);
    final image = await boundary.toImage(pixelRatio: 3.0);
    final byteData = await image.toByteData(format: ImageByteFormat.png);
    return byteData!.buffer.asUint8List();
  }

  void _startListeningToPosition() {
    Geolocator.getPositionStream(
      locationSettings: LocationSettings(
        accuracy: LocationAccuracy.high,
        distanceFilter: 16,
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
        CameraUpdate.newLatLngZoom(newPosition, 16),
      );
    });
  }

  Future<void> _showCurrentLocation() async {
    bool serviceEnabled;
    LocationPermission permission;

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

  void _showSearchBottomSheet() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: false,
      backgroundColor: Colors.white.withOpacity(0.9),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(20),
        ),
      ),
      builder: (context) {
        return FractionallySizedBox(
          heightFactor: 0.5,
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
                      onPressed: () => Navigator.pop(context),
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
                    prefixIcon: const Icon(
                      Icons.search,
                      color: Colors.white,
                    ),
                  ),
                  onChanged: (value) {},
                ),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context);
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
                                                : "Titre indisponible",
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
                                          // Action pour retirer le favori
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
        children: [
          GoogleMap(
            onMapCreated: _onMapCreated,
            initialCameraPosition: CameraPosition(
              target: _initialPosition,
              zoom: 16,
            ),
            markers: _markers,
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
                    //     builder: (context) =>  MapWithWebSocket(),
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
