import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';

class LocationPage extends StatefulWidget {
  const LocationPage({super.key});

  @override
  State<LocationPage> createState() => _LocationPageState();
}

class _LocationPageState extends State<LocationPage> {
  late GoogleMapController mapController;
  LatLng _currentPosition = const LatLng(0, 0);  // Position initiale

  @override
  void initState() {
    super.initState();
    _getCurrentLocation();
  }

  // Obtenez la position actuelle de l'utilisateur
  Future<void> _getCurrentLocation() async {
    bool serviceEnabled;
    LocationPermission permission;

    // Vérifiez si les services de localisation sont activés
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      // Si les services de localisation ne sont pas activés, demandez à l'utilisateur de les activer
      return;
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      // Si l'utilisateur n'a pas donné l'autorisation d'accéder à la localisation, demandez l'autorisation
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        // Si l'autorisation est toujours refusée, arrêtez l'exécution
        return;
      }
    }

    // Obtenez la position actuelle
    Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);

    setState(() {
      _currentPosition = LatLng(position.latitude, position.longitude);
    });
    mapController.animateCamera(CameraUpdate.newLatLng(_currentPosition));
  }
  void _onMapCreated(GoogleMapController controller) {
    mapController = controller;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Location Page'),
         backgroundColor: Colors.orange,
        centerTitle: true,
        elevation: 4.0,
      ),
      body: GoogleMap(
        onMapCreated: _onMapCreated,
        initialCameraPosition: CameraPosition(
          target: _currentPosition,
          zoom: 15,
        ),
        markers: {
          Marker(
            markerId: const MarkerId('current_position'),
            position: _currentPosition,
            infoWindow: const InfoWindow(title: 'You are here'),
          ),
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _getCurrentLocation,
        tooltip: 'Get Location',
        child: const Icon(Icons.location_searching),
      ),
    );
  }
}
