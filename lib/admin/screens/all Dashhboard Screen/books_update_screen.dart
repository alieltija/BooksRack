import 'package:booksrack/admin/controllers/switch_sale_controller.dart';
import 'package:booksrack/admin/screens/all%20Dashhboard%20Screen/edit_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import '../../../model/product_model.dart';
import '../../../widgets/circular_progress.dart';
import '../../../widgets/custom_search_deligate.dart';
import '../../controllers/get_category_controller.dart';

class BooksUpdateScreen extends StatefulWidget {
  const BooksUpdateScreen({super.key});

  @override
  State<BooksUpdateScreen> createState() => _BooksUpdateScreenState();
}

class _BooksUpdateScreenState extends State<BooksUpdateScreen> {
  late Future<QuerySnapshot> _productsFuture;

  @override
  void initState() {
    super.initState();
    _fetchProducts(); // Fetch products initially when screen loads
  }

  // Method to fetch products
  void _fetchProducts() {
    setState(() {
      _productsFuture = FirebaseFirestore.instance
          .collection('products')
          .orderBy('categoryId', descending: true)
          .get();
    });
  }

  // Function to delete a product
  void deleteProduct(String productId) {
    FirebaseFirestore.instance
        .collection('products')
        .doc(productId)
        .delete()
        .then((_) {
      // After deletion, re-fetch products to refresh the UI
      _fetchProducts();
      Get.snackbar('Success', 'Product deleted successfully');
    }).catchError((error) {
      Get.snackbar('Error', 'Failed to delete product');
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        centerTitle: true,
        title: const Text(
          'Update',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 24,
            letterSpacing: 0.5,
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
            ),
          ),
          const Gap(10),
        ],
      ),
      body: FutureBuilder<QuerySnapshot>(
        future: _productsFuture,
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasError) {
            return const Center(
              child: Text("Error"),
            );
          }
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Container(
              color: Colors.white,
              height: Get.height,
              child: const CircularProgress(),
            );
          }

          if (snapshot.data!.docs.isEmpty) {
            return const Padding(
              padding: EdgeInsets.only(top: 80.0),
              child: Center(
                  child: Text(
                "No products available!",
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
                primary: false, // smooth scroll
                shrinkWrap: true, // unbounded height
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    mainAxisSpacing: 2,
                    crossAxisSpacing: 10,
                    crossAxisCount: 2,
                    childAspectRatio: 0.5),
                scrollDirection: Axis.vertical,
                itemCount: snapshot.data!.docs.length,
                itemBuilder: (context, index) {
                  final data = snapshot.data!.docs[index];
                  Productmodel productModel = Productmodel(
                    categoryId: data['categoryId'],
                    id: data['id'],
                    name: data['name'],
                    price: data['price'],
                    image: data['image'],
                    isSale: data['isSale'],
                    description: data['description'],
                    isFavourite: data['isFavourite'],
                    author: data['author'],
                  );
                  return GestureDetector(
                    onTap: () {},
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
                              height: 180,
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
                          Padding(
                            padding: const EdgeInsets.all(12),
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
                                PopupMenuButton<String>(
                                  color: Colors.white,
                                  onSelected: (value) {
                                    if (value == 'edit') {
                                      final editProductCategoryId =
                                          Get.put(GetCategoryController());
                                      final isSalevalue =
                                          Get.put(IsSaleController());

                                      isSalevalue
                                          .toggleoldvalue(productModel.isSale);

                                      editProductCategoryId
                                          .setOldValue(productModel.categoryId);

                                      // Navigate to edit screen or show edit dialog
                                      Get.to(
                                        () => EditScreen(
                                            productModel: productModel),
                                      );
                                      Get.snackbar(
                                        "Edit",
                                        "Edit ${productModel.name}",
                                        backgroundColor: Colors.white70,
                                        duration:
                                            const Duration(milliseconds: 1600),
                                      );
                                    } else if (value == 'delete') {
                                      // Show confirmation dialog before deleting
                                      showDialog(
                                        context: context,
                                        builder: (context) => AlertDialog(
                                          backgroundColor: Colors.white,
                                          title: const Text('Delete Product'),
                                          content: const Text(
                                              'Are you sure you want to delete this product?'),
                                          actions: [
                                            TextButton(
                                              onPressed: () {
                                                Navigator.pop(
                                                    context); // Close dialog
                                              },
                                              child: const Text('Cancel'),
                                            ),
                                            TextButton(
                                              onPressed: () {
                                                deleteProduct(productModel.id);
                                                Navigator.pop(
                                                    context); // Close dialog
                                              },
                                              child: const Text('Delete'),
                                            ),
                                          ],
                                        ),
                                      );
                                    }
                                  },
                                  itemBuilder: (context) => [
                                    const PopupMenuItem(
                                      value: 'edit',
                                      child: Text(
                                        'Edit',
                                        style: TextStyle(
                                          color: Color(0xff5563AA),
                                          fontSize: 17,
                                          fontWeight: FontWeight.w700,
                                        ),
                                      ),
                                    ),
                                    const PopupMenuItem(
                                      value: 'delete',
                                      child: Text(
                                        'Delete',
                                        style: TextStyle(
                                          color: Colors.red,
                                          fontSize: 17,
                                          fontWeight: FontWeight.w700,
                                        ),
                                      ),
                                    ),
                                  ],
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
    );
  }
}
