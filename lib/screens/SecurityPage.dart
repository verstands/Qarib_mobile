import 'package:emol/Translate/TranslatePage.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SecurityPage extends StatefulWidget {
  const SecurityPage({super.key});

  @override
  _SecurityPageState createState() => _SecurityPageState();
}

class _SecurityPageState extends State<SecurityPage> {
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
        title:  Text(Translations.get('Securite', _languageCode)),
        backgroundColor: Colors.orange,
        centerTitle: true,
        elevation: 4.0, 
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
           
             Text(
              Translations.get('Modifiez_votre_mot_de_passe_ou_configurez_vos_options_de_securité', _languageCode),
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.black54,
              ),
            ),
            const SizedBox(height: 20),
            _buildSecurityOption(Translations.get('Changer_le_mot_de_passe', _languageCode), Icons.lock, Colors.blue, _showChangePasswordDialog),
            _buildSecurityOption(Translations.get('Activer_la_vérification_en_deux_etapes', _languageCode), Icons.security, Colors.green, _showTwoStepVerificationDialog),
            _buildSecurityOption(Translations.get('Historique_des_connexions', _languageCode), Icons.history, Colors.orange, _showHistoryDialog),
          ],
        ),
      ),
    );
  }

  void _showChangePasswordDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Changer le mot de passe'),
          content: const Text('Voulez-vous vraiment changer votre mot de passe ?'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Annuler'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Confirmer'),
            ),
          ],
        );
      },
    );
  }

  void _showTwoStepVerificationDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Vérification en deux étapes'),
          content: const Text('Souhaitez-vous activer la vérification en deux étapes pour une sécurité accrue ?'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Annuler'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              
              },
              child: const Text('Confirmer'),
            ),
          ],
        );
      },
    );
  }


  void _showHistoryDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Historique des connexions'),
          content: const Text('Souhaitez-vous consulter l\'historique de vos connexions ?'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); 
              },
              child: const Text('Annuler'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                
              },
              child: const Text('Consulter'),
            ),
          ],
        );
      },
    );
  }


  Widget _buildSecurityOption(
      String title, IconData icon, Color iconColor, Function(BuildContext) onTapAction) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 2,
            blurRadius: 5,
            offset: const Offset(0, 3), 
          ),
        ],
      ),
      margin: const EdgeInsets.symmetric(vertical: 8),
      child: ListTile(
        leading: Icon(
          icon,
          color: iconColor, 
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
        onTap: () => onTapAction(context), 
      ),
    );
  }
}
