// ignore_for_file: must_be_immutable

import 'package:booksrack/model/cart_model.dart';
import 'package:booksrack/screens/checkOut/check_out_screen.dart';
import 'package:booksrack/widgets/circular_progress.dart';
import 'package:booksrack/widgets/productprice.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';

class CartScreen extends StatefulWidget {
  const CartScreen({super.key});

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  bool value = false;
  User? user = FirebaseAuth.instance.currentUser;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: const Text(
          "My Cart",
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24),
        ),
        leading: IconButton(
            onPressed: () {
              Get.back();
            },
            icon: const Icon(Icons.arrow_back)),
        centerTitle: true,
      ),
      body: SizedBox(
        child: StreamBuilder(
          stream: FirebaseFirestore.instance
              .collection('cart')
              .doc(user!.uid)
              .collection("cartOrders")
              .snapshots(), //change .get to snapshots when stream builder
          builder:
              (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
            if (snapshot.hasError) {
              return const Center(
                child: Text("Error"),
              );
            }
            if (snapshot.connectionState == ConnectionState.waiting) {
              return SizedBox(
                height: Get.height / 5,
                child: const Center(child: CircularProgress()),
              );
            }

            if (snapshot.data!.docs.isEmpty) {
              return const Center(
                child: Text(
                  "Your cart is empty!",
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                      color: Color(0xff5563AA)),
                ),
              );
            }

            if (snapshot.data != null) {
              return ListView.builder(
                primary: false, //smooth scroll
                shrinkWrap: true, //unbounded height
                scrollDirection: Axis.vertical,
                itemCount: snapshot.data!.docs.length,
                itemBuilder: (context, index) {
                  final productData = snapshot.data!.docs[index];
                  CartModel cartmodel = CartModel(
                    categoryId: productData['categoryId'],
                    id: productData['id'],
                    name: productData['name'],
                    //categoryName: productData['categoryName'],
                    price: productData['price'],
                    images: productData['images'],
                    description: productData['description'],
                    author: productData['author'],
                    createdAt: productData["createdAt"],
                    updatedAt: productData["updatedAt"],
                    productQuantity: productData["productQuantity"],
                    productTotalPrice: productData["productTotalPrice"],
                  );
                  ProductsPrice.fetchProductPrice();
                  return Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 4),
                      child: Card(
                        elevation: 2,
                        child: Container(
                          height: 100,
                          color: Colors.white,
                          child: Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 12.0),
                            child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Row(
                                    children: [
                                      //Gap(10),
                                      Image(
                                        image: NetworkImage(
                                          cartmodel.images[0],
                                        ),
                                        height: 100,
                                        width: 60,
                                      ),
                                      const Gap(20),
                                      Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          SizedBox(
                                            width: 140,
                                            child: Text(
                                              cartmodel.name,
                                              overflow: TextOverflow.ellipsis,
                                              style: const TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 18),
                                            ),
                                          ),
                                          const Gap(5),
                                          SizedBox(
                                            width: 140,
                                            child: Text(
                                              cartmodel.author,
                                              overflow: TextOverflow.ellipsis,
                                              style: const TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  color: Colors.grey,
                                                  fontSize: 16),
                                            ),
                                          ),
                                          const Gap(5),
                                          Text(
                                            "Rs: ${cartmodel.productTotalPrice}",
                                            style: const TextStyle(
                                                fontWeight: FontWeight.bold,
                                                fontSize: 16,
                                                color: Color(0xff5563AA)),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.end,
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.only(
                                            top: 5.0, right: 5),
                                        child: GestureDetector(
                                          onTap: () async {
                                            await FirebaseFirestore.instance
                                                .collection('cart')
                                                .doc(user!.uid)
                                                .collection('cartOrders')
                                                .doc(cartmodel.id)
                                                .delete();
                                          },
                                          child: const CircleAvatar(
                                            backgroundColor: Colors.red,
                                            radius: 15,
                                            child: Icon(
                                              Icons.delete,
                                              color: Colors.white,
                                            ),
                                          ),
                                        ),
                                      ),
                                      Padding(
                                        padding:
                                            const EdgeInsets.only(bottom: 5.0),
                                        child: Row(
                                          children: [
                                            GestureDetector(
                                              onTap: () async {
                                                if (cartmodel.productQuantity >
                                                    1) {
                                                  await FirebaseFirestore
                                                      .instance
                                                      .collection('cart')
                                                      .doc(user!.uid)
                                                      .collection('cartOrders')
                                                      .doc(cartmodel.id)
                                                      .update({
                                                    'productQuantity': cartmodel
                                                            .productQuantity -
                                                        1,
                                                    'productTotalPrice': (double
                                                            .parse(cartmodel
                                                                .price) *
                                                        (cartmodel
                                                                .productQuantity -
                                                            1))
                                                  });
                                                }
                                              },
                                              child: const CircleAvatar(
                                                radius: 14,
                                                backgroundColor:
                                                    Color(0xff5563AA),
                                                child: Icon(
                                                  Icons.remove,
                                                  color: Colors.white,
                                                  size: 18,
                                                ),
                                              ),
                                            ),
                                            const Gap(8),
                                            Text(
                                              cartmodel.productQuantity
                                                  .toString(),
                                              style: const TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 18),
                                            ),
                                            const Gap(8),
                                            GestureDetector(
                                              onTap: () async {
                                                if (cartmodel.productQuantity >
                                                    0) {
                                                  await FirebaseFirestore
                                                      .instance
                                                      .collection('cart')
                                                      .doc(user!.uid)
                                                      .collection('cartOrders')
                                                      .doc(cartmodel.id)
                                                      .update({
                                                    'productQuantity': cartmodel
                                                            .productQuantity +
                                                        1,
                                                    'productTotalPrice': double
                                                            .parse(cartmodel
                                                                .price) +
                                                        double.parse(cartmodel
                                                                .price) *
                                                            (cartmodel
                                                                .productQuantity)
                                                  });
                                                }
                                              },
                                              child: const CircleAvatar(
                                                radius: 14,
                                                backgroundColor:
                                                    Color(0xff5563AA),
                                                child: Icon(
                                                  Icons.add,
                                                  color: Colors.white,
                                                  size: 18,
                                                ),
                                              ),
                                            )
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ]),
                          ),
                        ),
                      ));
                },
              );
            }
            return Container();
          },
        ),
      ),
      bottomNavigationBar: Container(
        color: Colors.white,
        height: 110,
        width: Get.width,
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    "Sub Total",
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                  ),
                  Obx(
                    () => Text(
                      "Rs: ${ProductsPrice.totalPrice.value.toString()}",
                      style: const TextStyle(
                          fontWeight: FontWeight.bold, fontSize: 18),
                    ),
                  )
                ],
              ),
              ElevatedButton(
                onPressed: () {
                  Get.to(() => const CheckoutScreen());
                },
                style: ButtonStyle(
                  shape: WidgetStateProperty.all(RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30))),
                  backgroundColor: const WidgetStatePropertyAll(
                    Color(0xff5563AA),
                  ),
                  minimumSize: const WidgetStatePropertyAll(
                    Size(double.infinity, 50),
                  ),
                ),
                child: const Text(
                  "Order now",
                  style: TextStyle(color: Colors.white, fontSize: 20),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
