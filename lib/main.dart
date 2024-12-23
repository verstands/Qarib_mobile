import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:shared_preferences/shared_preferences.dart';
import './sockets/socket_service.dart';
import 'screens/LoginPage.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final prefs = await SharedPreferences.getInstance();
  String selectedLanguage = prefs.getString('selectedLanguage') ?? 'fr';
  if (prefs.getString('selectedLanguage') == null) {
    await prefs.setString('selectedLanguage', 'fr');
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
      builder: EasyLoading.init(),
      home: AppWithSocket(),
    );
  }
}

class AppWithSocket extends StatefulWidget {
  @override
  _AppWithSocketState createState() => _AppWithSocketState();
}

class _AppWithSocketState extends State<AppWithSocket> {

  @override
  Widget build(BuildContext context) {
    return LoginPage(); 
  }
}
    
  