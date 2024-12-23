import 'package:flutter/material.dart';

class CallsInProgressPage extends StatefulWidget {
  const CallsInProgressPage({super.key});

  @override
  _CallsInProgressPageState createState() => _CallsInProgressPageState();
}

class _CallsInProgressPageState extends State<CallsInProgressPage> {
  final List<Map<String, String>> notifications = [
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
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.orangeAccent,
        title: const Text(
          "Notifications",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        elevation: 10,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Appels en cours",
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.orangeAccent,
              ),
            ),
            const SizedBox(height: 20),
            Expanded(
              child: ListView.builder(
                itemCount: notifications.length,
                itemBuilder: (context, index) {
                  return _buildNotificationCard(index);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNotificationCard(int index) {
    final notification = notifications[index];
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 10),
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CircleAvatar(
              backgroundColor: notification["status"] == "Appeler"
                  ? Colors.green
                  : Colors.red,
              radius: 25,
              child: Icon(
                notification["status"] == "Appeler"
                    ? Icons.call
                    : Icons.call_end,
                color: Colors.white,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    notification["name"]!,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    "Numéro: ${notification["phoneNumber"]}",
                    style: const TextStyle(
                      fontSize: 14,
                      color: Colors.grey,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    "Date: ${notification["date"]}",
                    style: const TextStyle(
                      fontSize: 14,
                      color: Colors.grey,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 16),
            notification["status"] == "Appeler"
                ? ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green,
                    ),
                    onPressed: () => _updateStatus(index, "Appelé"),
                    child: const Text("Accepter"),
                  )
                : ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red,
                    ),
                    onPressed: () => _updateStatus(index, "Refusé"),
                    child: const Text("Refuser"),
                  ),
          ],
        ),
      ),
    );
  }

  void _updateStatus(int index, String status) {
    setState(() {
      notifications[index]["status"] = status;
    });
  }
}
