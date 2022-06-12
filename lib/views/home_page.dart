import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:parking_reservation/views/dashboard_page.dart';
import 'package:parking_reservation/views/login_page.dart';

class Home extends StatefulWidget {
  Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  // initialize firebase auth
  FirebaseAuth auth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    auth.userChanges().listen((user) {
      if (user == null)
        // Get.to(() => LoginPage());
        Get.off(() => LoginPage());
      else
        Get.off(() => DashboardPage());
      // Get.to(() => DashboardPage());
    });

    return Scaffold(
      body: SafeArea(
        child: Container(
          child: Center(
            child: Text("Authenticating ..."),
          ),
        ),
      ),
    );
  }
}
