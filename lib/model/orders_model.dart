// ignore_for_file: file_names

class OrderModel {
  final String productId;
  final String categoryId;
  final String productName;
  final String categoryName;
  final String price;
  final List image;

  final bool isSale;
  final String description;
  final dynamic createdAt;

  final int productQuantity;

  final String customerId;
  final bool status;
  final String customerName;
  final String customerPhone;
  final String customerAddress;
  final String customerDeviceToken;

  OrderModel({
    required this.productId,
    required this.categoryId,
    required this.productName,
    required this.categoryName,
    required this.createdAt,
    required this.isSale,
    required this.image,
    required this.customerAddress,
    required this.description,
    required this.price,
    required this.productQuantity,
    required this.customerId,
    required this.status,
    required this.customerName,
    required this.customerPhone,
    required this.customerDeviceToken,
  });

  Map<String, dynamic> toMap() {
    return {
      'productId': productId,
      'categoryId': categoryId,
      'productName': productName,
      'categoryName': categoryName,
      'isSale': isSale,
      'createdAt': createdAt,
      'productQuantity': productQuantity,
      'customerId': customerId,
      'status': status,
      'customerName': customerName,
      'customerPhone': customerPhone,
      'customerAddress': customerAddress,
      'customerDeviceToken': customerDeviceToken,
    };
  }

  factory OrderModel.fromMap(Map<String, dynamic> json) {
    return OrderModel(
      productId: json['productId'],
      categoryId: json['categoryId'],
      productName: json['productName'],
      categoryName: json['categoryName'],
      isSale: json['isSale'],
      price: json['price'],
      createdAt: json['createdAt'],
      description: json['description'],
      productQuantity: json['productQuantity'],
      image: json['image'],
      customerId: json['customerId'],
      status: json['status'],
      customerName: json['customerName'],
      customerPhone: json['customerPhone'],
      customerAddress: json['customerAddress'],
      customerDeviceToken: json['customerDeviceToken'],
    );
  }
}
