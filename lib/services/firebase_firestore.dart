import 'package:booksrack/model/catagories_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class FirebaseFirestoreHelper {
  static FirebaseFirestoreHelper instance = FirebaseFirestoreHelper();
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  BuildContext? get context => null;
  Future<List<CategoriesModel>> getCategories() async {
    try {
      QuerySnapshot<Map<String, dynamic>> querySnapshot =
          await _firestore.collection("catagories").get();

      List<CategoriesModel> categoriesList = querySnapshot.docs
          .map((e) => CategoriesModel.fromMap(e.data()))
          .toList();
      return categoriesList;
    } catch (e) {
      String e = "some error occured";
      e = e.toString();
      return [];
    }
  }
}
