import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:team_management/provider/google_sign_in.dart';

class SettingPage extends StatelessWidget {
  const SettingPage({super.key});

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser!;
    return Scaffold(
      appBar: AppBar(title: const Text('Settings')),
      body: ListView(
        children: <Widget>[
          const SizedBox(
            height: 50,
          ),
          CircleAvatar(
            radius: 40,
            child: ClipOval(
              child: Image.network(
                user.photoURL!,
              ),
            ),
          ),
          const SizedBox(
            height: 20,
          ),
          Center(
            child: Text(
              user.displayName!,
              style: const TextStyle(fontSize: 20),
            ),
          ),
          const SizedBox(
            height: 60,
          ),
          ListTile(
            leading: const Icon(Icons.lock),
            title: const Text('Change Password'),
            onTap: () {
              // Do something when the user taps on this item
            },
          ),
          ListTile(
            leading: const Icon(Icons.person),
            title: const Text('Profile'),
            onTap: () {
              // Do something when the user taps on this item
            },
          ),
          ListTile(
            leading: const Icon(Icons.exit_to_app),
            title: const Text('Logout'),
            onTap: () async {
              final provider =
                  Provider.of<GoogleSignInProvider>(context, listen: false);
              showDialog(
                context: context,
                builder: (BuildContext context) {
                  return AlertDialog(
                    content: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: const [
                        Text('Logging out...'),
                        CircularProgressIndicator(),
                      ],
                    ),
                  );
                },
              );
              provider.logout().then((_) {
                Navigator.of(context).pop();
              });
            },
          ),
        ],
      ),
    );
  }
}
