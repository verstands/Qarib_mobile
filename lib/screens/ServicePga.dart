import 'package:emol/services/UserService.dart';
import 'package:flutter/material.dart';
import 'package:emol/models/Servicemodel.dart';
import 'package:emol/models/api_response.dart';
import 'package:emol/screens/LoginPage.dart';
import 'package:emol/services/ServiceService.dart';
import 'package:emol/utils/Icon_utils.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ServicePageCocher extends StatefulWidget {
  const ServicePageCocher({super.key});

  @override
  State<ServicePageCocher> createState() => _ServicePageCocherState();
}

class _ServicePageCocherState extends State<ServicePageCocher> {
  final Map<String, bool> selectedServices = {};
  List<ServiceModel> services = [];
  bool _isLoading = false;
  bool loading = true;
  String? id;

  Future<void> _fetchService() async {
    ApiResponse response = await getServiceAll();
    if (response.erreur == null) {
      setState(() {
        services = response.data as List<ServiceModel>;
        loading = false;
      });
    } else if (response.erreur == 'unauthorized') {
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

  void _saveUserService(List<String?> selectedIds) async {
  setState(() {
    _isLoading = true;
  });

  try {
    // Filtrer les IDs non null
    final filteredIds = selectedIds.whereType<String>().toList();

    if (filteredIds.isEmpty) {
      EasyLoading.showInfo("Aucun service sélectionné.");
      return;
    }

    for (String serviceId in filteredIds) {
      print('Envoi : id_user=$id, id_service=$serviceId'); // Log d'envoi
      ApiResponse<Map<String, dynamic>> response =
          await SaveUserServices(id ?? "", serviceId);

      if (response.erreur != null) {
        print('Erreur lors de la sauvegarde : ${response.erreur}'); // Log d'erreur
        EasyLoading.showError(
            "Erreur lors de la sauvegarde du service $serviceId: ${response.erreur}");
        return; // Arrêtez si une erreur se produit
      } else {
        print('Service $serviceId sauvegardé avec succès.'); // Log de succès
      }
    }

    EasyLoading.showSuccess("Tous les services ont été sauvegardés.");
  } catch (e) {
    print('Erreur inattendue : $e'); // Log d'exception
    EasyLoading.showError("Erreur inattendue : $e");
  } finally {
    setState(() {
      _isLoading = false;
    });
  }
}


  Future<void> getid() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      id = prefs.getString('agent_id');
    });
  }

  @override
  void initState() {
    super.initState();
    _fetchService();
    getid();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.orange,
        title: const Text(
          "Choisir des services",
          style: TextStyle(color: Colors.white),
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            if (loading)
              const Center(
                child: CircularProgressIndicator(color: Colors.orange),
              )
            else
              Expanded(
                child: ListView.builder(
                  itemCount: services.length,
                  itemBuilder: (context, index) {
                    final service = services[index];
                    return Card(
                      margin: const EdgeInsets.symmetric(
                          horizontal: 8.0, vertical: 4.0),
                      elevation: 4,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: ListTile(
                        leading: CircleAvatar(
                          backgroundColor: Colors.orange.shade100,
                          child: Icon(
                            getIconFromString(service.icon ?? ''),
                            color: Colors.orange,
                            size: 30,
                          ),
                        ),
                        title: Text(
                          service.titre ?? 'Service sans titre',
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                        subtitle: Text(
                          service.description ?? 'Pas de description',
                        ),
                        trailing: Checkbox(
                          value: selectedServices[service.titre] ?? false,
                          activeColor: Colors.orange,
                          onChanged: (bool? value) {
                            setState(() {
                              selectedServices[service.titre ?? ''] =
                                  value ?? false;
                            });
                          },
                        ),
                      ),
                    );
                  },
                ),
              ),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  // Récupérer les IDs des services cochés
                  final selectedIds = services
                      .where((service) =>
                          selectedServices[service.titre ?? ''] == true)
                      .map((service) => service.id)
                      .toList();

                  _saveUserService(selectedIds);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.orange,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30.0),
                  ),
                  padding: const EdgeInsets.symmetric(vertical: 16.0),
                ),
                child: _isLoading
                    ? const CircularProgressIndicator(color: Colors.white)
                    : const Text(
                        "Valider",
                        style: TextStyle(fontSize: 16, color: Colors.white),
                      ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
