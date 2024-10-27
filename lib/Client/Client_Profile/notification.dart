import 'package:flutter/material.dart';

import '../client_bottom_nav.dart';

class NotificationScreen extends StatefulWidget {
  const NotificationScreen({Key? key}) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _NotificationScreenState createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {
  bool showNotification = true;
  bool lockScreenNotification = true;
  bool allowVibration = true;
  bool allowSound = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Notification Settings',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: const Color(0xFF1F2544),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildOption('Show Notification', showNotification, (value) {
              setState(() {
                showNotification = value;
              });
            }),
            _buildOption('Lock Screen Notification', lockScreenNotification, (value) {
              setState(() {
                lockScreenNotification = value;
              });
            }),
            _buildOption('Allow Vibration', allowVibration, (value) {
              setState(() {
                allowVibration = value;
              });
            }),
            _buildOption('Allow Sound', allowSound, (value) {
              setState(() {
                allowSound = value;
              });
            }),
          ],
        ),
      ),
      bottomNavigationBar: ClientBottomNavigationBar(),
    );
  }

  Widget _buildOption(String label, bool value, Function(bool) onChanged) {
    return Column(
      children: [
        ListTile(
          title: Text(
            label,
            style: const TextStyle(
              fontSize: 18.0,
              fontWeight: FontWeight.bold,
              color: Color(0xFF1F2544),
            ),
          ),
          trailing: Switch(
            value: value,
            onChanged: onChanged,
            activeColor: const Color(0xFF1F2544),
          ),
        ),
        const Divider(),
      ],
    );
  }
}
