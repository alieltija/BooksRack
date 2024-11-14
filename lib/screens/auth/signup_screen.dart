import 'package:booksrack/model/firebase_auth.dart';
import 'package:booksrack/screens/auth/signin_screen.dart';
import 'package:booksrack/widgets/circular_progress.dart';
import 'package:booksrack/widgets/txt_field_widget.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  SignUpScreenState createState() => SignUpScreenState();
}

class SignUpScreenState extends State<SignUpScreen> {
  final _formKey = GlobalKey<FormState>();
  final _fullNameController = TextEditingController();
  final _emailController = TextEditingController();
  final _locationController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  final _phoneNumberController = TextEditingController();

  bool _obsecuretext = true;

  bool isLoading = false;

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
                    Form(
                      key: _formKey,
                      child: Column(
                        children: [
                          const Gap(20),
                          Lottie.asset("assets/splashlogo.json", height: 200),
                          CustomTextFormField(
                            hintText: "Alex",
                            keyboardType: TextInputType.name,
                            icon: Icons.person_outline,
                            textInputAction: TextInputAction.next,
                            controller: _fullNameController,
                            obsecuretxt: false,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter your full name';
                              }
                              return null;
                            },
                            fieldname: 'Full name',
                          ),
                          const Gap(10),
                          CustomTextFormField(
                            hintText: "alex@gmail.com",
                            keyboardType: TextInputType.name,
                            icon: Icons.email_outlined,
                            textInputAction: TextInputAction.next,
                            controller: _emailController,
                            obsecuretxt: false,
                            validator: (value) {
                              if (value == null ||
                                  value.isEmpty ||
                                  !value.contains('@')) {
                                return 'Please enter a valid email address';
                              }
                              return null;
                            },
                            fieldname: 'Email',
                          ),
                          const SizedBox(height: 10),
                          CustomTextFormField(
                            hintText: "+92XXXXXXXXXX",
                            keyboardType: TextInputType.phone,
                            icon: Icons.phone,
                            textInputAction: TextInputAction.next,
                            controller: _phoneNumberController,
                            obsecuretxt: false,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter your phone number';
                              }
                              return null;
                            },
                            fieldname: 'Phone no.',
                          ),
                          const SizedBox(height: 10),
                          CustomTextFormField(
                            hintText: "Bahriya town, Lahore",
                            icon: Icons.location_on_outlined,
                            controller: _locationController,
                            fieldname: "Address",
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter your address';
                              }
                              return null;
                            },
                          ),
                          const SizedBox(height: 10),
                          CustomTextFormField(
                            hintText: "xyz12345",
                            keyboardType: TextInputType.visiblePassword,
                            icon: Icons.lock_outline,
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
                            textInputAction: TextInputAction.next,
                            controller: _passwordController,
                            obsecuretxt: _obsecuretext,
                            validator: (value) {
                              if (value == null ||
                                  value.isEmpty ||
                                  value.length < 8) {
                                return 'Please enter a password with at least 8 characters';
                              }
                              return null;
                            },
                            fieldname: 'Password',
                          ),
                          const SizedBox(height: 10),
                          CustomTextFormField(
                            hintText: "xyz12345",
                            keyboardType: TextInputType.visiblePassword,
                            icon: Icons.lock_outline,
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
                            textInputAction: TextInputAction.next,
                            controller: _confirmPasswordController,
                            obsecuretxt: _obsecuretext,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please confirm your password';
                              } else if (value != _passwordController.text) {
                                return 'Passwords do not match';
                              }
                              return null;
                            },
                            fieldname: 'Confirm password',
                          ),
                          const Gap(15),
                          ElevatedButton(
                            onPressed: () async {
                              if (_formKey.currentState!.validate()) {
                                setState(() {
                                  isLoading = true;
                                });

                                await AuthFunctions.signUp(
                                    _fullNameController.text,
                                    _emailController.text,
                                    _passwordController.text,
                                    "",
                                    _phoneNumberController.text,
                                    _locationController.text,
                                    context);

                                setState(() {
                                  isLoading = false;
                                });
                              }
                            },
                            style: ButtonStyle(
                                shape: WidgetStateProperty.all(
                                    RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(30))),
                                backgroundColor: const WidgetStatePropertyAll(
                                  Color(0xff5563AA),
                                ),
                                minimumSize: const WidgetStatePropertyAll(
                                    Size(double.infinity, 50))),
                            child: const Text(
                              "Sign Up",
                              style:
                                  TextStyle(color: Colors.white, fontSize: 20),
                            ),
                          ),
                          const Gap(15),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Text(
                                "Already have an account?",
                                style: TextStyle(
                                    fontSize: 15,
                                    color: Colors.black,
                                    fontWeight: FontWeight.w400),
                              ),
                              const Gap(5),
                              GestureDetector(
                                onTap: () {
                                  Get.offAll(() => const SignInScreen());
                                },
                                child: const Text(
                                  "Login!",
                                  style: TextStyle(
                                      fontSize: 16, color: Color(0xff5563AA)),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
  }
}
