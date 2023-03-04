import 'package:firebase_messaging/firebase_messaging.dart';

Future<String?> getFcmToken() async {
  String? fcmkey = await FirebaseMessaging.instance.getToken();
  return fcmkey;
}
