import 'package:booksrack/model/firebase_auth.dart';
import 'package:booksrack/screens/auth/signup_screen.dart';
import 'package:booksrack/widgets/circular_progress.dart';
import 'package:booksrack/widgets/txt_field_widget.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';

import 'forgot_password_screen.dart';

class SignInScreen extends StatefulWidget {
  const SignInScreen({super.key});
  @override
  SignInScreenState createState() => SignInScreenState();
}

class SignInScreenState extends State<SignInScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  bool isLoading = false;

  bool _obsecuretext = true;

  @override
  Widget build(BuildContext context) {
    return isLoading
        ? const CircularProgress()
        : Scaffold(
            body: Padding(
              padding: const EdgeInsets.all(20.0),
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    const Gap(80),
                    Lottie.asset("assets/splashlogo.json", height: 200),
                    const Gap(10),
                    Form(
                      key: _formKey,
                      child: Column(
                        children: [
                          CustomTextFormField(
                            hintText: 'alex@gmail.com',
                            icon: Icons.email_outlined,
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
                          ),
                          const SizedBox(height: 10),
                          CustomTextFormField(
                            hintText: "xyz12345",
                            icon: Icons.lock_outline,
                            controller: _passwordController,
                            fieldname: "Password",
                            obsecuretxt: _obsecuretext,
                            suffixicn: IconButton(
                              onPressed: () {
                                setState(() {
                                  _obsecuretext = !_obsecuretext;
                                });
                              },
                              icon: _obsecuretext
                                  ? const Icon(
                                      Icons.visibility_off,
                                      color: Color(0xff5563AA),
                                    )
                                  : const Icon(
                                      Icons.remove_red_eye,
                                      color: Color(0xff5563AA),
                                    ),
                            ),
                            validator: (value) {
                              if (value == null ||
                                  value.isEmpty ||
                                  value.length < 8) {
                                return 'Please enter a password with at least 8 characters';
                              }
                              return null;
                            },
                          ),
                          const SizedBox(height: 10),
                          GestureDetector(
                            onTap: () {
                              Get.offAll(const ForgotPassword());
                            },
                            child: const Align(
                              alignment: Alignment.centerRight,
                              child: Text(
                                "Forgot Password?",
                                style: TextStyle(
                                  fontSize: 15,
                                  color: Color(0xff5563AA),
                                ),
                              ),
                            ),
                          ),
                          const Gap(10),
                          ElevatedButton(
                            onPressed: () async {
                              if (_formKey.currentState!.validate()) {
                                setState(() {
                                  isLoading = true;
                                });

                                await AuthFunctions.login(_emailController.text,
                                    _passwordController.text, context);

                                setState(() {
                                  isLoading = false;
                                });
                              }
                            },
                            style: ButtonStyle(
                              shape: WidgetStateProperty.all(
                                RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(30),
                                ),
                              ),
                              backgroundColor: const WidgetStatePropertyAll(
                                Color(0xff5563AA),
                              ),
                              minimumSize: const WidgetStatePropertyAll(
                                Size(double.infinity, 50),
                              ),
                            ),
                            child: const Text(
                              "Sign In",
                              style:
                                  TextStyle(color: Colors.white, fontSize: 20),
                            ),
                          ),
                          const Gap(15),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Text(
                                "Don't have an account?",
                                style: TextStyle(
                                    fontSize: 15,
                                    color: Colors.black,
                                    fontWeight: FontWeight.w400),
                              ),
                              const Gap(5),
                              GestureDetector(
                                onTap: () {
                                  Get.offAll(() => const SignUpScreen());
                                },
                                child: const Text(
                                  "Register Here",
                                  style: TextStyle(
                                    fontSize: 16,
                                    color: Color(0xff5563AA),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    // const Gap(10),
                    // CircleAvatar(
                    //   child: IconButton(
                    //       onPressed: () {
                    //         Get.offAll(() => Phone());
                    //       },
                    //       icon: const Icon(
                    //         Icons.phone_android_rounded,
                    //       )),
                    // ),
                  ],
                ),
              ),
            ),
          );
  }
}
