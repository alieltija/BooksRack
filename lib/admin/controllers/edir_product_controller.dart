// ignore_for_file: file_names, avoid_print

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:get/get.dart';

import '../../model/product_model.dart';

class EditProductController extends GetxController {
  Productmodel productModel;
  EditProductController({
    required this.productModel,
  });
  String image = '';

  @override
  void onInit() {
    super.onInit();
    getRealTimeImages();
  }

  void getRealTimeImages() {
    FirebaseFirestore.instance
        .collection('products')
        .doc(productModel.id)
        .snapshots()
        .listen((DocumentSnapshot snapshot) {
      if (snapshot.exists) {
        final data = snapshot.data() as Map<String, dynamic>?;
        if (data != null && data['image'] != null) {
          image = data['image'];
          update();
        }
      }
    });
  }

  //delete images
  Future deleteImagesFromStorage(String imageUrl) async {
    final FirebaseStorage storage = FirebaseStorage.instance;
    try {
      Reference reference = storage.refFromURL(imageUrl);
      await reference.delete();
    } catch (e) {
      print("Error $e");
    }
  }

  //collection
  Future<void> deleteImageFromFireStore(
      String imageUrl, String productId) async {
    try {
      await FirebaseFirestore.instance
          .collection('products')
          .doc(productId)
          .update({
        'image': FieldValue.arrayRemove([imageUrl])
      });
      update();
    } catch (e) {
      print("Error $e");
    }
  }
}
