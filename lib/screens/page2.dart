import 'dart:convert'; // Pour traiter les données JSON
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

class MapWithWebSocket extends StatefulWidget {
  @override
  _MapWithWebSocketState createState() => _MapWithWebSocketState();
}

class _MapWithWebSocketState extends State<MapWithWebSocket> {
  final WebSocketChannel channel =
    WebSocketChannel.connect(Uri.parse('ws://185.182.186.58:4006'));
  GoogleMapController? _mapController;
  final Map<String, Marker> _markers = {};

  @override
  void initState() {
    super.initState();
    print('Initialisation du composant...');

    // Écoute des messages WebSocket
    channel.stream.listen(
      (message) {
        print('Message reçu du WebSocket : $message');
        _handleWebSocketMessage(message);
      },
      onError: (error) {
        print('Erreur WebSocket : $error');
      },
      onDone: () {
        print('WebSocket fermé.');
      }, 
    );

    print('Écoute du WebSocket configurée.');
  }

  void _handleWebSocketMessage(String message) {
    try {
      print('Traitement du message WebSocket...');
      final data = jsonDecode(message);
      print('Données décodées : $data');

      final String userId = data['userId'];
      final double latitude = data['latitude'];
      final double longitude = data['longitude'];
      print('ID utilisateur : $userId, Latitude : $latitude, Longitude : $longitude');

      // Mise à jour des marqueurs
      setState(() {
        _markers[userId] = Marker(
          markerId: MarkerId(userId),
          position: LatLng(latitude, longitude),
          infoWindow: InfoWindow(title: 'Utilisateur $userId'),
          icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueBlue), // Utilisez une couleur par défaut
        );
      });
      print('Marqueur ajouté pour l\'utilisateur $userId.');
      print('Nombre de marqueurs : ${_markers.length}'); // Log du nombre de marqueurs
    } catch (e) {
      print('Erreur lors du traitement du message WebSocket : $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    print('Construction de l\'interface utilisateur...');
    return Scaffold(
      appBar: AppBar(
        title: Text('Mises à jour des positions'),
      ),
      body: GoogleMap(
        initialCameraPosition: CameraPosition(
          target: LatLng(0, 0), // Vous pouvez changer cela si nécessaire
          zoom: 2,
        ),
        markers: _markers.values.toSet(),
        onMapCreated: (controller) {
          print('Google Map créée.');
          _mapController = controller;
        },
      ),
    );
  }

  @override
  void dispose() {
    print('Fermeture de la connexion WebSocket...');
    channel.sink.close(); // Ferme la connexion WebSocket
    super.dispose();
  }
}