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
  String? selectedCategory;
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
    //_focusNode.requestFocus();
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
        title: const Text("Recherche de services", style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),),
        centerTitle: true,
      ),
      body: Column(
        children: [
          Padding(
            padding:
                const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
            child: Container(
              padding:
                  const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
              decoration: BoxDecoration(
                color: Colors.orange.shade50, // Couleur de fond subtile
                borderRadius: BorderRadius.circular(12), // Coins arrondis
                border: Border.all(
                  color: Colors.orange.shade200, // Bordure légère
                  width: 1.5,
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.orange.withOpacity(0.1),
                    offset: Offset(0, 4),
                    blurRadius: 10,
                  ),
                ], // Ombre douce pour un effet de profondeur
              ),
              child: DropdownButton<String>(
                value: selectedCategory,
                hint: const Text(
                  "Sélectionner une catégorie",
                  style: TextStyle(
                    color: Colors.orange, // Couleur du texte
                    fontWeight: FontWeight.bold, // Texte en gras
                  ),
                ),
                onChanged: (newValue) {
                  setState(() {
                    selectedCategory = newValue;
                  });
                },
                icon: const Icon(
                  Icons.arrow_drop_down,
                  color: Colors.orange, // Icône de flèche stylisée
                ),
                items: <String>[
                  'Catégorie 1',
                  'Catégorie 2',
                  'Catégorie 3'
                ] // Liste des catégories
                    .map<DropdownMenuItem<String>>((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(
                      value,
                      style: TextStyle(
                        color: Colors.black, // Couleur du texte de la catégorie
                        fontWeight: FontWeight.w500, // Légèrement moins gras
                      ),
                    ),
                  );
                }).toList(),
                isExpanded:
                    true, // S'assure que le menu occupe toute la largeur disponible
                underline: SizedBox(), // Retire la ligne sous le dropdown
              ),
            ),
          ),
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
                                  child: CircularProgressIndicator(
                                    color: Colors.orange,
                                  ),
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
