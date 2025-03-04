import 'package:google_maps_flutter/google_maps_flutter.dart';

class MapService {
  static Marker createMarkerFromAgentData(Map<String, dynamic> agent) {
    final latitude = (agent['latitude'] is int) ? (agent['latitude'] as int).toDouble() : agent['latitude'];
    final longitude = (agent['longitude'] is int) ? (agent['longitude'] as int).toDouble() : agent['longitude'];
    final services = (agent['services'] as List<dynamic>?)
        ?.map((service) => service['serviceName'])
        .join(', ') ?? 'Aucun service';
    final agentName = agent['nom'] ?? 'Nom inconnu';

    return Marker(
      markerId: MarkerId(agent['userId']),
      position: LatLng(latitude, longitude),
      infoWindow: InfoWindow(
        title: agentName,
        snippet: 'Services: $services',
      ),
    );
  }
}
