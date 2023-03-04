import 'dart:convert';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class GoogleSignInProvider extends ChangeNotifier {
  final googleSignIn = GoogleSignIn();

  GoogleSignInAccount? _user;
  GoogleSignInAccount get user => _user!;

  Future googleLogin(BuildContext context) async {
    final scaffoldContext = ScaffoldMessenger.of(context);

    try {
      final googleUser = await googleSignIn.signIn();
      if (googleUser == null) return;
      _user = googleUser;
      var check = await checkLogin(_user!.email);
      if (!check) {
        logout();
        scaffoldContext.showSnackBar(
          const SnackBar(
            content: Text('Your account is invalid!'),
          ),
        );
        return;
      }
      final googleAuth = await googleUser.authentication;
      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );
      await FirebaseAuth.instance.signInWithCredential(credential);
      var email = _user!.email;
      var topic = email.split('@')[0];
      SharedPreferences preferences = await SharedPreferences.getInstance();
      preferences.setString("topic", topic);
      await FirebaseMessaging.instance.subscribeToTopic(topic);
    } catch (e) {
      print(e.toString());
    } finally {}
    notifyListeners();
  }

  Future logout() async {
    await googleSignIn.disconnect();
    FirebaseAuth.instance.signOut();
  }

  Future<bool> checkLogin(String email) async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      var body = jsonEncode({"email": email});
      final response = await http.post(
          Uri.parse(
              'https://befuprojectteammanagementdemo.azurewebsites.net/api/Login'),
          body: body,
          headers: {
            "Accept": "application/json",
            "content-type": "application/json"
          });
      if (response.statusCode == 200) {
        Map<String, dynamic> data = jsonDecode(response.body);
        String role = data['result']['role'];
        int teacherId = data['result']['teacher']['teacherId'];
        String token = data['result']['token'];
        if (role == "teacher") {
          prefs.setInt('teacherId', teacherId);
          prefs.setString('token', token);
          return true;
        }
      }
    } catch (e) {
      print(e.toString());
    }
    return false;
  }
}
