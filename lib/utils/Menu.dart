import 'package:emol/screens/Mode.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:emol/screens/DriverDashboardPage.dart';
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

  final List<Widget> _screensUser = [
    const HomeScreen(),
    const ProfileScreen(),
    const SettingsScreen(),
    const ModeScreen(),
  ];

  final List<Widget> _screensPrestataire = [
    const PrestataireScreen(),
    const ProfileScreen(),
    const SettingsScreen(),
    const ModeScreen(),
  ];

  void _onTabTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    final screens = role == "user" ? _screensUser : _screensPrestataire;

    return Scaffold(
      body: screens[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: _onTabTapped,
        selectedItemColor: Colors.orange,
        unselectedItemColor: Colors.grey,
        items: role == "user"
            ? const [
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
                BottomNavigationBarItem(
                  icon: Icon(Icons.swap_horiz),
                  label: "Mode",
                ),
              ]
            : const [
                BottomNavigationBarItem(
                  icon: Icon(Icons.dashboard),
                  label: "Dashboard",
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.person),
                  label: "Profil",
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.settings),
                  label: "Paramètres",
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.swap_horiz),
                  label: "Mode",
                ),
              ],
      ),
    );
  }
}

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: HomePage(),
    );
  }
}

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: ProfilePage(),
    );
  }
}

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: SettingPage(),
    );
  }
}

class PrestataireScreen extends StatelessWidget {
  const PrestataireScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: ProviderDashboardPage(),
    );
  }
}

class ModeScreen extends StatelessWidget {
  const ModeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: ModeSelectionPage(),
    );
  }
}
