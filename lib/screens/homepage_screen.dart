// ignore_for_file: unused_import

import 'package:booksrack/model/catagories_model.dart';
import 'package:booksrack/model/product_model.dart';
import 'package:booksrack/screens/product%20detail/product_detail.dart';
import 'package:booksrack/widgets/circular_progress.dart';
import 'package:booksrack/widgets/drawer.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';

import '../widgets/custom_search_deligate.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final imgList = [
    'assets/img1.jpg',
    'assets/img2.jpg',
    'assets/img3.jpg',
  ];

  var scaffoldKey = GlobalKey<ScaffoldState>();
  DocumentSnapshot? selectedCategory;

  // @override
  // void initState() {
  //   super.initState();
  //   FirebaseFirestore.instance.collection('categories').get().then((snapshot) {
  //     if (snapshot.docs.isNotEmpty) {
  //       selectedCategory = snapshot.docs[0];
  //     }
  //   });
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
      backgroundColor: Colors.white,
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(
            Icons.menu,
            size: 30,
          ),
          onPressed: () => scaffoldKey.currentState!.openDrawer(),
        ),
        toolbarHeight: 60,
        iconTheme: const IconThemeData(color: Colors.white),
        backgroundColor: const Color(0xff5563AA),
        title: const Text(
          "BooksRack",
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 30,
          ),
        ),
        elevation: 2,
        shadowColor: Colors.black,
        centerTitle: true,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
            bottomLeft: Radius.circular(10),
            bottomRight: Radius.circular(10),
          ),
        ),
        actions: [
          IconButton(
              onPressed: () {
                showSearch(
                  context: context,
                  delegate: CustomSearchDelegate(),
                );
              },
              icon: const Icon(
                Icons.search,
                size: 30,
              )),
          const Gap(10),
        ],
      ),
      drawer: DrawerWidget(),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: ListView(
          children: [
            const Gap(5),
            CarouselSlider.builder(
              itemCount: imgList.length,
              itemBuilder: (context, index, realIndex) {
                final images = imgList[index];
                return Card(
                  elevation: 5,
                  child: Image.asset(
                    images,
                    fit: BoxFit.fill,
                  ),
                );
              },
              options: CarouselOptions(
                height: 200,

                autoPlay: true,
                //reverse: true,
                //viewportFraction: 1,
                enlargeCenterPage: true,
                enableInfiniteScroll: true,
                //autoPlayInterval: const Duration(seconds: 3),
              ),
            ),
            const Gap(5),
            const Text(
              "Categories",
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
            ),
            FutureBuilder(
              future: FirebaseFirestore.instance.collection('categories').get(),
              builder: (BuildContext context,
                  AsyncSnapshot<QuerySnapshot> snapshot) {
                if (snapshot.hasError) {
                  return const Center(
                    child: Text("Error"),
                  );
                }
                // if (snapshot.connectionState == ConnectionState.waiting) {
                //   return const SizedBox(
                //     height: 50,
                //     child: Center(
                //       child: LoadingScreen(),
                //     ),
                //   );
                // }

                // if (snapshot.data!.docs.isEmpty) {
                //   return const Center(
                //     child: Text("No category found!"),
                //   );
                // }

                if (snapshot.data != null) {
                  return SizedBox(
                    height: 50,
                    child: ListView.builder(
                      itemCount: snapshot.data!.docs.length +
                          1, // Add 1 for the "All" chip
                      shrinkWrap: true,
                      scrollDirection: Axis.horizontal,
                      itemBuilder: (context, index) {
                        if (index == 0) {
                          // The "All" chip
                          return Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 3.0),
                            child: GestureDetector(
                              onTap: () {
                                setState(() {
                                  selectedCategory =
                                      null; // or DocumentSnapshot(id: 'All')
                                });
                              },
                              child: Chip(
                                label: Text(
                                  "All",
                                  style: TextStyle(
                                    color: selectedCategory == null
                                        ? Colors.white
                                        : Colors.black,
                                  ),
                                ),
                                backgroundColor: selectedCategory == null
                                    ? const Color(0xff5563AA)
                                    : Colors.white,
                                side:
                                    const BorderSide(color: Color(0xff5563AA)),
                                shape: const RoundedRectangleBorder(
                                  borderRadius: BorderRadius.all(
                                    Radius.circular(30),
                                  ),
                                ),
                              ),
                            ),
                          );
                        } else {
                          final category = snapshot.data!.docs[index -
                              1]; // Subtract 1 because of the "All" chip
                          CategoriesModel categoriesModel = CategoriesModel(
                            categoryId: snapshot.data!.docs[index - 1]
                                ['categoryId'],
                            categoryName: snapshot.data!.docs[index - 1]
                                ['categoryName'],
                          );
                          return Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 3.0),
                            child: GestureDetector(
                              onTap: () {
                                setState(() {
                                  selectedCategory = category;
                                });
                              },
                              child: Chip(
                                label: Text(
                                  categoriesModel.categoryName,
                                  style: TextStyle(
                                    color: selectedCategory?.id == category.id
                                        ? Colors.white
                                        : Colors.black,
                                  ),
                                ),
                                backgroundColor:
                                    selectedCategory?.id == category.id
                                        ? const Color(0xff5563AA)
                                        : Colors.white,
                                side:
                                    const BorderSide(color: Color(0xff5563AA)),
                                shape: const RoundedRectangleBorder(
                                  borderRadius: BorderRadius.all(
                                    Radius.circular(30),
                                  ),
                                ),
                              ),
                            ),
                          );
                        }
                      },
                    ),
                  );
                }

                return Container();
              },
            ),
            const Gap(5),
            const Text(
              "Availabe Products",
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
            ),
            FutureBuilder(
              future: selectedCategory != null
                  ? FirebaseFirestore.instance
                      .collection('products')
                      .where('categoryId', isEqualTo: selectedCategory?.id)
                      .get()
                  : FirebaseFirestore.instance.collection('products').get(),
              builder: (BuildContext context,
                  AsyncSnapshot<QuerySnapshot> snapshot) {
                if (snapshot.hasError) {
                  return const Center(
                    child: Text("Error"),
                  );
                }
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Container(
                    color: Colors.white,
                    height: Get.height / 3,
                    child: const CircularProgress(),
                  );
                }

                if (snapshot.data!.docs.isEmpty) {
                  return const Padding(
                    padding: EdgeInsets.only(top: 80.0),
                    child: Center(
                        child: Text(
                      "No products availables!",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                        color: Color(0xff5563AA),
                      ),
                    )),
                  );
                }

                if (snapshot.data != null) {
                  return GridView.builder(
                      primary: false, //smooth scroll
                      shrinkWrap: true, //unbounded height
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                              mainAxisSpacing: 2,
                              crossAxisSpacing: 10,
                              crossAxisCount: 2,
                              childAspectRatio: 0.6),
                      scrollDirection: Axis.vertical,
                      itemCount: snapshot.data!.docs.length,
                      itemBuilder: (context, index) {
                        final productData = snapshot.data!.docs[index];
                        Productmodel productModel = Productmodel(
                          categoryId: productData['categoryId'],
                          id: productData['id'],
                          name: productData['name'],
                          isSale: productData['isSale'],
                          //categoryName: productData['categoryName'],
                          price: productData['price'],
                          image: productData['image'],
                          description: productData['description'],
                          isFavourite: productData['isFavourite'],

                          author: productData['author'],
                        );
                        return GestureDetector(
                          onTap: () {
                            Get.offAll(
                              () => ProductDetails(
                                productmodel: productModel,
                              ),
                            );
                          },
                          child: Card(
                            elevation: 3,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10)),
                            color: Colors.white,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Center(
                                  child: SizedBox(
                                    height: 170,
                                    width: 140,
                                    child: Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 4.0),
                                      child: ClipRRect(
                                        borderRadius: BorderRadius.circular(5),
                                        child: Image.network(
                                          productModel.image[0].toString(),
                                          fit: BoxFit.fill,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                                const Gap(5),
                                Padding(
                                  padding: const EdgeInsets.only(
                                      left: 12.0, right: 12),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      SizedBox(
                                        width: 160,
                                        child: Text(
                                          productModel.name,
                                          //overflow: TextOverflow.ellipsis,
                                          style: const TextStyle(
                                              color: Color(0xff5563AA),
                                              fontSize: 16,
                                              fontWeight: FontWeight.bold),
                                        ),
                                      ),
                                      Text(
                                        productModel.author,
                                        style: const TextStyle(
                                          fontWeight: FontWeight.bold,
                                          color: Colors.grey,
                                        ),
                                      ),
                                      Text(
                                        "Rs: ${productModel.price.toString()}",
                                        style: const TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 16,
                                          color: Colors.black,
                                        ),
                                      ),
                                    ],
                                  ),
                                )
                              ],
                            ),
                          ),
                        );
                      });
                }
                return Container();
              },
            ),
          ],
        ),
      ),
    );
  }
}
