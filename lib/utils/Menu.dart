import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:emol/screens/DriverModePage.dart';
import 'package:emol/screens/HomePage.dart';
import 'package:emol/screens/ProfilePage.dart';
import 'package:emol/screens/SettingPage.dart';

class MenuUtils extends StatefulWidget {
  const MenuUtils({super.key});

  @override
  State<MenuUtils> createState() => _MenuUtilsState();
}

class _MenuUtilsState extends State<MenuUtils> {
  int _currentIndex = 0;
  late String userRole;  // Variable pour stocker le rôle de l'utilisateur

  // Listes de titres et d'écrans de navigation
  List<String> _titles = [];
  List<Widget> _screens = [];

  // Fonction pour récupérer le rôle de l'utilisateur depuis SharedPreferences
  Future<void> _getUserRole() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String role = prefs.getString('role') ?? 'user'; // Récupère le rôle (par défaut 'user')
    setState(() {
      userRole = role;
      _initializeMenu(role);
    });
  }

  // Initialiser les éléments de menu en fonction du rôle de l'utilisateur
  void _initializeMenu(String role) {
    if (role == 'prestateur') {
      _titles = ["Accueil", "Profil", "Paramètres", "Prestateur"];
      _screens = [
        const HomeScreen(),
        const ProfileScreen(),
        const SettingsScreen(),
        const DriverModeScreen(),
      ];
    } else {
      _titles = ["Accueil", "Profil", "Paramètres"];
      _screens = [
        const HomeScreen(),
        const ProfileScreen(),
        const SettingsScreen(),
      ];
    }
  }

  @override
  void initState() {
    super.initState();
    _getUserRole(); // Récupérer le rôle au démarrage de la page
  }


  void _onTabTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      
      body: _screens.isNotEmpty ? _screens[_currentIndex] : const Center(child: CircularProgressIndicator()),
      bottomNavigationBar: _titles.isNotEmpty 
          ? BottomNavigationBar(
              currentIndex: _currentIndex,
              onTap: _onTabTapped,
              selectedItemColor: Colors.orange,
              unselectedItemColor: Colors.grey,
              items: _titles.map((title) {
                int index = _titles.indexOf(title);
                return BottomNavigationBarItem(
                  icon: Icon(index == 0
                      ? Icons.home
                      : index == 1
                          ? Icons.person
                          : index == 2
                              ? Icons.settings
                              : Icons.directions_car), // Icône spécifique pour Prestateur
                  label: title,
                );
              }).toList(),
            )
          : null, // Affiche BottomNavigationBar une fois que les titres sont chargés
    );
  }
}

// Écran d'accueil
class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: HomePage(),
    );
  }
}

// Écran du profil
class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: ProfilePage(),
    );
  }
}

// Écran des paramètres
class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: SettingPage(),
    );
  }
}

// Écran du mode conducteur
class DriverModeScreen extends StatelessWidget {
  const DriverModeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: DriverModePage(),
    );
  }
}
