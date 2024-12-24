import 'package:shared_preferences/shared_preferences.dart';
import 'package:emol/screens/RoleSelectionPage.dart';
import 'package:flutter/material.dart';

class SaisieCodePage extends StatefulWidget {
  const SaisieCodePage({super.key});

  @override
  _SaisieCodePageState createState() => _SaisieCodePageState();
}

class _SaisieCodePageState extends State<SaisieCodePage> {
  // Contrôleurs pour chaque champ de saisie
  final List<TextEditingController> _controllers =
      List.generate(4, (index) => TextEditingController());


  void _nextField(String value, int index) {
    if (value.isNotEmpty && index < 3) {
      FocusScope.of(context).nextFocus();
    }
  }


  void _verifierCode() async {
    String codeSaisi = _controllers.map((controller) => controller.text).join();
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? codeStocke = prefs.getString('code');

    if (codeSaisi == codeStocke) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => const RoleSelectionPage(),
        ),
      );
       ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(codeStocke ?? '')),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Code incorrect, veuillez réessayer.')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final role = ModalRoute.of(context)?.settings.arguments as String?;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.orangeAccent,
        title: Text("Saisie du code", style: TextStyle(fontWeight: FontWeight.bold, color:  Colors.white),),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              "Veuillez saisir le code à 4 chiffres envoyé à votre adresse email.",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.orangeAccent,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 40),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: List.generate(4, (index) {
                return SizedBox(
                  width: 60,
                  child: TextField(
                    controller: _controllers[index],
                    keyboardType: TextInputType.number,
                    textAlign: TextAlign.center,
                    maxLength: 1,
                    decoration: InputDecoration(
                      counterText: '',
                      border: OutlineInputBorder(),
                    ),
                    onChanged: (value) => _nextField(value, index),
                  ),
                );
              }),
            ),
            const SizedBox(height: 40),
            SizedBox(
  width: double.infinity, // Prend toute la largeur
  child: ElevatedButton(
    onPressed: _verifierCode, // Lancer la vérification
    style: ElevatedButton.styleFrom(
      backgroundColor: Colors.orangeAccent,
      padding: const EdgeInsets.all(16), // Augmenter la hauteur
    ),
    child: const Text(
      'Vérifier',
      style: TextStyle(fontSize: 16, color: Colors.white),
    ),
  ),
),

          ],
        ),
      ),
    );
  }
}
