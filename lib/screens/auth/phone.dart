import 'package:booksrack/screens/auth/verification.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class Phone extends StatelessWidget {
  Phone({super.key});
  final TextEditingController _phoneController = TextEditingController();
  final _auth = FirebaseAuth.instance;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Phone"),
      ),
      body: Column(
        children: [
          const Text("Phone"),
          TextField(
            controller: _phoneController,
            keyboardType: TextInputType.number,
            decoration: const InputDecoration(hintText: "+923065166443"),
          ),
          ElevatedButton(
            style: ButtonStyle(
                shape: WidgetStateProperty.all(RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10))),
                backgroundColor: const WidgetStatePropertyAll(
                  Color.fromARGB(255, 8, 255, 160),
                ),
                minimumSize: const WidgetStatePropertyAll(Size(80, 50))),
            onPressed: () {
              _auth.verifyPhoneNumber(
                  phoneNumber: _phoneController.text,
                  verificationCompleted: (_) {},
                  verificationFailed: (e) {
                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                      content: Text("$e"),
                    ));
                  },
                  codeSent: (String verificationId, int? token) {
                    Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                            builder: (context) => VerificationCode(
                                  varificationid: verificationId,
                                )));
                  },
                  codeAutoRetrievalTimeout: (e) {
                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                      content: Text(e),
                    ));
                  });
            },
            child: const Text(
              "Get Code",
              style: TextStyle(color: Colors.black, fontSize: 20),
            ),
          ),
        ],
      ),
    );
  }
}
