import 'package:emol/constant.dart';
import 'package:emol/models/CountServiceUserModel.dart';
import 'package:emol/models/api_response.dart';
import 'package:emol/screens/LoginPage.dart';
import 'package:emol/services/ServiceService.dart';
import 'package:flutter/material.dart';
import 'package:emol/screens/CallsInProgressPage.dart';
import 'package:emol/screens/EvaluationsPage.dart';
import 'package:emol/screens/MyServicesPage.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProviderDashboardPage extends StatefulWidget {
  const ProviderDashboardPage({super.key});

  @override
  State<ProviderDashboardPage> createState() => _ProviderDashboardPageState();
}

class _ProviderDashboardPageState extends State<ProviderDashboardPage> {
   String? noms;
   String? id;
   int totalServices = 0;


  Future<void> getNom() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      noms = prefs.getString('agent_nom');
    });
  }

  Future<void> getId() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      id = prefs.getString('agent_id');
    });
  }

    Future<void> _fetchService() async {
    ApiResponse response = await countServiceUserService(id!);
    if (response.erreur == null) {
       setState(() {
        totalServices = (response.data as CountServiceUserModel).data ?? 0;
      });
    } else if (response.erreur == unauthorized) {
      Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(builder: (context) => LoginPage()),
          (route) => false);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('${response.erreur}')),
      );
    }
  }
   @override
  void initState() {
    super.initState();
    getNom();
    getId();
   
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.orangeAccent,
        title: const Text(
          "Tableau de bord du prestataire",
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 22),
        ),
        centerTitle: true,
        elevation: 10,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Titre de bienvenue
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Colors.orangeAccent, Colors.deepOrangeAccent],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 8,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child:  Text(
                  'Bienvenue,${noms ?? ''} !',
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
              const SizedBox(height: 20),

              // Carte des statistiques
              Card(
                elevation: 10,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        "Statistiques rapides",
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.orangeAccent,
                        ),
                      ),
                      const SizedBox(height: 16),
                      _buildStatRow("Total des services", totalServices.toString(), Icons.card_giftcard),
                      const Divider(thickness: 1),
                      _buildStatRow("Services en cours", "4", Icons.work),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 30),

              // Section des fonctionnalités
              const Text(
                "Fonctionnalités disponibles :",
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.orangeAccent,
                ),
              ),
              const SizedBox(height: 16),

              // Liste des options
              Column(
                children: [
                  DashboardOption(
                    icon: Icons.card_giftcard,
                    label: "Voir mes services",
                    color: Colors.orangeAccent,
                    gradientColors: [Colors.orange, Colors.deepOrangeAccent],
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => MyServicesPage(),
                        ),
                      );
                    },
                  ),
                  DashboardOption(
                    icon: Icons.notifications,
                    label: "Notifications (2)",
                    color: Colors.deepOrange,
                    gradientColors: [Colors.redAccent, Colors.orangeAccent],
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const CallsInProgressPage(),
                        ),
                      );
                    },
                  ),
                  DashboardOption(
                    icon: Icons.star,
                    label: "Voir mes évaluations",
                    color: Colors.amber,
                    gradientColors: [Colors.yellowAccent, Colors.amber],
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const EvaluationsPage(),
                        ),
                      );
                    },
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Widget pour une ligne de statistique
  Widget _buildStatRow(String label, String value, IconData icon) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        children: [
          Icon(icon, color: Colors.orangeAccent, size: 28),
          const SizedBox(width: 16),
          Expanded(
            child: Text(
              label,
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
            ),
          ),
          Text(
            value,
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.orangeAccent,
            ),
          ),
        ],
      ),
    );
  }
}

class DashboardOption extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color color;
  final List<Color> gradientColors;
  final VoidCallback onTap;

  const DashboardOption({
    super.key,
    required this.icon,
    required this.label,
    required this.color,
    required this.gradientColors,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 10),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: gradientColors,
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 6,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: ListTile(
          leading: Icon(icon, color: Colors.white, size: 30),
          title: Text(
            label,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: Colors.white,
            ),
          ),
          trailing: const Icon(Icons.arrow_forward_ios, color: Colors.white),
        ),
      ),
    );
  }
}
