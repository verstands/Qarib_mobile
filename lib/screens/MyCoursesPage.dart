import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class MyCoursesPage extends StatefulWidget {
  const MyCoursesPage({super.key});

  @override
  _MyCoursesPageState createState() => _MyCoursesPageState();
}

class _MyCoursesPageState extends State<MyCoursesPage> {
  late GoogleMapController mapController;

  // Liste de courses fictives pour l'exemple
  final List<Course> courses = [
    Course(
      id: 1,
      startAddress: '123 Rue A, Paris',
      endAddress: '456 Rue B, Paris',
      status: 'En cours',
      date: '12 Nov 2024 - 14:00',
      amount: '25 \$',
      startLatLng: LatLng(48.8566, 2.3522), // Coordonnées de départ
      endLatLng: LatLng(48.8606, 2.3376),   // Coordonnées d'arrivée
    ),
    Course(
      id: 2,
      startAddress: '789 Rue C, Paris',
      endAddress: '101 Rue D, Paris',
      status: 'Terminée',
      date: '11 Nov 2024 - 10:30',
      amount: '15 \$',
      startLatLng: LatLng(48.8566, 2.3522), // Coordonnées de départ
      endLatLng: LatLng(48.8606, 2.3376),   // Coordonnées d'arrivée
    ),
    Course(
      id: 3,
      startAddress: '222 Rue E, Paris',
      endAddress: '333 Rue F, Paris',
      status: 'Annulée',
      date: '10 Nov 2024 - 16:00',
      amount: '0 \$',
      startLatLng: LatLng(48.8566, 2.3522), // Coordonnées de départ
      endLatLng: LatLng(48.8606, 2.3376),   // Coordonnées d'arrivée
    ),
  ];

  // Méthode pour mettre à jour la caméra de la carte
  void _onMapCreated(GoogleMapController controller) {
    mapController = controller;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.orangeAccent,
        title: const Text("Voir mes courses"),
        centerTitle: true,
        elevation: 10,
      ),
      body: ListView.builder(
        itemCount: courses.length,
        itemBuilder: (context, index) {
          final course = courses[index];
          return Padding(
            padding: const EdgeInsets.all(8.0),
            child: CourseCard(course: course),
          );
        },
      ),
    );
  }
}

class Course {
  final int id;
  final String startAddress;
  final String endAddress;
  final String status;
  final String date;
  final String amount;
  final LatLng startLatLng;
  final LatLng endLatLng;

  Course({
    required this.id,
    required this.startAddress,
    required this.endAddress,
    required this.status,
    required this.date,
    required this.amount,
    required this.startLatLng,
    required this.endLatLng,
  });
}

class CourseCard extends StatelessWidget {
  final Course course;

  const CourseCard({super.key, required this.course});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 8,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      margin: const EdgeInsets.symmetric(vertical: 10),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Course #${course.id}",
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  course.date,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w400,
                    color: Colors.grey,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            Text(
              "Départ: ${course.startAddress}",
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 5),
            Text(
              "Arrivée: ${course.endAddress}",
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Statut: ${course.status}",
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    color: course.status == 'En cours'
                        ? Colors.orangeAccent
                        : course.status == 'Terminée'
                            ? Colors.green
                            : Colors.red,
                  ),
                ),
                Text(
                  course.amount,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.orangeAccent,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            // Affichage de la carte Google Maps pour la course
            Container(
              height: 200,
              child: GoogleMap(
                onMapCreated: (GoogleMapController controller) {
                  // Vous pouvez ajouter des actions lors de la création de la carte
                },
                initialCameraPosition: CameraPosition(
                  target: course.startLatLng,
                  zoom: 14.0,
                ),
                markers: {
                  Marker(
                    markerId: MarkerId('start'),
                    position: course.startLatLng,
                    infoWindow: InfoWindow(title: "Départ", snippet: course.startAddress),
                  ),
                  Marker(
                    markerId: MarkerId('end'),
                    position: course.endLatLng,
                    infoWindow: InfoWindow(title: "Arrivée", snippet: course.endAddress),
                  ),
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
