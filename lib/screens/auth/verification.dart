// ignore_for_file: use_build_context_synchronously

import 'package:booksrack/screens/homepage_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class VerificationCode extends StatelessWidget {
  final String varificationid;
  VerificationCode({super.key, required this.varificationid});
  final TextEditingController _phoneController = TextEditingController();
  final _auth = FirebaseAuth.instance;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Verify code"),
      ),
      body: Column(
        children: [
          const Text("code"),
          TextField(
            controller: _phoneController,
            decoration: const InputDecoration(hintText: "123456"),
          ),
          ElevatedButton(
            style: ButtonStyle(
                shape: WidgetStateProperty.all(RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10))),
                backgroundColor: const WidgetStatePropertyAll(
                  Color.fromARGB(255, 8, 255, 160),
                ),
                minimumSize: const WidgetStatePropertyAll(Size(80, 50))),
            onPressed: () async {
              final credential = PhoneAuthProvider.credential(
                  verificationId: varificationid,
                  smsCode: _phoneController.text.toString());
              try {
                await _auth.signInWithCredential(credential);
                Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const HomeScreen()));
              } catch (e) {
                ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                  content: Text("$e"),
                ));
              }
            },
            child: const Text(
              "SignIn",
              style: TextStyle(color: Colors.black, fontSize: 20),
            ),
          ),
        ],
      ),
    );
  }
}
