// ignore_for_file: avoid_unnecessary_containers

import 'package:booksrack/admin/controllers/admin_show_controller';
import 'package:booksrack/model/user_model.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:get/get.dart';

class AdminShowScreen extends StatelessWidget {
  AdminShowScreen({super.key});

  final GetAdminLengthController _getAdminLengthController =
      Get.put(GetAdminLengthController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        centerTitle: true,
        title: Obx(() {
          return Text(
            'Users (${_getAdminLengthController.userCollectionLength.toString()})',
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 24,
              letterSpacing: 0.5,
            ),
          );
        }),
      ),
      body: FutureBuilder(
        future: FirebaseFirestore.instance
            .collection('users')
            .where('isAdmin', isEqualTo: true)
            .get(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasError) {
            return Container(
              child: const Center(
                child: Text('Error occurred while fetching admins!'),
              ),
            );
          }
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Container(
              child: const Center(
                child: Center(
                  child: SpinKitCircle(
                    color: Color(0xff5663AA),
                  ),
                ),
              ),
            );
          }
          if (snapshot.data!.docs.isEmpty) {
            return Container(
              child: const Center(
                child: Text("No admin found!"),
              ),
            );
          }
          if (snapshot.data != null) {
            return ListView.builder(
                shrinkWrap: true,
                physics: const BouncingScrollPhysics(),
                itemCount: snapshot.data!.docs.length,
                itemBuilder: (context, index) {
                  final data = snapshot.data!.docs[index];

                  UserModel userModel = UserModel(
                      uId: data['uId'],
                      username: data['username'],
                      email: data['email'],
                      phone: data['phone'],
                      userImg: data['userImg'],
                      userDeviceToken: data['userDeviceToken'],
                      userAddress: data['userAddress'],
                      isAdmin: data['isAdmin'],
                      isActive: data['isActive'],
                      createdOn: data['createdOn']);

                  return Padding(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 10, vertical: 2),
                    child: Card(
                      color: Colors.white,
                      elevation: 5,
                      child: ListTile(
                        leading: CircleAvatar(
                          backgroundColor: const Color(0xff5563AA),
                          backgroundImage: CachedNetworkImageProvider(
                              userModel.userImg, errorListener: (err) {
                            const Icon(Icons.error);
                            print('Error $err');
                          }),
                        ),
                        title: Text(userModel.username),
                        subtitle: Text(userModel.email),
                        trailing: const Icon(Icons.edit),
                      ),
                    ),
                  );
                });
          }
          return Container();
        },
      ),
    );
  }
}
