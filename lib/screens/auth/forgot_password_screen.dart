// ignore_for_file: use_build_context_synchronously
import 'package:booksrack/model/firebase_auth.dart';
import 'package:booksrack/screens/auth/signin_screen.dart';
import 'package:booksrack/widgets/txt_field_widget.dart';
import 'package:flutter/material.dart';

import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';

class ForgotPassword extends StatefulWidget {
  const ForgotPassword({super.key});

  @override
  State<ForgotPassword> createState() => _ForgotPasswordState();
}

class _ForgotPasswordState extends State<ForgotPassword> {
  final TextEditingController _emailController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
            onPressed: () {
              Get.offAll(() => const SignInScreen());
            },
            icon: const Icon(Icons.arrow_back)),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 0),
        child: SingleChildScrollView(
          child: Column(
            children: [
              Lottie.asset("assets/splashlogo.json", height: 200),
              const Gap(10),
              const Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    "Forgot Password?",
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 25),
                  )),
              const Gap(5),
              const Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    "Enter your email\nto reset your password",
                    style: TextStyle(fontSize: 16),
                  )),
              const Gap(10),
              Form(
                  key: _formKey,
                  child: CustomTextFormField(
                    hintText: "alex@gmail.com",
                    icon: Icons.email,
                    controller: _emailController,
                    fieldname: "Email",
                    validator: (value) {
                      if (value == null ||
                          value.isEmpty ||
                          !value.contains('@')) {
                        return 'Please enter a valid email address';
                      }
                      return null;
                    },
                  )),
              const Gap(15),
              ElevatedButton(
                onPressed: () async {
                  if (_formKey.currentState!.validate()) {
                    await AuthFunctions.resetPassword(
                        _emailController.text.toString(), context);
                  }
                },
                style: ButtonStyle(
                    shape: WidgetStateProperty.all(RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30))),
                    backgroundColor:
                        const WidgetStatePropertyAll(Color(0xff5563AA)),
                    minimumSize: const WidgetStatePropertyAll(
                        Size(double.infinity, 50))),
                child: const Text(
                  "Send",
                  style: TextStyle(fontSize: 20, color: Colors.white),
                ),
              ),
              const Gap(20),
            ],
          ),
        ),
      ),
    );
  }
}
