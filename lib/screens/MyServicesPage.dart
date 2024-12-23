import 'package:emol/constant.dart';
import 'package:emol/models/ServiceByUserModel.dart';
import 'package:emol/models/api_response.dart';
import 'package:emol/screens/LoginPage.dart';
import 'package:emol/screens/ServicePga.dart';
import 'package:emol/services/ServiceService.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MyServicesPage extends StatefulWidget {
  @override
  _MyServicesPageState createState() => _MyServicesPageState();
}

class _MyServicesPageState extends State<MyServicesPage> {
  String? id;
  List<ServiceByUserModel> services = [];
  bool loading = true;
  List<String> selectedServices = []; // Liste pour les services sélectionnés.

  Future<void> _fetchService() async {
    if (id == null) return;

    ApiResponse response = await getServiceByUserAll(id!);
    if (response.erreur == null) {
      setState(() {
        services = response.data as List<ServiceByUserModel>;
        loading = false;
        selectedServices = services
            .map((service) => service.service?.titre ?? '')
            .toList(); 
      });
    } else if (response.erreur == unauthorized) {
      Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (context) => LoginPage()),
        (route) => false,
      );
    } else {
      setState(() {
        loading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('${response.erreur}')),
      );
    }
  }

  Future<void> getId() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      id = prefs.getString('agent_id');
    });
    _fetchService(); 
  }

  @override
  void initState() {
    super.initState();
    getId();
  }

  Future<void> _confirmRemoveService(String serviceName) async {
  bool? confirm = await showDialog<bool>(
    context: context,
    builder: (context) => AlertDialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16.0),
      ),
      backgroundColor: Colors.white,
      title: Row(
        children: [
          Icon(Icons.warning_amber_rounded, color: Colors.orangeAccent, size: 32),
          const SizedBox(width: 8),
          const Text(
            "Confirmation",
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
        ],
      ),
      content: Text(
        "Voulez-vous vraiment retirer ce service : $serviceName ?",
        style: const TextStyle(
          fontSize: 16,
          color: Colors.black54,
        ),
      ),
      actions: [
        TextButton(
          style: TextButton.styleFrom(
            foregroundColor: Colors.black54,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            textStyle: const TextStyle(fontSize: 16),
          ),
          onPressed: () => Navigator.of(context).pop(false),
          child: const Text("Annuler"),
        ),
        ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.orangeAccent,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8.0),
            ),
          ),
          onPressed: () => Navigator.of(context).pop(true),
          child: const Text("Confirmer", style: TextStyle(color: Colors.white),),
        ),
      ],
    ),
  );

  if (confirm == true) {
    setState(() {
      selectedServices.remove(serviceName);
    });
  }
}


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.orangeAccent,
        title: const Text(
          "Mes services choisis",
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Expanded(
              child: loading
              ? const Center(
                  child: CircularProgressIndicator(color: Colors.orange))
              :  ListView.builder(
                      itemCount: services.length,
                      itemBuilder: (context, index) {
                        ServiceByUserModel service = services[index];
                        String serviceName = service.service?.titre ?? '';
                        return ServiceCard(
                          name: serviceName,
                          icon: Icons.check_circle,
                          isSelected: selectedServices.contains(serviceName),
                          onChanged: (isSelected) async {
                            if (isSelected) {
                              setState(() {
                                selectedServices.add(serviceName);
                              });
                            } else {
                              await _confirmRemoveService(serviceName);
                            }
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
