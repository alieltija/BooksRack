// ignore_for_file: must_be_immutable

import 'package:booksrack/admin/controllers/get_user_controller.dart';
import 'package:booksrack/admin/screens/dashboard_screen.dart';
import 'package:booksrack/model/firebase_auth.dart';
import 'package:booksrack/screens/auth/signin_screen.dart';
import 'package:booksrack/screens/cart/cart_screen.dart';
import 'package:booksrack/screens/profile/profile_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class DrawerWidget extends StatelessWidget {
  DrawerWidget({super.key});
  User? user = FirebaseAuth.instance.currentUser;

  final GetUserDataController getUserDataController =
      Get.put(GetUserDataController());

  // Function to check if the user is admin
  // Stream<bool> isAdmin() async* {
  //   if (user != null) {
  //     // Get user data from Firestore and convert to stream
  //     var userData = await getUserDataController.getUserData(user!.uid);
  //     yield userData[0]['isAdmin'] == true; // Emit the 'isAdmin' status
  //   } else {
  //     yield false; // If user is null, emit false
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: Colors.white,
      child: Column(
        children: [
          Container(
            height: 180,
            width: Get.width,
            color: const Color(0xff5563AA),
            child: const Padding(
              padding: EdgeInsets.all(10.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CircleAvatar(
                    radius: 50,
                    backgroundImage: NetworkImage(
                        "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQpd4mJRIUwqgE8D_Z2znANEbtiz4GhI4M8NQ&s"),
                  ),
                  Text(
                    "Ali",
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.bold),
                  ),
                  Text(
                    "ali76@gmail.com",
                    style: TextStyle(color: Colors.white),
                  )
                ],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                user != null
                    ? DrawerTile(
                        text: 'My Profile',
                        icn: Icons.person_outline,
                        onpressed: () {
                          Get.to(const ProfileScreen());
                        })
                    : Container(),
                DrawerTile(
                    text: 'My Cart',
                    icn: Icons.shopping_cart_outlined,
                    onpressed: () {
                      if (user == null) {
                        showDialog(
                          context: context,
                          builder: (context) {
                            return AlertDialog(
                              title: const Text("Login Required"),
                              content: const Text("Please login to continue."),
                              actions: [
                                ElevatedButton(
                                  child: const Text("Login"),
                                  onPressed: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              const SignInScreen()),
                                    );
                                  },
                                ),
                              ],
                            );
                          },
                        );
                      } else {
                        Get.to(const CartScreen());
                      }
                    }),
                // Conditionally show Admin Panel if user is an admin
                StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
                  stream: FirebaseFirestore.instance
                      .collection('users')
                      .where('uId',
                          isEqualTo: FirebaseAuth.instance.currentUser!
                              .uid) // Query for current user
                      .snapshots(), // Listen to Firestore snapshots
                  builder: (context, snapshot) {
                    if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                      return Container();
                    }

                    // Fetch user data from the snapshot
                    var userData = snapshot.data!.docs[0].data();
                    bool isAdmin =
                        userData['isAdmin'] == true; // Check if user is admin

                    if (isAdmin) {
                      return DrawerTile(
                        text: 'Admin Panel',
                        icn: Icons.admin_panel_settings_outlined,
                        onpressed: () {
                          // Navigate to admin panel screen
                          Get.offAll(() => const DashboardScreen());
                        },
                      );
                    } else {
                      return DrawerTile(
                        text: 'Contact Us',
                        icn: Icons.contact_phone_outlined,
                        onpressed: () {},
                      );
                    }
                  },
                ),

                user != null
                    ? DrawerTile(
                        text: 'Log Out',
                        icn: Icons.logout,
                        onpressed: () {
                          AuthFunctions.logout(context);
                        })
                    : DrawerTile(
                        text: 'Log In',
                        icn: Icons.logout,
                        onpressed: () {
                          Get.offAll(const SignInScreen());
                        }),
              ],
            ),
          )
        ],
      ),
    );
  }
}

class DrawerTile extends StatelessWidget {
  const DrawerTile({
    super.key,
    required this.text,
    required this.icn,
    required this.onpressed,
  });
  final String text;
  final IconData icn;
  final Function()? onpressed;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        children: [
          Icon(
            icn,
            color: const Color(0xff5563AA),
          ),
          const SizedBox(
            width: 50,
          ),
          GestureDetector(
            onTap: onpressed,
            child: Text(
              text,
              style: const TextStyle(fontSize: 18, color: Color(0xff5563AA)),
            ),
          ),
        ],
      ),
    );
  }
}
