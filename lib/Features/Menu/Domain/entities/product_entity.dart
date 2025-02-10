import 'package:cloud_firestore/cloud_firestore.dart';

class VariationEntity {
  String name;
  double price;
  bool isVeg;

  VariationEntity(
      {required this.name, required this.price, required this.isVeg});

  Map<String, dynamic> toJson() {
    return {"name": name, "price": price, "isVeg": isVeg};
  }

  @override
  String toString() {
    return 'VariationEntity{name: $name, price: $price, isVeg: $isVeg}';
  }
}

class ProductEntity {
  String categoryId;
  String productId;
  String name;
  bool isVeg;
  bool isNonVeg;
  bool isOutOfStock;
  bool isCustomizable;
  bool hasVariation;
  double basePrice;
  String description;
  List<String> imageUrl;
  Timestamp createdAt;
  Timestamp updatedAt;
  List<VariationEntity> variations;

  ProductEntity({
    required this.productId,
    required this.categoryId,
    required this.name,
    required this.description,
    required this.basePrice,
    required this.isCustomizable,
    required this.hasVariation,
    required this.isVeg,
    required this.isNonVeg,
    required this.isOutOfStock,
    required this.imageUrl,
    required this.createdAt,
    required this.updatedAt,
    required this.variations,
  });

  Map<String, dynamic> toJson() {
    return {
      'product_id': productId,
      'category_id': categoryId,
      'name': name,
      'isVeg': isVeg,
      'isNonVeg': isNonVeg, // Fixed the mapping here
      'isOutOfStock': isOutOfStock,
      'isCustomizable': isCustomizable,
      'hasVariation': hasVariation,
      'basePrice': basePrice,
      'description': description,
      'imageUrl': imageUrl,
      "created_at": createdAt.seconds, // Handle as seconds
      "updated_at": updatedAt.seconds,
      'variations': variations.map((v) => v.toJson()).toList(),
    };
  }

  @override
  String toString() {
    return 'ProductEntity{categoryId: $categoryId, productId: $productId, name: $name, isVeg: $isVeg, isNonVeg: $isNonVeg, isOutOfStock: $isOutOfStock, isCustomizable: $isCustomizable, hasVariation: $hasVariation, basePrice: $basePrice, description: $description, imageUrl: $imageUrl, createdAt: $createdAt, updatedAt: $updatedAt, variations: $variations}';
  }
}
