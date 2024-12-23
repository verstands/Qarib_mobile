import 'package:emol/utils/Menu.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ModeSelectionPage extends StatefulWidget {
  const ModeSelectionPage({super.key});

  @override
  State<ModeSelectionPage> createState() => _ModeSelectionPageState();
}

class _ModeSelectionPageState extends State<ModeSelectionPage> {
  String? role;

  @override
  void initState() {
    super.initState();
    _getRole();
  }

  Future<void> _getRole() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      role = prefs.getString('agent_role');
    });
  }

  Future<void> _setRole(BuildContext context, String role) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('agent_role', role);
    setState(() {
      this.role = role;
    });
   Navigator.of(context).pushAndRemoveUntil(
              MaterialPageRoute(builder: (context) => MenuUtils()),
              (route) => false);
  }

  @override
  Widget build(BuildContext context) {
    final buttonLabel = role == 'prestataire' ? 'Activer Mode Utilisateur' : 'Activer Mode Prestataire';
    final newRole = role == 'prestataire' ? 'user' : 'prestataire';

    return Scaffold(
      appBar: AppBar(
        title: const Text('Sélectionnez un mode'),
        backgroundColor: Colors.orange,
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.orange, Colors.white],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Icon(
                role == 'prestataire' ? Icons.person : Icons.work,
                size: 100,
                color: Colors.orange.shade700,
              ),
              const SizedBox(height: 20),
              Text(
                'Mode actuel : ${role ?? "Aucun"}',
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: Colors.orange.shade800,
                ),
              ),
              const SizedBox(height: 40),
              ElevatedButton(
                onPressed: () => _setRole(context, newRole),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.orange,
                  padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 20),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                ),
                child: Text(
                  buttonLabel,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.white
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
