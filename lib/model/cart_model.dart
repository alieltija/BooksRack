class CartModel {
  final String id;
  final String categoryId;
  final String name;
  final String price;
  final List images;
  final String description;
  final dynamic createdAt;
  final dynamic updatedAt;
  final int productQuantity;
  final double productTotalPrice;
  final String author;

  CartModel({
    required this.id,
    required this.categoryId,
    required this.name,
    required this.images,
    required this.description,
    required this.createdAt,
    required this.updatedAt,
    required this.productQuantity,
    required this.productTotalPrice,
    required this.price,
    required this.author,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'categoryId': categoryId,
      'name': name,
      'price': price,
      'images': images,
      "author": author,
      'description': description,
      'createdAt': createdAt,
      'updatedAt': updatedAt,
      'productQuantity': productQuantity,
      'productTotalPrice': productTotalPrice,
    };
  }

  factory CartModel.fromMap(Map<String, dynamic> json) {
    return CartModel(
      id: json["id"],
      categoryId: json['categoryId'],
      name: json['name'],
      price: json['price'],
      images: json['images'],
      description: json['description'],
      createdAt: json['createdAt'],
      updatedAt: json['updatedAt'],
      productQuantity: json['productQuantity'],
      productTotalPrice: json['productTotalPrice'],
      author: json["author"],
    );
  }
}
