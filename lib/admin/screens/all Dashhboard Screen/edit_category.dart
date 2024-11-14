// ignore_for_file: must_be_immutable

import 'package:booksrack/model/catagories_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:gap/gap.dart';

class EditCategory extends StatefulWidget {
  CategoriesModel categoriesModel;
  EditCategory({super.key, required this.categoriesModel});

  @override
  State<EditCategory> createState() => _EditCategoryState();
}

class _EditCategoryState extends State<EditCategory> {
  late bool isloading = false;
  final _formKey = GlobalKey<FormState>();
  TextEditingController categoryController = TextEditingController();

  @override
  void initState() {
    super.initState();

    categoryController.text = widget.categoriesModel.categoryName;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        centerTitle: true,
        title: Text(
          'Edit ${widget.categoriesModel.categoryName}',
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 24,
            letterSpacing: 0.5,
          ),
        ),
      ),
      body: Form(
        key: _formKey,
        child: Column(
          children: [
            const Gap(50),
            Container(
              height: 70,
              padding: const EdgeInsets.all(10),
              child: TextFormField(
                validator: (value) {
                  if (value == null || value.isEmpty) {}
                  return null;
                },
                cursorColor: const Color(0xff5563AA),
                textInputAction: TextInputAction.next,
                controller: categoryController,
                decoration: const InputDecoration(
                  contentPadding: EdgeInsets.symmetric(horizontal: 12),
                  hintText: 'Edit',
                  hintStyle: TextStyle(
                    fontSize: 15,
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.all(
                      Radius.circular(20),
                    ),
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(10),
              child: ElevatedButton(
                onPressed: () async {
                  try {
                    if (_formKey.currentState!.validate()) {
                      setState(() {
                        isloading = true;
                      });
                      CategoriesModel categoriesModel = CategoriesModel(
                          categoryId: widget.categoriesModel.categoryId,
                          categoryName: categoryController.text.trim());

                      await FirebaseFirestore.instance
                          .collection('categories')
                          .doc(categoriesModel.categoryId)
                          .update(categoriesModel.toMap());
                      setState(() {
                        isloading = false;
                      });
                    }
                  } catch (e) {
                    print('Error = $e');
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
                child: isloading
                    ? const SpinKitCircle(
                        color: Colors.white,
                        size: 40,
                      )
                    : const Text(
                        "Update",
                        style: TextStyle(color: Colors.white, fontSize: 20),
                      ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
