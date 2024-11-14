// ignore_for_file: must_be_immutable, use_build_context_synchronously

import 'package:booksrack/admin/controllers/get_category_controller.dart';
import 'package:booksrack/admin/controllers/switch_sale_controller.dart';
import 'package:booksrack/model/product_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';

import '../dashboard_screen.dart';

class EditScreen extends StatefulWidget {
  Productmodel productModel;
  EditScreen({super.key, required this.productModel});

  @override
  State<EditScreen> createState() => _EditScreenState();
}

class _EditScreenState extends State<EditScreen> {
  late bool isloading = false;
  final _formKey = GlobalKey<FormState>();

  GetCategoryController getCategoryController =
      Get.put(GetCategoryController());

  IsSaleController isSaleController = Get.put(IsSaleController());

  TextEditingController productNameController = TextEditingController();

  TextEditingController authorNameController = TextEditingController();

  TextEditingController priceController = TextEditingController();

  TextEditingController descriptionController = TextEditingController();

  @override
  void initState() {
    super.initState();

    productNameController.text = widget.productModel.name;
    authorNameController.text = widget.productModel.author;
    priceController.text = widget.productModel.price;
    descriptionController.text = widget.productModel.description;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        centerTitle: true,
        title: Text(
          'Edit ${widget.productModel.name}',
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 24,
            letterSpacing: 0.5,
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              const Gap(10),
              Center(
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 35, vertical: 5),
                  child: Container(
                    height: Get.height / 3.5,
                    width: Get.width / 2,
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: const Color(0xff5563AA),
                        width: 3,
                      ),
                      borderRadius: const BorderRadius.all(Radius.circular(5)),
                    ),
                    child: Image.network(
                      widget.productModel.image[0],
                      width: MediaQuery.of(context).size.width,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              ),
              const Gap(10),
              GetBuilder<GetCategoryController>(
                init: GetCategoryController(),
                builder: (categoriesDropDownController) {
                  return Column(
                    children: [
                      Card(
                        elevation: 10,
                        color: Colors.grey.shade300,
                        child: Padding(
                          padding: const EdgeInsets.all(5),
                          child: DropdownButton<String>(
                            borderRadius: const BorderRadius.all(
                              Radius.circular(20),
                            ),
                            value: categoriesDropDownController
                                .selectedCategoryId?.value,
                            items: categoriesDropDownController.categories
                                .map((category) {
                              return DropdownMenuItem<String>(
                                value: category['categoryId'],
                                child: Padding(
                                  padding: const EdgeInsets.all(5),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      const SizedBox(width: 20),
                                      Text(category['categoryName']),
                                    ],
                                  ),
                                ),
                              );
                            }).toList(),
                            onChanged: (String? selectedValue) async {
                              categoriesDropDownController
                                  .setSelectedCategory(selectedValue);
                              String? categoryName =
                                  await categoriesDropDownController
                                      .getCategoryName(selectedValue);
                              categoriesDropDownController
                                  .setSelectedCategoryName(categoryName);
                            },
                            hint: const Text(
                              'Select category',
                              style: TextStyle(
                                color: Color(0xff5563AA),
                              ),
                            ),
                            isExpanded: true,
                            elevation: 10,
                            underline: const SizedBox.shrink(),
                            focusColor: const Color(0xff5563AA),
                            dropdownColor: Colors.grey.shade300,
                            iconDisabledColor: Colors.grey,
                            iconEnabledColor: const Color(0xff5563AA),
                            style: const TextStyle(
                              color: Color(0xff5563AA),
                              fontSize: 17,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ],
                  );
                },
              ),
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
              Column(
                children: [
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
                        // ProductModel
                        Productmodel newProductModel = Productmodel(
                            id: widget.productModel.id,
                            name: productNameController.text.trim(),
                            image: widget.productModel.image,
                            isFavourite: false,
                            price: priceController.text.trim(),
                            description: descriptionController.text.trim(),
                            isSale: isSaleController.isSale.value,
                            categoryId: getCategoryController.selectedCategoryId
                                .toString(),
                            author: authorNameController.text.trim());

                        try {
                          if (getCategoryController.selectedCategoryId !=
                              null) {
                            if (_formKey.currentState!.validate()) {
                              setState(() {
                                isloading = true;
                              });
                              await FirebaseFirestore.instance
                                  .collection('products')
                                  .doc(widget.productModel.id)
                                  .update(newProductModel.toJson());
                              setState(() {
                                isloading = false;
                              });
                            }

                            Get.offAll(() => const DashboardScreen());
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text(
                                  'Product is updated',
                                  style: TextStyle(color: Colors.black),
                                ),
                                backgroundColor: Colors.white70,
                              ),
                            );
                          } else {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text(
                                  'please complete all the required fields',
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
                              "Update",
                              style:
                                  TextStyle(color: Colors.white, fontSize: 20),
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
}
