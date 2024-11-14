// ignore_for_file: use_build_context_synchronously

import 'dart:io';

import 'package:booksrack/admin/controllers/get_category_controller.dart';
import 'package:booksrack/admin/controllers/switch_sale_controller.dart';
import 'package:booksrack/admin/screens/dashboard_screen.dart';
import 'package:booksrack/model/product_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

import '../../Widgets/dropDown_category.dart';
import '../../services/generate_product_id.dart';

class AddBook extends StatefulWidget {
  const AddBook({super.key});

  @override
  State<AddBook> createState() => _AddBookState();
}

class _AddBookState extends State<AddBook> {
  IsSaleController isSaleController = IsSaleController();
  GetCategoryController getCategoryController =
      Get.put(GetCategoryController());

  TextEditingController productNameController = TextEditingController();
  TextEditingController authorNameController = TextEditingController();
  TextEditingController priceController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();

  File? _image;
  late bool isloading = false;
  final _formKey = GlobalKey<FormState>();
  final FirebaseStorage storageRef = FirebaseStorage.instance;
  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  final ImagePicker _picker = ImagePicker();

  selectImage() async {
    final XFile? pickedFile =
        await _picker.pickImage(source: ImageSource.gallery);
    setState(() {
      if (pickedFile != null) {
        _image = File(pickedFile.path);
      } else {
        _image = null;
      }
    });
  }

  uploadFile() async {
    String productId = GenerateIds().generateProductId();
    print(productId);
    final ref =
        storageRef.ref().child('productsImages').child('ImageOf($productId)');
    await ref.putFile(_image!);
    final url = await ref.getDownloadURL();
    Productmodel productmodel = Productmodel(
        id: productId,
        name: productNameController.text.trim(),
        isSale: isSaleController.isSale.value,
        image: [url.toString()],
        isFavourite: false,
        price: priceController.text.trim(),
        description: descriptionController.text.trim(),
        categoryId: getCategoryController.selectedCategoryId.toString(),
        author: authorNameController.text.trim());

    await FirebaseFirestore.instance
        .collection('products')
        .doc(productId)
        .set(productmodel.toJson());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        centerTitle: true,
        title: const Text(
          "Add",
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 24,
            letterSpacing: 0.5,
          ),
        ),
      ),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              Row(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(left: 35, right: 5),
                    child: Container(
                      child: _image != null
                          ? Stack(
                              children: [
                                Container(
                                  height: Get.height / 5.5,
                                  width: Get.width / 3,
                                  decoration: BoxDecoration(
                                    border: Border.all(
                                        color: const Color(0xff5563AA),
                                        width: 3),
                                    borderRadius: const BorderRadius.all(
                                      Radius.circular(5),
                                    ),
                                  ),
                                  child: Image.file(
                                    _image!,
                                    fit: BoxFit.cover,
                                    filterQuality: FilterQuality.high,
                                  ),
                                ),
                                Positioned(
                                  right: 10,
                                  top: 5,
                                  child: InkWell(
                                    onTap: () {
                                      setState(() {
                                        _image = null;
                                      });
                                    },
                                    child: const CircleAvatar(
                                      radius: 8,
                                      backgroundColor: Colors.transparent,
                                      child: Icon(
                                        Icons.close,
                                        size: 20,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            )
                          : Container(
                              height: Get.height / 5.5,
                              width: Get.width / 3,
                              decoration: BoxDecoration(
                                border: Border.all(
                                    color: const Color(0xff5563AA), width: 3),
                                borderRadius: const BorderRadius.all(
                                  Radius.circular(8),
                                ),
                              ),
                              child: Center(
                                child: GestureDetector(
                                  onTap: () {
                                    selectImage();
                                  },
                                  child: const Text(
                                    '    +\nimage',
                                    style: TextStyle(
                                        fontSize: 17,
                                        fontWeight: FontWeight.w500),
                                  ),
                                ),
                              ),
                            ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(
                      top: 90,
                    ),
                    child: SizedBox(
                      width: Get.width / 1.8,
                      child: const DropdownCategory(),
                    ),
                  ),
                ],
              ),
              const Gap(10),
              GetBuilder<IsSaleController>(
                init: IsSaleController(),
                builder: (isSaleController) {
                  return Card(
                    color: Colors.white,
                    elevation: 5,
                    child: Padding(
                      padding: const EdgeInsets.all(10),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            'Is Sale',
                            style: TextStyle(
                              fontSize: 19,
                              color: Color(0xff5563AA),
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Switch(
                            value: isSaleController.isSale.value,
                            activeColor: const Color(0xff5563AA),
                            onChanged: (value) {
                              isSaleController.toggleIsSale(value);
                            },
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
              const Gap(5),
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
                  controller: productNameController,
                  decoration: const InputDecoration(
                    contentPadding: EdgeInsets.symmetric(horizontal: 12),
                    hintText: 'Product name',
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
                  controller: authorNameController,
                  decoration: const InputDecoration(
                    contentPadding: EdgeInsets.symmetric(horizontal: 12),
                    hintText: 'Author name',
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
                  keyboardType: TextInputType.number,
                  controller: priceController,
                  decoration: const InputDecoration(
                    contentPadding: EdgeInsets.symmetric(horizontal: 12),
                    hintText: 'Price',
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
              Container(
                height: 180,
                padding: const EdgeInsets.all(10),
                child: TextFormField(
                  validator: (value) {
                    if (value == null || value.isEmpty) {}
                    return null;
                  },
                  cursorColor: const Color(0xff5563AA),
                  textInputAction: TextInputAction.newline,
                  textAlign: TextAlign.start,
                  controller: descriptionController,
                  minLines: null,
                  maxLines: null,
                  expands: true,
                  decoration: const InputDecoration(
                    contentPadding:
                        EdgeInsets.symmetric(horizontal: 12, vertical: 5),
                    hintText: 'Description',
                    hintStyle: TextStyle(
                      fontSize: 16,
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
                      if (_image != null) {
                        if (getCategoryController.selectedCategoryId != null) {
                          if (_formKey.currentState!.validate()) {
                            setState(() {
                              isloading = true;
                            });
                            await uploadFile();
                            setState(() {
                              isloading = false;
                            });
                          }
                        }
                        Get.offAll(() => const DashboardScreen());
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text(
                              'Product is added',
                              style: TextStyle(color: Colors.black),
                            ),
                            backgroundColor: Colors.white70,
                          ),
                        );
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text(
                              'An image and all the field must be required',
                              style: TextStyle(color: Colors.black),
                            ),
                            backgroundColor: Colors.white70,
                          ),
                        );
                      }
                    } catch (e) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(
                            '$e',
                            style: const TextStyle(color: Colors.black),
                          ),
                          backgroundColor: Colors.white70,
                        ),
                      );
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
                          "Upload",
                          style: TextStyle(color: Colors.white, fontSize: 20),
                        ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
