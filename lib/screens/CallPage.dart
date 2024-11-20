import 'dart:async';
import 'package:flutter/material.dart';

class CallPage extends StatefulWidget {
  const CallPage({super.key});

  @override
  _CallPageState createState() => _CallPageState();
}

class _CallPageState extends State<CallPage> {
  // Variables pour gérer le chronomètre
  int _seconds = 0;
  late Timer _timer;
  bool _isCalling = false; // L'appel n'a pas encore commencé
  bool _isAccepted = false;

  @override
  void initState() {
    super.initState();
    _startTimer(); // Démarre le timer dès l'arrivée sur la page
  }

  // Démarrer le chronomètre
  void _startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        _seconds++;
      });

      // Vérifiez si 15 secondes se sont écoulées
      if (_seconds >= 15) {
        _endCall(); // Arrêter l'appel et la page disparaît
        Navigator.pop(context); // Fermer la page après 15 secondes
      }
    });
  }

  // Accepter l'appel et démarrer le chronomètre
  void _acceptCall() {
    setState(() {
      _isCalling = true;
      _isAccepted = true;
    });
  }

  // Refuser l'appel
  void _declineCall() {
    Navigator.pop(context); // Retour à la page précédente
  }

  // Arrêter l'appel (ou chronomètre)
  void _endCall() {
    setState(() {
      _isCalling = false;
    });
    _timer.cancel(); // Arrêter le chronomètre
  }

  @override
  void dispose() {
    _timer.cancel(); // Libérer le timer lorsque la page est fermée
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Formater les secondes en minute:seconde (par exemple 00:15)
    String formattedTime = '${(_seconds ~/ 60).toString().padLeft(2, '0')}:${(_seconds % 60).toString().padLeft(2, '0')}';

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.orangeAccent,
        title: const Text(''),
        centerTitle: true,
        elevation: 8.0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            CircleAvatar(
              radius: 70,
              backgroundColor: Colors.orangeAccent,
              child: const Icon(
                Icons.account_circle,
                size: 80,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 20),
            const Text(
              'Rabby KIkwele',
              style: TextStyle(
                fontSize: 26,
                fontWeight: FontWeight.bold,
                color: Colors.orangeAccent,
              ),
            ),
            const SizedBox(height: 10),
            AnimatedDefaultTextStyle(
              style: TextStyle(
                fontSize: 50,
                fontWeight: FontWeight.bold,
                color: _isCalling ? Colors.black : Colors.green,
              ),
              duration: const Duration(milliseconds: 500),
              child: Text(formattedTime),
            ),
            const SizedBox(height: 30),
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  if (!_isAccepted) ...[
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        ElevatedButton(
                          onPressed: _acceptCall,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.green,
                            padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 20), // Moins de padding horizontal
                            shape: const StadiumBorder(),
                            elevation: 6,
                          ),
                          child: const Text(
                            'Accepter',
                            style: TextStyle(fontSize: 18, color: Colors.white),
                          ),
                        ),
                        const SizedBox(width: 10), // Réduire l'espacement
                        ElevatedButton(
                          onPressed: _declineCall,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.redAccent,
                            padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 20),
                            shape: const StadiumBorder(),
                            elevation: 6,
                          ),
                          child: const Text(
                            'Refuser',
                            style: TextStyle(fontSize: 18, color: Colors.white),
                          ),
                        ),
                      ],
                    ),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
