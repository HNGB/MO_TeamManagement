import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:team_management/screens/login.dart';
import 'package:team_management/screens/main_page.dart';

import '../components/loading.dart';

class StartPage extends StatefulWidget {
  const StartPage({super.key});

  @override
  StartPageState createState() => StartPageState();
}

class StartPageState extends State<StartPage> {
  bool loading = true;

  @override
  void initState() {
    super.initState();
    loadData().then((value) {
      setState(() {
        loading = false;
      });
    });
  }

  Future<void> loadData() async {
    // Đọc dữ liệu từ các tài nguyên và tệp tin, kiểm tra quyền truy cập, cập nhật các trạng thái liên quan đến ứng dụng, ...
    // Ví dụ:
    await Future.delayed(Duration(seconds: 2)); // Giả lập đang tải dữ liệu
  }

  @override
  Widget build(BuildContext context) {
    return loading
        ? const LoadingImage()
        : Scaffold(
            body: StreamBuilder(
                stream: FirebaseAuth.instance.authStateChanges(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (snapshot.hasData) {
                    return const MyHomePage();
                  } else if (snapshot.hasError) {
                    return const Center(child: Text('Something went wrong!'));
                  } else {
                    return const LoginPage();
                  }
                }),
          );
  }
}
