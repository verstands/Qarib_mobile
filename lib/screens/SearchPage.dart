import 'package:emol/constant.dart';
import 'package:emol/models/Servicemodel.dart';
import 'package:emol/models/api_response.dart';
import 'package:emol/screens/LoginPage.dart';
import 'package:emol/services/FavoriService.dart';
import 'package:emol/services/ServiceService.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../utils/Icon_utils.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({super.key});

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  List<ServiceModel> services = [];
  bool loading = true;
  Map<String, bool> loadingFavorieMap = {};
  String? id;
  String searchQuery = '';
  final FocusNode _focusNode = FocusNode();

  Future<void> _fetchService() async {
    ApiResponse response = await getServiceAll();
    if (response.erreur == null) {
      setState(() {
        services = response.data as List<ServiceModel>;
        loading = false;
      });
    } else if (response.erreur == unauthorized) {
      Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(builder: (context) => LoginPage()),
          (route) => false);
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
  }

  void _AddFavorie(String idservice) async {
    setState(() {
      loadingFavorieMap[idservice] = true;
    });

    ApiResponse response = await postFavoriService(id!, idservice);

    setState(() {
      loadingFavorieMap[idservice] = false;
    });

    if (response.erreur == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Le service a été ajouté à vos favoris avec succès'),
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(response.erreur ?? 'Erreur inconnue')),
      );
    }
  }

  @override
  void initState() {
    super.initState();
    _fetchService();
    getId();
    _focusNode.requestFocus();
  }

  @override
  void dispose() {
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final filteredServices = services.where((service) {
      return service.titre!.toLowerCase().contains(searchQuery.toLowerCase()) ||
          service.description!
              .toLowerCase()
              .contains(searchQuery.toLowerCase());
    }).toList();

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.orange,
        title: const Text("Recherche de services"),
        centerTitle: true,
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextField(
              focusNode: _focusNode,
              onChanged: (query) {
                setState(() {
                  searchQuery = query;
                });
              },
              decoration: InputDecoration(
                contentPadding: const EdgeInsets.symmetric(
                    vertical: 10.0, horizontal: 20.0),
                hintText: 'Rechercher un service...',
                prefixIcon: Icon(Icons.search, color: Colors.orange),
                filled: true,
                fillColor: Colors.orange.shade50,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30.0),
                  borderSide: BorderSide.none,
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30.0),
                  borderSide: const BorderSide(color: Colors.orange, width: 2),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30.0),
                  borderSide:
                      BorderSide(color: Colors.orange.shade200, width: 2),
                ),
              ),
            ),
          ),
          loading
              ? const Center(
                  child: CircularProgressIndicator(color: Colors.orange))
              : Expanded(
                  child: ListView.builder(
                    itemCount: filteredServices.length,
                    itemBuilder: (context, index) {
                      final service = filteredServices[index];
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
                              getIconFromString(service.icon ??
                                  ''), // Récupère l'icône dynamique
                              color: Colors.orange,
                              size: 30,
                            ),
                          ),
                          title: Text(
                            service.titre ?? 'Service sans titre',
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                          subtitle:
                              Text(service.description ?? 'Pas de description'),
                          trailing: loadingFavorieMap[service.id] == true
                              ? const SizedBox(
                                  height: 20,
                                  width: 20,
                                  child: CircularProgressIndicator(color: Colors.orange,),
                                ) // Affiche un petit loader
                              : IconButton(
                                  icon: const Icon(
                                    Icons.favorite,
                                    color: Colors.grey,
                                  ),
                                  onPressed: () {
                                    _AddFavorie(service.id ?? '');
                                  },
                                ),
                          onTap: () {
                            // Action lors du clic
                          },
                        ),
                      );
                    },
                  ),
                ),
        ],
      ),
    );
  }
}
