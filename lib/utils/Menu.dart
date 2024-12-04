import 'package:emol/screens/HomePage.dart';
import 'package:emol/screens/ProfilePage.dart';
import 'package:emol/screens/SettingPage.dart';
import 'package:flutter/material.dart';

class MenuUtils extends StatefulWidget {
  const MenuUtils({super.key});

  @override
  State<MenuUtils> createState() => _MenuUtilsState();
}

class _MenuUtilsState extends State<MenuUtils> {
  int _currentIndex = 0; 

  final List<String> _titles = ["Accueil", "Profil", "Paramètres"];

  final List<Widget> _screens = [
    const HomeScreen(),
    const ProfileScreen(),
    const SettingsScreen(),
  ];

  void _onTabTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      
      body: _screens[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: _onTabTapped,
        selectedItemColor: Colors.orange,
        unselectedItemColor: Colors.grey,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: "Accueil",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: "Profil",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings),
            label: "Paramètres",
          ),
        ],
      ),
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