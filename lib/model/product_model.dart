// ignore: camel_case_types
// ignore_for_file: prefer_collection_literals, unnecessary_new, unnecessary_this

class Productmodel {
  late String id;
  late String name;
  late List image;
  late bool isSale;
  late bool isFavourite;
  late String price;
  late String description;

  late String author;
  late String categoryId;

  Productmodel(
      {required this.id,
      required this.name,
      required this.image,
      required this.isFavourite,
      required this.price,
      required this.description,
      required this.isSale,
      required this.categoryId,
      required this.author});

  Productmodel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    image = json['image'];
    isSale = json['isSale'];
    categoryId = json["categoryId"];
    isFavourite = json['isFavourite'];
    price = json['price'];
    description = json['description'];

    author = json["author"];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data["categoryId"] = this.categoryId;
    data['name'] = this.name;
    data['isSale'] = this.isSale;
    data['image'] = this.image;
    data['isFavourite'] = this.isFavourite;
    data['price'] = this.price;
    data['description'] = this.description;

    data["author"] = this.author;
    return data;
  }
}
