// ignore_for_file: use_build_context_synchronously, must_be_immutable

import 'dart:async';
import 'package:booksrack/admin/controllers/get_user_controller.dart';
import 'package:booksrack/admin/screens/dashboard_screen.dart';
import 'package:booksrack/screens/homepage_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';

class Splash extends StatefulWidget {
  const Splash({
    super.key,
  });

  @override
  State<Splash> createState() => _SplashState();
}

class _SplashState extends State<Splash> {
  User? user = FirebaseAuth.instance.currentUser;
  @override
  void initState() {
    super.initState();
    Timer(const Duration(seconds: 3), () {
      loggding(context);
    });
  }

  Future<void> loggding(BuildContext context) async {
    if (user != null) {
      final GetUserDataController getUserDataController =
          Get.put(GetUserDataController());
      var userData = await getUserDataController.getUserData(user!.uid);

      if (userData[0]['isAdmin'] == true) {
        Get.offAll(() => const DashboardScreen());
      } else {
        Get.offAll(() => const HomeScreen());
      }
    } else {
      Get.to(() => const HomeScreen());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(
              height: 180,
              width: Get
                  .width, //getx width of device ,add GetMaterialApp in main.dart page
              child: Lottie.asset("assets/splashlogo.json")),
          const Text(
            "BooksRack",
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 30),
          )
        ],
      ),
    ));
  }
}
