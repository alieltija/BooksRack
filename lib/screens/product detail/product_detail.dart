// ignore_for_file: must_be_immutable, use_build_context_synchronously

import 'package:booksrack/screens/auth/signin_screen.dart';
import 'package:booksrack/screens/homepage_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:get/get.dart';
import '../../model/cart_model.dart';
import '../../model/product_model.dart';
import '../cart/cart_screen.dart';

class ProductDetails extends StatefulWidget {
  Productmodel productmodel;
  ProductDetails({
    super.key,
    required this.productmodel,
  });

  @override
  State<ProductDetails> createState() => _ProductDetailsState();
}

class _ProductDetailsState extends State<ProductDetails> {
  bool isLoading = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        leading: IconButton(
            onPressed: () {
              Get.offAll(() => const HomeScreen());
            },
            icon: const Icon(Icons.arrow_back)),
        title: Text(
          widget.productmodel.name,
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 25),
        ),
        centerTitle: true,
        actions: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 0),
            child: IconButton(
              onPressed: () {},
              icon: const Icon(Icons.bookmark, size: 25),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 0, right: 12.0),
            child: IconButton(
              onPressed: () {
                Get.to(() => const CartScreen());
              },
              icon: const Icon(Icons.shopping_cart_outlined, size: 25),
            ),
          )
        ],
      ),
      body: ListView(
        children: [
          const SizedBox(
            height: 10,
          ),
          SizedBox(
            height: 220,
            width: double.infinity,
            child: Stack(
              children: [
                Positioned(
                  top: 0,
                  child: Image.network(
                    widget.productmodel.image[0],
                    opacity: const AlwaysStoppedAnimation(.2),
                    height: 220,
                    width: MediaQuery.of(context).size.width,
                    fit: BoxFit.cover,
                  ),
                ),
                Positioned(
                  top: 10,
                  left: 30,
                  child: Card(
                    elevation: 5,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10)),
                    margin: const EdgeInsets.symmetric(horizontal: 85),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: Image.network(
                        widget.productmodel.image[0],
                        height: 200,
                        fit: BoxFit.fill,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text(
                        "Author: ",
                        style: TextStyle(
                            fontSize: 18, color: Color.fromARGB(255, 6, 6, 8)),
                      ),
                      Text(
                        widget.productmodel.author,
                        style: const TextStyle(
                            fontSize: 18,
                            color: Color(0xff5563AA),
                            fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Row(
                        children: [
                          Icon(
                            Icons.star,
                            color: Colors.amber,
                          ),
                          Text(
                            " 4.5   ",
                            style: TextStyle(
                                fontSize: 16,
                                color: Color.fromARGB(255, 6, 6, 8)),
                          ),
                        ],
                      ),
                      Container(
                        color: Colors.black45,
                        height: 20,
                        width: 2,
                      ),
                      const Row(
                        children: [
                          Text(
                            "   pages",
                            style: TextStyle(fontSize: 16, color: Colors.grey),
                          ),
                          Text(
                            " 450   ",
                            style: TextStyle(
                                fontSize: 16,
                                color: Color.fromARGB(255, 6, 6, 8)),
                          ),
                        ],
                      ),
                      Container(
                        color: Colors.black45,
                        height: 20,
                        width: 2,
                      ),
                      const Row(
                        children: [
                          Text(
                            "   Language",
                            style: TextStyle(fontSize: 16, color: Colors.grey),
                          ),
                          Text(
                            " Urdu   ",
                            style: TextStyle(
                                fontSize: 16,
                                color: Color.fromARGB(255, 6, 6, 8)),
                          ),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  const Text(
                    "Description",
                    style: TextStyle(
                        fontSize: 20,
                        color: Color.fromARGB(255, 9, 10, 12),
                        fontWeight: FontWeight.bold),
                  ),
                  Text(
                    widget.productmodel.description,
                    style: const TextStyle(
                      fontSize: 16,
                      color: Colors.grey,
                    ),
                  ),
                ],
              ),
            ),
          )
        ],
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 10),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              "Rs: ${widget.productmodel.price.toString()}",
              style: const TextStyle(
                  fontSize: 24,
                  color: Colors.black,
                  fontWeight: FontWeight.bold),
            ),
            ElevatedButton(
                style: ButtonStyle(
                  minimumSize: const WidgetStatePropertyAll(Size(150, 45)),
                  maximumSize: const WidgetStatePropertyAll(Size(150, 45)),
                  shape: WidgetStateProperty.all(RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30))),
                  backgroundColor: const WidgetStatePropertyAll(
                    Color(0xff5563AA),
                  ),
                ),
                onPressed: () async {
                  final user = FirebaseAuth
                      .instance.currentUser; // Check user authentication
                  if (user != null) {
                    // User is logged in
                    setState(() {
                      isLoading = true;
                    });
                    await checkProductExistence(id: user.uid);
                    setState(() {
                      isLoading = false;
                    });
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        backgroundColor: Colors.white70,
                        content: Text(
                          "Product added to cart",
                          style: TextStyle(color: Colors.black),
                        ),
                      ),
                    );
                  } else {
                    // User is not logged in
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        backgroundColor: Colors.white70,
                        content: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text(
                              "Login to countinue!",
                              style: TextStyle(color: Colors.black),
                            ),
                            GestureDetector(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          const SignInScreen()),
                                );
                              },
                              child: Container(
                                decoration: BoxDecoration(
                                    color: const Color(0xff5563AA),
                                    borderRadius: BorderRadius.circular(30)),
                                height: 30,
                                width: 100,
                                child: const Center(child: Text("Login")),
                              ),
                            )
                          ],
                        ),
                      ),
                    );
                  }
                },
                child: isLoading
                    ? const SpinKitCircle(
                        color: Colors.white,
                        size: 40,
                      )
                    // ignore: prefer_const_constructors
                    : Row(
                        children: const [
                          Icon(
                            Icons.local_grocery_store_outlined,
                            color: Colors.white,
                          ),
                          SizedBox(
                            width: 5,
                          ),
                          Text(
                            "Add to cart",
                            style: TextStyle(color: Colors.white),
                          )
                        ],
                      ))
          ],
        ),
      ),
    );
  }

  Future<void> checkProductExistence({
    required String id,
    int quantityIncrement = 1,
  }) async {
    final DocumentReference documentReference = FirebaseFirestore.instance
        .collection('cart')
        .doc(id)
        .collection('cartOrders')
        .doc(widget.productmodel.id.toString());

    DocumentSnapshot snapshot = await documentReference.get();

    if (snapshot.exists) {
      int currentQuantity = snapshot['productQuantity'];
      int updatedQuantity = currentQuantity + quantityIncrement;
      double totalPrice =
          double.parse(widget.productmodel.price.toString()) * updatedQuantity;

      await documentReference.update({
        'productQuantity': updatedQuantity,
        'productTotalPrice': totalPrice
      });

      print("product exists");
    } else {
      await FirebaseFirestore.instance.collection('cart').doc(id).set(
        {
          'id': id,
          'createdAt': DateTime.now(),
        },
      );

      CartModel cartModel = CartModel(
        id: widget.productmodel.id,
        categoryId: widget.productmodel.categoryId,
        name: widget.productmodel.name,
        price: widget.productmodel.price.toString(),
        images: widget.productmodel.image,
        description: widget.productmodel.description,
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
        productQuantity: 1,
        productTotalPrice: double.parse(widget.productmodel.price.toString()),
        author: widget.productmodel.author,
      );

      await documentReference.set(cartModel.toMap());

      print("product added");
    }
  }
}
