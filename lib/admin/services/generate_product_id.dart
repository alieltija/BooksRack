import 'package:uuid/uuid.dart';

class GenerateIds {
  String generateProductId() {
    String formatedProductId;
    String uuid = const Uuid().v4();

    // customize id
    formatedProductId = "BooksRack ${uuid.substring(0, 9)}";

    // return
    return formatedProductId;
  }
}
