import 'package:flutter/material.dart';

class CallsInProgressPage extends StatefulWidget {
  const CallsInProgressPage({super.key});

  @override
  _CallsInProgressPageState createState() => _CallsInProgressPageState();
}

class _CallsInProgressPageState extends State<CallsInProgressPage> {
  // Liste des appels en cours avec un statut et une date pour chaque utilisateur
  final List<Map<String, String>> ongoingCalls = [
    {
      "name": "Rabby Kik",
      "phoneNumber": "24394567890",
      "status": "Appeler",
      "date": "2024-11-18 14:30"
    },
    {
      "name": "Rabby Kikwele",
      "phoneNumber": "243822662472",
      "status": "Refuser",
      "date": "2024-11-18 14:35"
    },
    {
      "name": "Alice Nzuzi",
      "phoneNumber": "243825645678",
      "status": "Appeler",
      "date": "2024-11-18 14:40"
    },
    {
      "name": "Jean Kamanda",
      "phoneNumber": "243921345678",
      "status": "Refuser",
      "date": "2024-11-18 14:45"
    },
    {
      "name": "Michel Badi",
      "phoneNumber": "243930098765",
      "status": "Appeler",
      "date": "2024-11-18 14:50"
    },
    {
      "name": "Clara Mabiala",
      "phoneNumber": "243988765432",
      "status": "Refuser",
      "date": "2024-11-18 14:55"
    },
    {
      "name": "Eric Tshikala",
      "phoneNumber": "243923445678",
      "status": "Appeler",
      "date": "2024-11-18 15:00"
    },
    {
      "name": "Emilie Lufungula",
      "phoneNumber": "243945677890",
      "status": "Refuser",
      "date": "2024-11-18 15:05"
    },
    {
      "name": "Moïse Kalenga",
      "phoneNumber": "243980234567",
      "status": "Appeler",
      "date": "2024-11-18 15:10"
    },
    {
      "name": "Sophie Lunda",
      "phoneNumber": "243925678990",
      "status": "Refuser",
      "date": "2024-11-18 15:15"
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.orangeAccent,
        title: const Text(
          "Notification",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        elevation: 10,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Titre
            const Text(
              "Appels en cours",
              style: TextStyle(
                fontSize: 25,
                fontWeight: FontWeight.bold,
                color: Colors.orangeAccent,
              ),
            ),
            const SizedBox(height: 20),

            // Liste des appels
            Expanded(
              child: ListView.builder(
                itemCount: ongoingCalls.length,
                itemBuilder: (context, index) {
                  return Card(
                    margin: const EdgeInsets.symmetric(vertical: 10.0),
                    elevation: 5,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          // Affichage du nom et du numéro
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // Nom de l'utilisateur
                              Text(
                                ongoingCalls[index]["name"]!,
                                style: const TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 8),
                              // Numéro de téléphone
                              Text(
                                ongoingCalls[index]["phoneNumber"]!,
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w400,
                                ),
                              ),
                              const SizedBox(height: 8),
                              // Affichage de la date de l'appel
                              Text(
                                "Date: ${ongoingCalls[index]["date"] ?? 'Date non disponible'}",
                                style: const TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w300,
                                  color: Colors.grey,
                                ),
                              ),
                            ],
                          ),
                          Column(
                            children: [
                              ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: ongoingCalls[index]
                                              ["status"] ==
                                          "Appeler"
                                      ? Colors.green
                                      : ongoingCalls[index]["status"] ==
                                              "Refuser"
                                          ? Colors.red
                                          : Colors
                                              .grey,
                                ),
                                onPressed: ongoingCalls[index]["status"] ==
                                        "Appeler"
                                    ? () => _acceptCall(index)
                                    : ongoingCalls[index]["status"] == "Refuser"
                                        ? () => _rejectCall(index)
                                        : null, // Si l'appel a déjà été accepté ou refusé, désactiver le bouton
                                child: Text(
                                  ongoingCalls[index]["status"] == "Appeler"
                                      ? "Accepter"
                                      : ongoingCalls[index]["status"] ==
                                              "Refuser"
                                          ? "Refusé"
                                          : "Statut", // Le texte du bouton change en fonction du statut
                                  style: const TextStyle(color: Colors.white),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Méthode pour accepter l'appel
  void _acceptCall(int index) {
    setState(() {
      ongoingCalls[index]["status"] =
          "Appelé"; // Mise à jour du statut à "Appelé"
    });
  }

  // Méthode pour refuser l'appel
  void _rejectCall(int index) {
    setState(() {
      ongoingCalls[index]["status"] =
          "Refusé"; // Mise à jour du statut à "Refusé"
    });
  }
}
