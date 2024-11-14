// ignore_for_file: file_names, avoid_print, unused_local_variable, prefer_const_constructors

import 'package:booksrack/model/orders_model.dart';
import 'package:booksrack/screens/homepage_screen.dart';
import 'package:booksrack/services/generate_orderID.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';

void placeOrder({
  required BuildContext context,
  required String customerName,
  required String customerPhone,
  required String customerAddress,
  required String customerDeviceToken,
}) async {
  final user = FirebaseAuth.instance.currentUser;
  if (user != null) {
    try {
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection('cart')
          .doc(user.uid)
          .collection('cartOrders')
          .get();

      List<QueryDocumentSnapshot> documents = querySnapshot.docs;

      for (var doc in documents) {
        Map<String, dynamic>? data = doc.data() as Map<String, dynamic>;

        String orderId = generateOrderId();

        OrderModel cartModel = OrderModel(
          productId: data['productId'],
          categoryId: data['categoryId'],
          productName: data['productName'],
          categoryName: data['categoryName'],
          image: data['image'],
          isSale: data['isSale'],
          description: data['description'],
          createdAt: DateTime.now(),
          productQuantity: data['productQuantity'],
          price: data['price'],
          customerId: user.uid,
          status: false,
          customerName: customerName,
          customerPhone: customerPhone,
          customerAddress: customerAddress,
          customerDeviceToken: customerDeviceToken,
        );

        for (var x = 0; x < documents.length; x++) {
          await FirebaseFirestore.instance
              .collection('orders')
              .doc(user.uid)
              .set(
            {
              'uId': user.uid,
              'customerName': customerName,
              'customerPhone': customerPhone,
              'customerAddress': customerAddress,
              'customerDeviceToken': customerDeviceToken,
              'orderStatus': false,
              'createdAt': DateTime.now()
            },
          );

          //upload orders
          await FirebaseFirestore.instance
              .collection('orders')
              .doc(user.uid)
              .collection('confirmOrders')
              .doc(orderId)
              .set(cartModel.toMap());

          //delete cart products
          await FirebaseFirestore.instance
              .collection('cart')
              .doc(user.uid)
              .collection('cartOrders')
              .doc(cartModel.productId.toString())
              .delete()
              .then((value) {
            print('Delete cart Products $cartModel.productId.toString()');
          });
        }
        // save notification
        await FirebaseFirestore.instance
            .collection('notifications')
            .doc(user.uid)
            .collection('notifications')
            .doc()
            .set(
          {
            'title': "Order Successfully placed ${cartModel.productName}",
            'body': cartModel.description,
            'isSeen': false,
            'createdAt': DateTime.now(),
            'image': cartModel.image,
            'price': cartModel.price,
            'isSale': cartModel.isSale,
            'productId': cartModel.productId,
          },
        );
      }

      print("Order Confirmed");
      Get.snackbar(
        "Order Confirmed",
        "Thank you for your order!",
        backgroundColor: Colors.white70,
        colorText: Colors.black,
        duration: Duration(seconds: 5),
      );

      Get.offAll(() => HomeScreen());
    } catch (e) {
      print("error $e");
      Get.snackbar(
        "Error",
        "$e",
        backgroundColor: Colors.white70,
        colorText: Colors.black,
        duration: Duration(seconds: 5),
      );
    }
  }
}
