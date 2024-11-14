import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controllers/get_category_controller.dart';

class DropdownCategory extends StatelessWidget {
  const DropdownCategory({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<GetCategoryController>(
      init: GetCategoryController(),
      builder: (categoriesDropDownController) {
        return Column(
          children: [
            Card(
              elevation: 10,
              color: Colors.grey.shade300,
              child: Padding(
                padding: const EdgeInsets.all(5),
                child: DropdownButton<String>(
                  borderRadius: const BorderRadius.all(
                    Radius.circular(20),
                  ),
                  value: categoriesDropDownController.selectedCategoryId?.value,
                  items:
                      categoriesDropDownController.categories.map((category) {
                    return DropdownMenuItem<String>(
                      value: category['categoryId'],
                      child: Padding(
                        padding: const EdgeInsets.all(5),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const SizedBox(width: 20),
                            Text(category['categoryName']),
                          ],
                        ),
                      ),
                    );
                  }).toList(),
                  onChanged: (String? selectedValue) async {
                    categoriesDropDownController
                        .setSelectedCategory(selectedValue);
                    String? categoryName = await categoriesDropDownController
                        .getCategoryName(selectedValue);
                    categoriesDropDownController
                        .setSelectedCategoryName(categoryName);
                  },
                  hint: const Text(
                    'Select category',
                    style: TextStyle(
                      color: Color(0xff5563AA),
                    ),
                  ),
                  isExpanded: false,
                  elevation: 10,
                  underline: const SizedBox.shrink(),
                  focusColor: const Color(0xff5563AA),
                  dropdownColor: Colors.grey.shade300,
                  iconDisabledColor: Colors.grey,
                  iconEnabledColor: const Color(0xff5563AA),
                  style: const TextStyle(
                    color: Color(0xff5563AA),
                    fontSize: 17,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}
