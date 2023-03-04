import 'package:flutter/material.dart';
import 'package:team_management/screens/chat.dart';

class NotificationPage extends StatelessWidget {
  const NotificationPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Notifications')),
      body: ListView(
        children: <Widget>[
          ListTile(
            leading: const Icon(Icons.notifications),
            title: const Text('New message'),
            subtitle: const Text('You have a new message from John.'),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const ChatPage(),
                ),
              );
            },
          ),
          ListTile(
            leading: const Icon(Icons.notifications),
            title: const Text('New friend request'),
            subtitle: const Text('You have a new friend request from Sarah.'),
            onTap: () {
              // Do something when the user taps on this item
            },
          ),
        ],
      ),
    );
  }
}
