class CategoriesModel {
  final String categoryId;
  final String categoryName;

  CategoriesModel({
    required this.categoryId,
    required this.categoryName,
  });

  // Serialize the UserModel instance to a JSON map
  Map<String, dynamic> toMap() {
    return {
      'categoryId': categoryId,
      'categoryName': categoryName,
    };
  }

  // Create a UserModel instance from a JSON map
  factory CategoriesModel.fromMap(Map<String, dynamic> json) {
    return CategoriesModel(
      categoryId: json['categoryId'],
      categoryName: json['categoryName'],
    );
  }
}
