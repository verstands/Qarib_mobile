import 'package:emol/screens/RoleSelectionPage.dart';
import 'package:emol/screens/ServicePga.dart';
import 'package:emol/screens/UploadPhotoPage.dart';
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

  // Fonction pour changer de champ après la saisie
  void _nextField(String value, int index) {
    if (value.isNotEmpty && index < 3) {
      FocusScope.of(context).nextFocus();
    }
  }

  // Fonction pour vérifier le code saisi
  void _verifierCode() {
    String code = _controllers.map((controller) => controller.text).join();
    if (code.length == 4) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('Code vérifié : $code')));
      // Logique de vérification du code
      // Par exemple, rediriger l'utilisateur vers la page suivante si le code est correct.
      // Navigator.pushNamed(context, '/pageSuivante');
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Veuillez entrer un code à 4 chiffres')));
    }
  }

  @override
  Widget build(BuildContext context) {
    // Récupérer l'argument passé (le rôle)
    final role = ModalRoute.of(context)?.settings.arguments as String?;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.orangeAccent,
        title: Text("Saisie du code pour $role"),
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

            // Affichage des 4 champs de saisie
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

            // Affichage des boutons numériques (1-9 et 0)
            GridView.builder(
              shrinkWrap: true,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                crossAxisSpacing: 10,
                mainAxisSpacing: 10,
              ),
              itemCount: 12,
              itemBuilder: (context, index) {
                // Définir les boutons de 1 à 9 et les boutons 0, "effacer", et "envoyer"
                String buttonText = '';
                if (index < 9) {
                  buttonText = (index + 1).toString();
                } else if (index == 9) {
                  buttonText = '0';
                } else if (index == 10) {
                  buttonText = 'Effacer';
                } else {
                  buttonText = 'Envoyer';
                }

                return ElevatedButton(
                  onPressed: () {
                    if (buttonText == 'Effacer') {
                      // Effacer le dernier caractère
                      for (int i = 3; i >= 0; i--) {
                        if (_controllers[i].text.isNotEmpty) {
                          _controllers[i].clear();
                          break;
                        }
                      }
                    } else if (buttonText == 'Envoyer') {
                      // _verifierCode();
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const RoleSelectionPage(),
                        ),
                      );
                    } else {
                      // Ajouter le chiffre au champ de saisie
                      for (int i = 0; i < 4; i++) {
                        if (_controllers[i].text.isEmpty) {
                          _controllers[i].text = buttonText;
                          break;
                        }
                      }
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.orangeAccent,
                    padding: const EdgeInsets.all(8), // Réduction du padding
                    minimumSize: Size(40, 40), // Taille réduite des boutons
                  ),
                  child: Text(
                    buttonText,
                    style: const TextStyle(
                        fontSize: 16,
                        color: Colors.white), // Réduction de la taille du texte
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
