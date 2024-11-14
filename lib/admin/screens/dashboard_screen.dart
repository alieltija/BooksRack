import 'package:booksrack/admin/screens/all%20Dashhboard%20Screen/admin_show_screen.dart';
import 'package:booksrack/admin/screens/all%20Dashhboard%20Screen/books_update_screen.dart';
import 'package:booksrack/admin/screens/all%20Dashhboard%20Screen/categories_screen.dart';
import 'package:booksrack/admin/screens/all%20Dashhboard%20Screen/users_show_screen.dart';
import 'package:booksrack/screens/homepage_screen.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';

import '../../model/firebase_auth.dart';
import 'all Dashhboard Screen/add_book_screen.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Stream<DocumentSnapshot<Map<String, dynamic>>>? _userStream;

  @override
  void initState() {
    super.initState();
    User? currentUser = _auth.currentUser;

    if (currentUser != null) {
      _userStream =
          _firestore.collection('users').doc(currentUser.uid).snapshots();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        toolbarHeight: 60,
        iconTheme: const IconThemeData(color: Colors.white),
        backgroundColor: const Color(0xff5563AA),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(
            FontAwesomeIcons.houseUser,
            size: 25,
          ),
          onPressed: () => Get.offAll(const HomeScreen()),
        ),
        title: const Text(
          "Dashboard",
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 28,
          ),
        ),
        elevation: 2,
        shadowColor: Colors.black,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
            bottomLeft: Radius.circular(10),
            bottomRight: Radius.circular(10),
          ),
        ),
      ),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Column(
          children: [
            StreamBuilder<DocumentSnapshot<Map<String, dynamic>>>(
              stream: _userStream,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                } else if (!snapshot.hasData || snapshot.data?.data() == null) {
                  return const Center(child: Text('No user data available'));
                } else {
                  // Extract user data from Firestore document
                  final userData = snapshot.data!.data()!;
                  final String userName = userData['name'] ?? "Unknown User";
                  final String userEmail = userData['email'] ?? "No Email";
                  final String? imageUrl = userData['userImg'];
                  return Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 20, vertical: 10),
                    width: Get.width,
                    child: Card(
                      elevation: 10,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(45),
                      ),
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(50),
                          color: Colors.white,
                        ),
                        child: Column(
                          children: [
                            Row(
                              children: [
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 20, vertical: 20),
                                  child: CircleAvatar(
                                    backgroundColor: const Color(0xff5563AA),
                                    radius: 35,
                                    backgroundImage: imageUrl != null
                                        ? CachedNetworkImageProvider(
                                            imageUrl,
                                            errorListener: (err) {
                                              const Icon(Icons.error);
                                              print('Error $err');
                                            },
                                          ) // Display photo from URL
                                        : null, // Use null for no image
                                    child: imageUrl == null
                                        ? const Icon(
                                            // Show icon if no photo URL
                                            Icons.camera_alt_outlined,
                                            color: Colors.white,
                                          )
                                        : null,
                                  ),
                                ),
                                Flexible(
                                  child: Padding(
                                    padding: const EdgeInsets.only(right: 25),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          children: [
                                            const Icon(
                                              Icons.fiber_manual_record,
                                              color: Colors.grey,
                                              size: 18,
                                            ),
                                            const SizedBox(
                                              width: 10,
                                            ),
                                            Text(
                                              userName,
                                              style: const TextStyle(
                                                color: Colors.black,
                                                fontWeight: FontWeight.w700,
                                                fontSize: 18,
                                              ),
                                            ),
                                          ],
                                        ),
                                        const SizedBox(
                                          height: 10,
                                        ),
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          children: [
                                            const Icon(
                                              Icons.alternate_email,
                                              color: Color(0xff5563AA),
                                              size: 15,
                                            ),
                                            const SizedBox(
                                              width: 10,
                                            ),
                                            Expanded(
                                              child: Text(
                                                userEmail,
                                                style: const TextStyle(
                                                  color: Color(0xff5563AA),
                                                  fontWeight: FontWeight.w700,
                                                  fontSize: 11,
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                }
              },
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 10),
              child: Row(
                children: [
                  Container(
                    width: Get.width * 0.4,
                    height: 70,
                    decoration: BoxDecoration(
                      color: const Color(0xff5563AA),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 15, vertical: 15),
                      child: Row(
                        children: [
                          const Icon(
                            Icons.admin_panel_settings_outlined,
                            size: 30,
                            color: Colors.white,
                          ),
                          const Gap(8),
                          GestureDetector(
                            onTap: () {
                              Get.to(() => AdminShowScreen());
                            },
                            child: const Text(
                              "Admins",
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                  GestureDetector(
                    onTap: () {
                      Get.to(() => UsersShowScreen());
                    },
                    child: Container(
                      width: Get.width * 0.4,
                      height: 70,
                      decoration: BoxDecoration(
                        color: const Color(0xff5563AA),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: const Padding(
                        padding: EdgeInsets.all(20),
                        child: Row(
                          children: [
                            Icon(
                              FontAwesomeIcons.users,
                              size: 20,
                              color: Colors.white,
                            ),
                            Gap(20),
                            Text(
                              "Users",
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            GestureDetector(
              onTap: () {
                Get.to(() => UsersShowScreen());
              },
              child: Container(
                width: Get.width * 0.4,
                height: 70,
                decoration: BoxDecoration(
                  color: const Color(0xff5563AA),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: const Padding(
                  padding: EdgeInsets.all(20),
                  child: Row(
                    children: [
                      Icon(
                        FontAwesomeIcons.users,
                        size: 20,
                        color: Colors.white,
                      ),
                      Gap(20),
                      Text(
                        "Oders",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            const Gap(5),
            Padding(
              padding: const EdgeInsets.all(6.0),
              child: Container(
                height: 150,
                width: Get.width,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Card(
                  elevation: 15,
                  color: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Row(
                    children: [
                      const Padding(
                        padding: EdgeInsets.symmetric(
                          horizontal: 45,
                        ),
                        child: Column(
                          children: [
                            Padding(
                              padding: EdgeInsets.only(top: 14),
                              child: Icon(
                                FontAwesomeIcons.book,
                                size: 75,
                                color: Colors.grey,
                              ),
                            ),
                            Gap(7),
                            Text(
                              "Books",
                              style: TextStyle(
                                color: Colors.grey,
                                fontSize: 32,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Column(
                        children: [
                          const Gap(20),
                          ElevatedButton(
                            onPressed: () {
                              Get.to(() => const AddBook());
                            },
                            style: ElevatedButton.styleFrom(
                              minimumSize: const Size(130, 42),
                              backgroundColor: const Color(0xff5563AA),
                              foregroundColor: Colors.white,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                            child: const Text(
                              "Add",
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.w700,
                                fontSize: 17,
                              ),
                            ),
                          ),
                          const Gap(7),
                          ElevatedButton(
                            onPressed: () {
                              Get.to(() => const BooksUpdateScreen());
                            },
                            style: ElevatedButton.styleFrom(
                              minimumSize: const Size(130, 42),
                              backgroundColor: const Color(0xff5563AA),
                              foregroundColor: Colors.white,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                            child: const Text(
                              "Update",
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.w700,
                                fontSize: 17,
                              ),
                            ),
                          ),
                        ],
                      )
                    ],
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(6.0),
              child: Container(
                height: 150,
                width: Get.width,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Card(
                  elevation: 15,
                  color: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Row(
                    children: [
                      const Padding(
                        padding: EdgeInsets.symmetric(
                          horizontal: 26,
                        ),
                        child: Column(
                          children: [
                            Padding(
                              padding: EdgeInsets.only(top: 14),
                              child: Icon(
                                FontAwesomeIcons.list,
                                color: Colors.grey,
                                size: 75,
                              ),
                            ),
                            Gap(6),
                            Text(
                              "Category",
                              style: TextStyle(
                                color: Colors.grey,
                                fontSize: 31,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Column(
                        children: [
                          const Gap(47),
                          Center(
                            child: ElevatedButton(
                              onPressed: () {
                                Get.to(() => const CategoriesScreen());
                              },
                              style: ElevatedButton.styleFrom(
                                minimumSize: const Size(130, 42),
                                backgroundColor: const Color(0xff5563AA),
                                foregroundColor: Colors.white,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                              ),
                              child: const Text(
                                "Categories",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w700,
                                  fontSize: 16.5,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
            const Gap(10),
            ElevatedButton(
              onPressed: () {
                AuthFunctions.logout(context);
              },
              style: ElevatedButton.styleFrom(
                minimumSize: const Size(130, 45),
                backgroundColor: const Color(0xff5563AA),
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: const Text(
                "Logout",
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w700,
                  fontSize: 17,
                ),
              ),
            ),
            const Gap(10),
          ],
        ),
      ),
    );
  }
}
