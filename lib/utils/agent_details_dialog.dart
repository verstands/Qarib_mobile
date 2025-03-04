import 'package:flutter/material.dart';

void showAgentDetails(BuildContext context, String name, String services) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      List<String> serviceList = services.split(', ');

      return Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(Icons.person, color: Colors.blueAccent, size: 28),
                  SizedBox(width: 10),
                  Text(
                    name,
                    style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.blueAccent),
                  ),
                ],
              ),
              SizedBox(height: 12),
              Row(
                children: [
                  Icon(Icons.business, color: Colors.green, size: 22),
                  SizedBox(width: 10),
                  Text(
                    'Services associés:',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: Colors.grey[700]),
                  ),
                ],
              ),
              SizedBox(height: 8),
              Column(
                children: serviceList.map((service) {
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 8.0),
                    child: Row(
                      children: [
                        Icon(Icons.help_outline, color: Colors.blueAccent, size: 20),
                        SizedBox(width: 10),
                        Text(service, style: TextStyle(fontSize: 14, color: Colors.black)),
                      ],
                    ),
                  );
                }).toList(),
              ),
              SizedBox(height: 20),
              Align(
                alignment: Alignment.centerRight,
                child: ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.blueAccent),
                  icon: Icon(Icons.close, color: Colors.white),
                  label: Text('Fermer', style: TextStyle(color: Colors.white)),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
              ),
            ],
          ),
        ),
      );
    },
  );
}
