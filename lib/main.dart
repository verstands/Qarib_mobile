import 'package:emol/screens/LoadPage.dart';
import 'package:emol/screens/LoginPage.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();


  final prefs = await SharedPreferences.getInstance();
  String selectedLanguage = prefs.getString('selectedLanguage') ?? 'en';
  if (prefs.getString('selectedLanguage') == null) {
    await prefs.setString('selectedLanguage', 'en');
  }

  runApp(MyApp(defaultLanguage: selectedLanguage));
}

class MyApp extends StatelessWidget {
  final String defaultLanguage;

  const MyApp({super.key, required this.defaultLanguage});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: LoginPage(),
    );
  }
}
