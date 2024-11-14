import 'package:booksrack/model/product_model.dart';
import 'package:booksrack/screens/product%20detail/product_detail.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';

class CustomSearchDelegate extends SearchDelegate {
  late Productmodel? productModel;

  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(
        icon: const Icon(Icons.clear),
        onPressed: () {
          query = ''; // Clear the search query
        },
      ),
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.arrow_back),
      onPressed: () {
        close(context, null); // Close the search
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    // StreamBuilder listens to real-time changes in Firestore collection 'products'
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance.collection('products').snapshots(),
      builder: (context, snapshot) {
        // Check if there is data from Firestore
        if (snapshot.hasData) {
          // Filter products based on search query (case-insensitive)
          final List<DocumentSnapshot> filteredProducts = snapshot.data!.docs
              .where((product) => product['name']
                  .toString()
                  .toLowerCase()
                  .contains(query.toLowerCase()))
              .toList();

          // If no products match the search query, show a message
          if (filteredProducts.isEmpty) {
            return const Center(
              child: Text("No products found!"),
            );
          }

          // Display the filtered list of products with a white background
          return Container(
            color: Colors.white, // Set the background color to white
            child: GridView.builder(
              itemCount: filteredProducts.length,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                mainAxisSpacing: 2,
                crossAxisSpacing: 10,
                crossAxisCount: 2,
                childAspectRatio: 0.6,
              ),
              primary: false, // smooth scroll
              shrinkWrap: true,
              scrollDirection: Axis.vertical,
              itemBuilder: (context, index) {
                DocumentSnapshot product = filteredProducts[index];

                // Create the ProductModel once per product
                Productmodel productModel = Productmodel(
                  categoryId: product['categoryId'],
                  id: product['id'],
                  name: product['name'],
                  isSale: product['isSale'],
                  price: product['price'],
                  image: product['image'],
                  description: product['description'],
                  isFavourite: product['isFavourite'],
                  author: product['author'],
                );

                return GestureDetector(
                  onTap: () {
                    // Handle navigation to the ProductDetails page with the correct ProductModel
                    Get.offAll(
                        () => ProductDetails(productmodel: productModel));
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
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 4.0),
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
                          padding: const EdgeInsets.only(left: 12.0, right: 12),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              SizedBox(
                                width: 160,
                                child: Text(
                                  productModel.name,
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
              },
            ),
          );
        } else {
          // Show a loading indicator if waiting for data
          return const Center(
            child: CircularProgressIndicator(),
          );
        }
      },
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    // StreamBuilder listens to real-time changes for suggestions as the user types
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance.collection('products').snapshots(),
      builder: (context, snapshot) {
        // Check if there is data from Firestore
        if (snapshot.hasData) {
          // Filter products based on search query (case-insensitive)
          final List<DocumentSnapshot> filteredProducts = snapshot.data!.docs
              .where((product) => product['name']
                  .toString()
                  .toLowerCase()
                  .contains(query.toLowerCase()))
              .toList();

          // If no products match the search query, show a message
          if (filteredProducts.isEmpty) {
            return const Center(
              child: Text("No suggestions available!"),
            );
          }

          // Display the filtered list of product suggestions as a grid with a white background
          return Container(
            color: Colors.white, // Set the background color to white
            child: GridView.builder(
              itemCount: filteredProducts.length,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                mainAxisSpacing: 2,
                crossAxisSpacing: 10,
                crossAxisCount: 2,
                childAspectRatio: 0.6,
              ),
              primary: false, // smooth scroll
              shrinkWrap: true,
              scrollDirection: Axis.vertical,
              itemBuilder: (context, index) {
                DocumentSnapshot product = filteredProducts[index];

                // Create the ProductModel for each product
                Productmodel productModel = Productmodel(
                  categoryId: product['categoryId'],
                  id: product['id'],
                  name: product['name'],
                  isSale: product['isSale'],
                  price: product['price'],
                  image: product['image'],
                  description: product['description'],
                  isFavourite: product['isFavourite'],
                  author: product['author'],
                );

                return GestureDetector(
                  onTap: () {
                    // Handle navigation to the ProductDetails page with the correct ProductModel
                    Get.offAll(
                        () => ProductDetails(productmodel: productModel));
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
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 4.0),
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
                          padding: const EdgeInsets.only(left: 12.0, right: 12),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              SizedBox(
                                width: 160,
                                child: Text(
                                  productModel.name,
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
              },
            ),
          );
        } else {
          // Show a loading indicator if waiting for data
          return const Center(
            child: CircularProgressIndicator(),
          );
        }
      },
    );
  }
}
