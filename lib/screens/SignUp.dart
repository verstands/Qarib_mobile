import 'package:emol/Translate/TranslatePage.dart';
import 'package:emol/models/OtpModel.dart';
import 'package:emol/models/VilleModel.dart';
import 'package:emol/models/api_response.dart';
import 'package:emol/screens/LoginPage.dart';
import 'package:emol/screens/RoleSelectionPage.dart';
import 'package:emol/screens/SaisieCodePage.dart';
import 'package:emol/services/CodeOtpService.dart';
import 'package:emol/services/UserService.dart';
import 'package:emol/services/VilleService.dart';
import 'package:flutter/material.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SignUpPage extends StatefulWidget {
  const SignUpPage({super.key});

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  String? _selectedCity;
  final List<String> _cities = [
    'Casablanca/media',
    'Rabat',
    'Tanger',
    'Agadir',
    'Oujda',
    'Fes',
    'Marrakech'
  ];
  List<VilleModel> cities = [];

  Future<void> _fetchVille() async {
    EasyLoading.show(status: 'Chargement des villes...');
    ApiResponse response = await getVilleAllService();
    if (response.erreur == null) {
      setState(() {
        cities = response.data as List<VilleModel>;
      });
      print(cities);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('${response.erreur}')),
      );
    }
    EasyLoading.dismiss();
  }

  final _formKey = GlobalKey<FormState>();
  bool _acceptTerms = false; // État de la checkbox
  String _languageCode = "";
  String codeotp = "";
  bool _isLoading = false;

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
    _fetchVille();
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

                // Logo ou icône
                CircleAvatar(
                  radius: 50,
                  backgroundColor: Colors.white,
                  child: ClipOval(
                    child: Image.asset(
                      'assets/logo/logo.jpeg',
                      fit: BoxFit.cover,
                      width: 90,
                      height: 90,
                    ),
                  ),
                ),

                const SizedBox(height: 20.0),

                // Titre
                Text(
                  Translations.get('Créer_un_compte', _languageCode),
                  style: TextStyle(
                    fontSize: 24,
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 10.0),

                Text(
                  Translations.get(
                      'Rejoignez_nous_de_maintenant', _languageCode),
                  style: TextStyle(fontSize: 16, color: Colors.white70),
                ),
                const SizedBox(height: 40.0),

                // Champ nom
                TextFormField(
                  controller: _nameController,
                  keyboardType: TextInputType.name,
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: Colors.white,
                    prefixIcon:
                        const Icon(Icons.person_outline, color: Colors.orange),
                    labelText: Translations.get('Nom_complet', _languageCode),
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
                          'Veuillez_entrer_votre_nom_complet', _languageCode);
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16.0),

                TextFormField(
                  controller: _phoneController,
                  keyboardType: TextInputType.phone,
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: Colors.white,
                    prefixIcon:
                        const Icon(Icons.phone_outlined, color: Colors.orange),
                    labelText:
                        Translations.get('Numero_de_telephone', _languageCode),
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
                          'Veuillez_entrer_votre_numéro_de_telephone',
                          _languageCode);
                    } else if (!RegExp(r'^\+?\d{10,15}$').hasMatch(value)) {
                      return Translations.get(
                          'Veuillez_entrer_un_numéro_de_telephone_valide',
                          _languageCode);
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16.0),
                DropdownButtonFormField<String>(
                  value: _selectedCity,
                  onChanged: (value) {
                    setState(() {
                      _selectedCity = value!;
                    });
                  },
                  items: cities.map((city) {
                    return DropdownMenuItem(
                      value: city.id,
                      child: Text(city.nom ?? ''),
                    );
                  }).toList(),
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: Colors.white,
                    prefixIcon: const Icon(Icons.location_city_outlined,
                        color: Colors.orange),
                    labelText: Translations.get('Ville', _languageCode),
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
                          'Veuillez_sélectionner_une_ville', _languageCode);
                    }
                    return null;
                  },
                ),

                const SizedBox(height: 16.0),

                // Champ email
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
                const SizedBox(height: 16.0),

                // Champ mot de passe
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
                const SizedBox(height: 16.0),

                // Champ confirmer mot de passe
                TextFormField(
                  controller: _confirmPasswordController,
                  obscureText: true,
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: Colors.white,
                    prefixIcon: const Icon(Icons.lock_reset_outlined,
                        color: Colors.orange),
                    labelText: Translations.get(
                        'Confirmer_le_mot_de_passe', _languageCode),
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
                          'Veuillez_confirmer_votre_mot_de_passe',
                          _languageCode);
                    } else if (value != _passwordController.text) {
                      return Translations.get(
                          'Les_mots_de_passe_ne_correspondent_pas',
                          _languageCode);
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 24.0),

                // Checkbox pour accepter les conditions
                CheckboxListTile(
                  value: _acceptTerms,
                  onChanged: (value) {
                    setState(() {
                      _acceptTerms = value!;
                    });
                  },
                  title: RichText(
                    text: TextSpan(
                      text: Translations.get('Jaccepte_les', _languageCode),
                      style: const TextStyle(color: Colors.white),
                      children: [
                        TextSpan(
                          text: Translations.get(
                              'conditions_dutilisation', _languageCode),
                          style: const TextStyle(
                            decoration: TextDecoration.underline,
                            fontWeight: FontWeight.bold,
                          ),
                          recognizer: TapGestureRecognizer()
                            ..onTap = () {
                              _showPrivacyDialog(
                                context,
                                Translations.get(
                                    'conditions_dutilisation', _languageCode),
                                Translations.get(
                                    'Voici_le_texte_des_conditions_d_utilisation',
                                    _languageCode),
                              );
                            },
                        ),
                        const TextSpan(text: " et la "),
                        TextSpan(
                          text: Translations.get(
                              'politiquedeconfidentialite', _languageCode),
                          style: const TextStyle(
                            decoration: TextDecoration.underline,
                            fontWeight: FontWeight.bold,
                          ),
                          recognizer: TapGestureRecognizer()
                            ..onTap = () {
                              _showPrivacyDialog(
                                context,
                                'Politique de confidentialité',
                                'Voici le texte de la politique de confidentialité...',
                              );
                            },
                        ),
                      ],
                    ),
                  ),
                  controlAffinity: ListTileControlAffinity.leading,
                  activeColor: Colors.orange,
                ),

                // Bouton d'inscription
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
                          onPressed: _acceptTerms
                              ? () async {
                                  if (_formKey.currentState!.validate()) {
                                    setState(() {
                                      _isLoading = true;
                                    });
                                  
                                    ApiResponse responseVerifi =
                                        await VerifyCompteService(
                                            _emailController.text,
                                            _nameController.text,
                                            _passwordController.text,
                                            _phoneController.text,
                                            _selectedCity!);
                                   
                                    if (responseVerifi.erreur == null) {
                                      setState(() {
                                        _isLoading = false;
                                      });

                                      SharedPreferences prefs =
                                            await SharedPreferences
                                                .getInstance();
                                        await prefs.setString('emailAgent',  _emailController.text);
                                        await prefs.setString('nomsAgent',  _nameController.text);
                                        await prefs.setString('passwordAgent',   _passwordController.text);
                                        await prefs.setString('phoneAgent',  _phoneController.text);
                                        await prefs.setString('citeAgent',  _selectedCity!);

                                      ApiResponse response =
                                          await CodeOtpmailService(
                                              _emailController.text,
                                              _nameController.text);

                                      if (response.erreur == null) {
                                        setState(() {
                                          _isLoading = false;
                                        });

                                        final otp = response.data as otpModel;
                                        print('Code OTP reçu : ${otp.code}');

                                        SharedPreferences prefs =
                                            await SharedPreferences
                                                .getInstance();
                                        codeotp = otp.code ?? '';
                                        await prefs.setString('code', codeotp);

                                        print('Code OTP enregistré : $codeotp');

                                        // Redirection après succès
                                        Navigator.of(context)
                                            .pushAndRemoveUntil(
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  SaisieCodePage()),
                                          (route) => false,
                                        );
                                      } else {
                                        EasyLoading.showError(response.erreur ??
                                            "Erreur inconnue");
                                      }
                                    } else {
                                      EasyLoading.showError(
                                          responseVerifi.erreur ??
                                              "Erreur inconnue");
                                              setState(() {
                                        _isLoading = false;
                                      });
                                    }
                                  }
                                }
                              : null,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(vertical: 15),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10.0),
                            ),
                          ),
                          child: Text(
                            Translations.get('sinscrire', _languageCode),
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
                  icon: const Icon(Icons.apple, color: Colors.white), //
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
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pushAndRemoveUntil(
                        MaterialPageRoute(builder: (context) => LoginPage()),
                        (route) => false);
                  },
                  child: Text(
                    Translations.get('DéjàuncompteSeconnecter', _languageCode),
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

void _showPrivacyDialog(BuildContext context, String title, String content) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text(
          title,
          style: const TextStyle(color: Colors.orange),
        ),
        content: SingleChildScrollView(
          child: Text(content),
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: const Text(
              'Fermer',
              style: TextStyle(color: Colors.orange),
            ),
          ),
        ],
      );
    },
  );
}
