import 'dart:convert';

import 'package:self_order_qr_menu/Features/Menu/Domain/entities/category_entity.dart';

class CategoryModel extends CategoryEntity {
  CategoryModel({
    required super.categoryId,
    required super.categoryName,
    required super.description,
    required super.imageUrl,
    required super.isNonVeg,
    required super.isVeg,
  });

  /// Factory to create `CategoryModel` from JSON
  factory CategoryModel.fromJson(Map<String, dynamic> json) {
    return CategoryModel(
      categoryId: json["category_id"] as String? ?? "", // Default empty string for null
      categoryName: json["category_name"] as String? ?? "", // Default empty string for null
      description: json["description"] as String? ?? "", // Default empty string for null
      imageUrl: json["imageUrl"] as String? ?? "",
      // If imageUrl is a list of strings, convert it properly; else default to an empty string or a single string.
      isNonVeg: json["isNonVeg"] as bool? ?? false, // Default false for null
      isVeg: json["isVeg"] as bool? ?? false, // Default false for null
    );
  }

  /// Convert the `CategoryModel` to JSON
  Map<String, dynamic> toJson() {
    return {
      "category_id": categoryId,
      "category_name": categoryName,
      "description": description,
      "imageUrl": imageUrl,
      "isNonVeg": isNonVeg,
      "isVeg": isVeg,
    };
  }

  /// Convert `CategoryModel` to `CategoryEntity`
  CategoryEntity toEntity() {
    return CategoryEntity(
      categoryId: categoryId,
      categoryName: categoryName,
      description: description,
      imageUrl: imageUrl,
      isNonVeg: isNonVeg,
      isVeg: isVeg,
    );
  }
}
