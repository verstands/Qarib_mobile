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
  final LatLng _initialPosition = const LatLng(48.8566, 2.3522);
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
    Service(
      name: "Peintre",
      position: const LatLng(
          48.8576, 2.3622),
      icon: Icons.brush,
    ),
    Service(
      name: "Maçon",
      position: const LatLng(
          48.8676, 2.3733),
      icon: Icons.construction,
    ),
    Service(
      name: "Menuisier",
      position: const LatLng(
          48.8776, 2.3844), 
      icon: Icons.chair,
    ),
    Service(
      name: "Couturier",
      position: const LatLng(48.8876,
          2.3955),
      icon: Icons.dry_cleaning,
    ),
    Service(
      name: "Avocat",
      position: const LatLng(
          48.8976, 2.4066),
      icon: Icons.account_balance,
    ),
    Service(
      name: "Cameraman",
      position: const LatLng(
          48.9076, 2.4177), 
      icon: Icons.videocam,
    ),
  ];

  final TextEditingController _serviceNameController = TextEditingController();

   Set<Marker> get _markers {
    return _services.map((service) {
      return Marker(
        markerId: MarkerId(service.name),
        position: service.position,
        infoWindow: InfoWindow(title: service.name),
        icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueAzure),
      );
    }).toSet();
  }

 @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _moveCameraToFitServices());
  }

  void _onMapCreated(GoogleMapController controller) {
    mapController = controller;
    _moveCameraToFitServices();
  }

  void _moveCameraToFitServices() {
    if (_services.isEmpty) return;

    LatLngBounds bounds = _services.fold(
      LatLngBounds(
        southwest: _services.first.position,
        northeast: _services.first.position,
      ),
      (LatLngBounds current, Service service) {
        return LatLngBounds(
          southwest: LatLng(
            current.southwest.latitude < service.position.latitude
                ? current.southwest.latitude
                : service.position.latitude,
            current.southwest.longitude < service.position.longitude
                ? current.southwest.longitude
                : service.position.longitude,
          ),
          northeast: LatLng(
            current.northeast.latitude > service.position.latitude
                ? current.northeast.latitude
                : service.position.latitude,
            current.northeast.longitude > service.position.longitude
                ? current.northeast.longitude
                : service.position.longitude,
          ),
        );
      },
    );

    mapController.animateCamera(CameraUpdate.newLatLngBounds(bounds, 50));
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
                      onPressed: () =>
                          Navigator.pop(context),
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
              
                  },
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
              0.7,
          child: Padding(
            padding:
                const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
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
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 3, 
                      crossAxisSpacing: 8.0,
                      mainAxisSpacing: 8.0,
                    ),
                    itemCount: _services.length,
                    itemBuilder: (context, index) {
                      final service = _services[index];
                      return GestureDetector(
                        onTap: () {
                          
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
          heightFactor: 0.9,
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
          zoom: 16,
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
            child: const Icon(Icons.favorite), 
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
