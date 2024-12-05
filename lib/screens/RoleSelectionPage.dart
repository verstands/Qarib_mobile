import 'package:emol/models/api_response.dart';
import 'package:emol/screens/HomePage.dart';
import 'package:emol/screens/LoginPage.dart';
import 'package:emol/screens/SaisieCodePage.dart';
import 'package:emol/screens/UploadPhotoPage.dart';
import 'package:emol/services/UserService.dart';
import 'package:emol/utils/Menu.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:shared_preferences/shared_preferences.dart';

class RoleSelectionPage extends StatefulWidget {
  const RoleSelectionPage({super.key});

  @override
  _RoleSelectionPageState createState() => _RoleSelectionPageState();
}

class _RoleSelectionPageState extends State<RoleSelectionPage> {
  String? noms;
  String? password;
  String? email;
  String? telephone;
  String? city;
  bool _isLoading = false;
  bool _isLoadingp = false;
  String id_role = '';
  String status = '';

  @override
  void initState() {
    super.initState();
    getNom();
    getEmail();
    getTelelephone();
    getPassword();
    getCity();
  }

  Future<void> _saveUserRole(String role) async {
    // Enregistre le rôle dans SharedPreferences
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('role', role);
  }

  Future<void> getNom() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      noms = prefs.getString('nomsAgent');
    });
  }

  Future<void> getEmail() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      email = prefs.getString('emailAgent');
    });
  }

  Future<void> getTelelephone() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      telephone = prefs.getString('phoneAgent');
    });
  }

  Future<void> getPassword() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      password = prefs.getString('passwordAgent');
    });
  }

  Future<void> getCity() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      city = prefs.getString('citeAgent');
    });
  }

  void _signInUser(String role) async {
    if (role == 'user') {
       setState(() {
      _isLoading = true;
    });
      id_role = "cm41epeh0000212o4tdtyxacu";
      status = '1';
    } else {
       setState(() {
      _isLoadingp = true;
    });
      id_role = "cm41ep6eu000112o4fbsi2vbd";
      status = '0';

    }
    ApiResponse<Map<String, dynamic>> response = await SaveUserService(
        email!, noms!, password!, telephone!, city!, id_role, status);

    setState(() {
      _isLoading = false;
    });
     setState(() {
      _isLoadingp = false;
    });

    if (response.erreur == null) {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      if (role == 'user') {
        EasyLoading.showSuccess(
            "Votre compte a été crée, veuillez vous connectez !");
        Navigator.of(context).pushAndRemoveUntil(
            MaterialPageRoute(builder: (context) => LoginPage()),
            (route) => false);
      } else {
        Navigator.of(context).pushAndRemoveUntil(
            MaterialPageRoute(builder: (context) => UploadPhotoPage()),
            (route) => false);
      }
    } else {
      EasyLoading.showError(response.erreur ?? "");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const Text(
              "Quel rôle souhaitez-vous choisir ?",
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.orangeAccent,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 30),
            _isLoadingp
                ? Center(
                    child: CircularProgressIndicator(
                      color: Colors.orange,
                    ),
                  )
                : ElevatedButton(
                    onPressed: () async {
                      await _saveUserRole('prestateur');
                      _signInUser('prestateur');
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.orangeAccent,
                      padding: const EdgeInsets.symmetric(
                          horizontal: 55, vertical: 40),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(
                            20), // Coins légèrement arrondis
                      ),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const CircleAvatar(
                          radius: 30, // Taille de l'icône
                          backgroundColor: Colors.white,
                          child: Icon(Icons.business_center,
                              color: Colors.orangeAccent, size: 30),
                        ),
                        const SizedBox(height: 10),
                        const Text(
                          'Je suis un prestataire de service',
                          style: TextStyle(fontSize: 16, color: Colors.white),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  ),
            const SizedBox(height: 20),
            _isLoading
                ? Center(
                    child: CircularProgressIndicator(
                      color: Colors.orange,
                    ),
                  )
                : ElevatedButton(
                    onPressed: () async {
                      await _saveUserRole('user');
                      _signInUser('user');
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.orangeAccent,
                      padding: const EdgeInsets.symmetric(
                          horizontal: 55, vertical: 40),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(
                            20), // Coins légèrement arrondis
                      ),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const CircleAvatar(
                          radius: 30, // Taille de l'icône
                          backgroundColor: Colors.white,
                          child: Icon(Icons.account_circle,
                              color: Colors.orangeAccent, size: 30),
                        ),
                        const SizedBox(height: 10),
                        const Text(
                          'Je suis un utilisateur / demandeur de service',
                          style: TextStyle(fontSize: 16, color: Colors.white),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  ),
          ],
        ),
      ),
    );
  }
}
