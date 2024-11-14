import 'package:booksrack/firebase_options.dart';
import 'package:booksrack/screens/splash%20screen/splash_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  try {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
    runApp(const MyApp());
  } catch (e) {
    // ignore: avoid_print
    print('Error: $e');
  }
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'BooksRack',
      theme: ThemeData(fontFamily: "Poppins-Medium"),
      debugShowCheckedModeBanner: false,
      home: const Splash(),
    );
  }
}
