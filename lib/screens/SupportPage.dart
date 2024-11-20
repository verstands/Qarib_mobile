import 'package:emol/Translate/TranslatePage.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SupportPage extends StatefulWidget {
  const SupportPage({super.key});

  @override
  State<SupportPage> createState() => _SupportPageState();
}

class _SupportPageState extends State<SupportPage> {
  String _languageCode = "";

  Future<void> _loadLanguage() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _languageCode = prefs.getString('selectedLanguage') ?? "";
    });
    print(_languageCode);
  }

  @override
  void initState() {
    super.initState();
     _loadLanguage();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title:  Text(Translations.get('Support', _languageCode)),
        backgroundColor: Colors.orange,
        centerTitle: true,
        elevation: 4.0, // Ombre pour un effet moderne
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            // Titre principal
             Text(
              Translations.get('Accédez_lassistance_et_a_laide_de_lapplication', _languageCode),
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.black54,
              ),
            ),
            const SizedBox(height: 20),
            // Liste des options de support avec un design amélioré
            _buildSupportOption(Translations.get('Contacter_le_support', _languageCode), Icons.phone, Colors.blue),
            _buildSupportOption(Translations.get('FAQ', _languageCode), Icons.help, Colors.green),
            _buildSupportOption(Translations.get('Signaler_un_problème', _languageCode), Icons.report, Colors.red),
          ],
        ),
      ),
    );
  }

  Widget _buildSupportOption(String title, IconData icon, Color iconColor) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.2),
            spreadRadius: 2,
            blurRadius: 5,
            offset: const Offset(0, 3), // Position de l'ombre
          ),
        ],
      ),
      margin: const EdgeInsets.symmetric(vertical: 8),
      child: ListTile(
        leading: Icon(
          icon,
          color: iconColor, // Couleur de l'icône
        ),
        title: Text(
          title,
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w500,
          ),
        ),
        trailing: Icon(
          Icons.arrow_forward_ios,
          color: Colors.orange.shade700,
        ),
        onTap: () {
          _handleSupportOption(title);
        },
      ),
    );
  }

  // Fonction qui gère l'option sélectionnée
  void _handleSupportOption(String title) {
    if (title == "Contacter le support") {
      _showContactSupportDialog();
    } else if (title == "FAQ") {
      _showFAQDialog();
    } else if (title == "Signaler un problème") {
      _showReportProblemDialog();
    }
  }

  // Dialog pour contacter le support
  void _showContactSupportDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Contacter le support'),
          content: const Text('Voulez-vous parler à un agent du support ?'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Fermer le dialogue
              },
              child: const Text('Annuler'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                // Ajoutez ici la logique pour contacter le support
              },
              child: const Text('Contacter'),
            ),
          ],
        );
      },
    );
  }

  // Dialog pour afficher la FAQ
  void _showFAQDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('FAQ'),
          content: const Text('Vous pouvez consulter la FAQ pour obtenir de l\'aide.'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Fermer le dialogue
              },
              child: const Text('OK'),
            ),
          ],
        );
      },
    );
  }

  // Dialog pour signaler un problème
  void _showReportProblemDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Signaler un problème'),
          content: const Text('Souhaitez-vous signaler un problème dans l\'application ?'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Fermer le dialogue
              },
              child: const Text('Annuler'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                // Ajoutez ici la logique pour signaler un problème
              },
              child: const Text('Signaler'),
            ),
          ],
        );
      },
    );
  }
}
