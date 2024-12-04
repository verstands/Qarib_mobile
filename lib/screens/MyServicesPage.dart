import 'package:emol/screens/ServicePga.dart';
import 'package:flutter/material.dart';

class MyServicesPage extends StatefulWidget {
  @override
  _MyServicesPageState createState() => _MyServicesPageState();
}

class _MyServicesPageState extends State<MyServicesPage> {
  // Liste des services avec icônes associées
  final Map<String, IconData> services = {
    'Plombier': Icons.build,
    'Electricien': Icons.electrical_services,
    'Jardinier': Icons.grass,
    'Disinsection service': Icons.local_hospital,
    'Peintre': Icons.brush,
    'Maçon': Icons.construction,
    'Menuisier': Icons.chair,
    'Couturier': Icons.dry_cleaning,
    'Avocat': Icons.account_balance,
    'Cameraman': Icons.videocam,
    'Coach de sport': Icons.fitness_center,
    'Femme/homme de ménage': Icons.cleaning_services,
    'Coiffure/Beauté': Icons.person,
    'Cours de soutien': Icons.school,
    'Cuisinier': Icons.restaurant,
    'Réparation mobile': Icons.phone_iphone,
    'Réparation électroménager': Icons.device_thermostat,
    'Réparation PC et Mac': Icons.computer,
    'Mécanicien': Icons.car_repair,
    'Cycliste': Icons.pedal_bike,
    'Electricien (véhicule/trottinette)': Icons.two_wheeler,
    'Distributeur Légumes': Icons.local_grocery_store,
    'Distributeur Fruits': Icons.local_grocery_store,
    'Fast food': Icons.fastfood,
    'Service de déménagement': Icons.transfer_within_a_station,
    'Lavage auto': Icons.local_car_wash,
    'Lavage linge': Icons.local_laundry_service,
    'Coursier/livreur': Icons.local_shipping,
  };

  // Tous les services sont cochés par défaut
  late Set<String> selectedServices = Set.from(services.keys);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.orangeAccent,
        title: const Text(
          "Mes Services Choisis",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Expanded(
              child: ListView.builder(
                itemCount: services.keys.length,
                itemBuilder: (context, index) {
                  String serviceName = services.keys.elementAt(index);
                  IconData serviceIcon = services[serviceName]!;
                  return ServiceCard(
                    name: serviceName,
                    icon: serviceIcon,
                    isSelected: selectedServices.contains(serviceName),
                    onChanged: (isSelected) {
                      setState(() {
                        if (isSelected) {
                          selectedServices.add(serviceName);
                        } else {
                          selectedServices.remove(serviceName);
                        }
                      });
                    },
                  );
                },
              ),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const ServicePageCocher(),
                  ),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.orangeAccent,
                padding:
                    const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
              ),
              child: const Text(
                "Ajouter d'autres services",
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class ServiceCard extends StatelessWidget {
  final String name;
  final IconData icon;
  final bool isSelected;
  final ValueChanged<bool> onChanged;

  const ServiceCard({
    super.key,
    required this.name,
    required this.icon,
    required this.isSelected,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 5,
      margin: const EdgeInsets.symmetric(vertical: 10),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          children: [
            Icon(icon, size: 40, color: Colors.orangeAccent),
            const SizedBox(width: 16),
            Expanded(
              child: Text(
                name,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
            ),
            Checkbox(
              value: isSelected,
              onChanged: (bool? value) {
                onChanged(value ?? false);
              },
              activeColor: Colors.orangeAccent,
            ),
          ],
        ),
      ),
    );
  }
}
