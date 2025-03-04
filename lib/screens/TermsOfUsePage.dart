import 'package:flutter/material.dart';

class TermsOfUsePage extends StatelessWidget {
  const TermsOfUsePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Conditions d\'utilisation',
          style: TextStyle(color: Colors.white), // Titre en blanc
        ),
        backgroundColor: Colors.orange,
      ),
      body: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Bienvenue sur notre application !',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.black, // Texte en blanc
                ),
              ),
              const SizedBox(height: 20),
              Text(
                'En utilisant notre application, vous acceptez les conditions d\'utilisation suivantes :',
                style: TextStyle(fontSize: 16, color: Colors.black), // Texte en blanc
              ),
              const SizedBox(height: 20),
              Text(
                '1. Acceptation des conditions\n\n'
                'En accédant ou en utilisant notre application, vous acceptez d\'être lié par ces conditions d\'utilisation et toutes les lois et réglementations locales applicables. Si vous n\'acceptez pas ces conditions, veuillez ne pas utiliser notre application.\n\n'
                '2. Modification des conditions\n\n'
                'Nous nous réservons le droit de modifier ces conditions à tout moment sans préavis. Vous êtes invité à consulter régulièrement cette page pour prendre connaissance des mises à jour.\n\n'
                '3. Utilisation de l\'application\n\n'
                'Vous vous engagez à ne pas utiliser notre application à des fins illégales ou interdites par ces conditions.\n\n'
                '4. Responsabilité\n\n'
                'Nous ne sommes pas responsables des erreurs, des interruptions ou de la disponibilité de l\'application.\n\n'
                '5. Propriété intellectuelle\n\n'
                'Tous les contenus de l\'application, y compris mais sans s\'y limiter, les textes, images et logos, sont protégés par des droits d\'auteur et sont la propriété de notre société.\n\n'
                '6. Résiliation\n\n'
                'Nous nous réservons le droit de suspendre ou de résilier votre accès à l\'application à tout moment en cas de non-respect de ces conditions.\n\n'
                '7. Contact\n\n'
                'Si vous avez des questions concernant ces conditions, veuillez nous contacter via notre page de contact.',
                style: TextStyle(fontSize: 14, color: Colors.black), // Texte en blanc
              ),
              const SizedBox(height: 40),
            ],
          ),
        ),
      
    );
  }
}
