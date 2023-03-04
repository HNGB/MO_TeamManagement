import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:team_management/provider/google_sign_in.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: const Text('Login Page')),
        body: Center(
            child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              "TEAM MANAGEMENT",
              style: TextStyle(
                  fontSize: 30,
                  color: Colors.blue,
                  fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 200),
            FloatingActionButton.extended(
              onPressed: () {
                final provider =
                    Provider.of<GoogleSignInProvider>(context, listen: false);
                provider.googleLogin(context);
              },
              icon: Image.asset(
                'assets/images/google_logo.png',
                height: 32,
                width: 32,
              ),
              label: const Text('Sign in with Google'),
              backgroundColor: Colors.white,
              foregroundColor: Colors.black,
            ),
            const SizedBox(height: 20),
            const Text('Sign in with @fpt.edu.vn')
          ],
        )));
  }
}
