import 'package:emol/Translate/TranslatePage.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LanguagePage extends StatefulWidget {
  const LanguagePage({super.key});

  @override
  _LanguagePageState createState() => _LanguagePageState();
}

class _LanguagePageState extends State<LanguagePage> {
  String? _selectedLanguage;
  String _languageCode = "";

  Future<void> _loadLanguage() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _languageCode = prefs.getString('selectedLanguage') ?? "fr";
    });
    print(_languageCode);
  }

  @override
  void initState() {
    super.initState();
    _loadSelectedLanguage();
     _loadLanguage();
  }

  Future<void> _loadSelectedLanguage() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _selectedLanguage = prefs.getString('selectedLanguage');
    });
  }


  Future<void> _saveSelectedLanguage(String languageCode) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('selectedLanguage', languageCode);
    await  _loadLanguage();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title:  Text(Translations.get('Sélectionner_la_langue_de_lapplication', _languageCode)),
        backgroundColor: Colors.orange,
        centerTitle: true,
        elevation: 4.0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
             Text(
              Translations.get('Sélectionner_la_langue_de_lapplication', _languageCode),
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            _buildLanguageOption("Français", "fr"),
            _buildLanguageOption("English", "en"),
            _buildLanguageOption("Arabe", "ar"),
          ],
        ),
      ),
    );
  }

  Widget _buildLanguageOption(String language, String languageCode) {
    bool isSelected = _selectedLanguage == languageCode;

    return Container(
      decoration: BoxDecoration(
        color: isSelected ? Colors.orange.shade50 : Colors.white,
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
        leading: const Icon(
          Icons.language,
          color: Colors.orange,
        ),
        title: Text(
          language,
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w500,
            color: isSelected ? Colors.orange : Colors.black,
          ),
        ),
        trailing: isSelected
            ? const Icon(
                Icons.check,
                color: Colors.orange,
              )
            : const Icon(
                Icons.arrow_forward_ios,
                color: Colors.orange,
              ),
        onTap: () async {
          setState(() {
            _selectedLanguage = languageCode;
          });
          await _saveSelectedLanguage(languageCode);
        },
      ),
    );
  }
}
