import 'package:emol/Translate/TranslatePage.dart';
import 'package:emol/models/api_response.dart';
import 'package:emol/screens/HomePage.dart';
import 'package:emol/screens/SignUp.dart';
import 'package:emol/services/LoginService.dart';
import 'package:emol/utils/Menu.dart';
import 'package:emol/utils/ToastUtil.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  String _languageCode = "";
  final _formKey = GlobalKey<FormState>();
  bool _isLoading = false;

  Future<void> _loadLanguage() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _languageCode = prefs.getString('selectedLanguage') ?? "fr";
    });
    print(_languageCode);
  }

    void _loginUser() async {
      if (_formKey.currentState!.validate()) {
        setState(() {
          _isLoading = true;
        });

        ApiResponse<Map<String, dynamic>> response =
            await SignInService(_emailController.text, _passwordController.text);

        setState(() {
          _isLoading = false;
        });

        if (response.erreur == null && response.data != null) {
          SharedPreferences prefs = await SharedPreferences.getInstance();

          String token = response.data!['access_token'] ?? '';
          Map<String, dynamic> agentData = response.data!['agent'] ?? {};
          String id = agentData['id'] ?? '';
          String nom = agentData['noms'] ?? '';
          String telephone = agentData['telephone'] ?? '';
          String email = agentData['email'] ?? '';

         
          await prefs.setString('token', token);
          await prefs.setString('agent_id', id);
          await prefs.setString('agent_nom', nom);
          await prefs.setString('agent_telephone', telephone);
          await prefs.setString('agent_email', email);
          Navigator.of(context).pushAndRemoveUntil(
              MaterialPageRoute(builder: (context) => MenuUtils()),
              (route) => false);
        } else {
           EasyLoading.showError(response.erreur ?? "");
        }
      }
    }

  @override
  void initState() {
    super.initState();
    _loadLanguage();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFFFFA726), Color(0xFFFF7043)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20.0),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const SizedBox(height: 60.0),
                CircleAvatar(
                  radius: 50,
                  backgroundColor: Colors.white,
                  child: ClipOval(
                    child: Image.asset(
                      'assets/logo/logo.jpeg',
                      fit: BoxFit.cover,
                      width: 90, // Ajustez la taille si nécessaire
                      height: 90,
                    ),
                  ),
                ),

                const SizedBox(height: 20.0),
                Text(
                  Translations.get('Bienvenue', _languageCode),
                  style: const TextStyle(
                    fontSize: 24,
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 10.0),

                Text(
                  Translations.get(
                      'Connectez_vous_pour_continuer', _languageCode),
                  style: TextStyle(fontSize: 16, color: Colors.white70),
                ),
                const SizedBox(height: 40.0),
                TextFormField(
                  controller: _emailController,
                  keyboardType: TextInputType.emailAddress,
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: Colors.white,
                    prefixIcon:
                        const Icon(Icons.email_outlined, color: Colors.orange),
                    labelText: Translations.get('Email', _languageCode),
                    labelStyle: const TextStyle(color: Colors.orange),
                    focusedBorder: OutlineInputBorder(
                      borderSide: const BorderSide(color: Colors.orange),
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return Translations.get(
                          'Veuillez_entrer_votre_email', _languageCode);
                    } else if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$')
                        .hasMatch(value)) {
                      return Translations.get(
                          'Veuillez_entrer_un_email_valide', _languageCode);
                    }
                    return null;
                  },
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end, // Aligne à droite
                  children: [
                    TextButton(
                      onPressed: () {
                        // Ajoutez ici la logique pour la réinitialisation du mot de passe
                        Navigator.pushNamed(context, '/reset-password');
                      },
                      child: Text(
                        Translations.get('Mot_de_passe_oublie', _languageCode),
                        style: TextStyle(
                            color: Colors.white, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ],
                ),
                TextFormField(
                  controller: _passwordController,
                  obscureText: true,
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: Colors.white,
                    prefixIcon:
                        const Icon(Icons.lock_outline, color: Colors.orange),
                    labelText: Translations.get('Mot_de_passe', _languageCode),
                    labelStyle: const TextStyle(color: Colors.orange),
                    focusedBorder: OutlineInputBorder(
                      borderSide: const BorderSide(color: Colors.orange),
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return Translations.get(
                          'Veuillez_entrer_votre_mot_de_passe', _languageCode);
                    } else if (value.length < 6) {
                      return Translations.get(
                          'Le_mot_de_passe_doit_contenir_au_moins_6_caractères',
                          _languageCode);
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 24.0),
                SizedBox(
                  width: double.infinity,
                  child: _isLoading
                      ? Center(
                          child: CircularProgressIndicator(
                            color: Colors
                                .orange,
                          ),
                        )
                      : ElevatedButton(
                          onPressed: () {
                            if (_formKey.currentState!.validate()) {
                              if (_isLoading) {
                                return;
                              } else {
                                _loginUser();
                              }
                            }
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(vertical: 15),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10.0),
                            ),
                          ),
                          child: Text(
                            Translations.get('Se_connecter', _languageCode),
                            style:
                                TextStyle(fontSize: 16, color: Colors.orange),
                          ),
                        ),
                ),

                const SizedBox(height: 16.0),
                OutlinedButton.icon(
                  onPressed: () {},
                  icon: const Icon(Icons.g_mobiledata, color: Colors.white),
                  label: Text(
                    Translations.get('Continuer_avec_Google', _languageCode),
                    style: TextStyle(color: Colors.white),
                  ),
                  style: OutlinedButton.styleFrom(
                    side: const BorderSide(color: Colors.white),
                    padding: const EdgeInsets.symmetric(
                        horizontal: 20, vertical: 12),
                  ),
                ),
                const SizedBox(height: 16.0),

                OutlinedButton.icon(
                  onPressed: () {
                    // Action à exécuter lors du clic
                  },
                  icon: const Icon(Icons.apple,
                      color: Colors.white), // Icône Apple
                  label: Text(
                    Translations.get('Continuer_avec_Apple', _languageCode),
                    style: TextStyle(
                        color: Colors.white, fontWeight: FontWeight.bold),
                  ),
                  style: OutlinedButton.styleFrom(
                    side: const BorderSide(color: Colors.white),
                    padding: const EdgeInsets.symmetric(
                        horizontal: 20, vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30), // Coins arrondis
                    ),
                    backgroundColor:
                        Colors.black, // Fond noir pour ressembler à Apple
                  ),
                ),

                const SizedBox(height: 16.0),

                // Lien inscription
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pushAndRemoveUntil(
                        MaterialPageRoute(builder: (context) => SignUpPage()),
                        (route) => false);
                  },
                  child: Text(
                    Translations.get('Pas_de_compte_sinscrire', _languageCode),
                    style: TextStyle(
                        color: Colors.white, fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
