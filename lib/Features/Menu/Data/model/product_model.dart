import 'package:cloud_firestore/cloud_firestore.dart';

import '../../Domain/entities/product_entity.dart';

class VariationModel extends VariationEntity {
  VariationModel({
    required super.name,
    required super.price,
    required super.isVeg,
  });

  // Factory method to create variations from JSON data
  factory VariationModel.fromJson(Map<String, dynamic> json) {
    return VariationModel(
      isVeg: json["isVeg"] as bool,
      name: json["name"] as String,
      price: (json["price"] as num).toDouble(), // Ensures price is a double
    );
  }

  // Variation data converts into JSON
  Map<String, dynamic> toJson() {
    return {
      "isVeg": isVeg,
      "price": price,
      "name": name,
    };
  }
}

class ProductModel extends ProductEntity {
  ProductModel({
    required super.productId,
    required super.categoryId,
    required super.name,
    required super.description,
    required super.basePrice,
    required super.isCustomizable,
    required super.hasVariation,
    required super.isVeg,
    required super.isNonVeg,
    required super.isOutOfStock,
    required super.imageUrl,
    required super.createdAt,
    required super.updatedAt,
    required super.variations,
  });

  factory ProductModel.fromJson(Map<String, dynamic> json) {
    var variationList = json["variations"] as List<dynamic>? ?? [];
    List<VariationEntity> variations = variationList
        .map((variation) => VariationModel.fromJson(variation as Map<String, dynamic>))
        .toList();

    return ProductModel(
      productId: json["product_id"] as String? ?? "",
      categoryId: json["category_id"] as String? ?? "",
      name: json["name"] as String? ?? "Unnamed Product",
      description: json["description"] as String? ?? "",
      basePrice: (json["base_price"] as num?)?.toDouble() ?? 0.0,
      isCustomizable: json["isCustomizable"] as bool? ?? false,
      hasVariation: json["hasVariation"] as bool? ?? false,
      isVeg: json["isVeg"] as bool? ?? false,
      isNonVeg: json["isNonVeg"] as bool? ?? false,
      isOutOfStock: json["isOutOfStock"] as bool? ?? false,
      imageUrl: List<String>.from(json["image_url"] ?? []),
      createdAt: _getTimestamp(json["created_at"]),
      updatedAt: _getTimestamp(json["updated_at"]),
      variations: variations,
    );
  }

  static Timestamp _getTimestamp(dynamic timestamp){
    if(timestamp is int){
      return Timestamp(timestamp,0);
    }else if(timestamp is Timestamp){
      return timestamp;
    }
    return Timestamp.now();
  }

  Map<String, dynamic> toJson() {
    return {
      "product_id": productId,
      "category_id": categoryId,
      "name": name,
      "description": description,
      "base_price": basePrice,
      "isCustomizable": isCustomizable,
      "hasVariation": hasVariation,
      "isVeg": isVeg,
      "isNonVeg": isNonVeg,
      "isOutOfStock": isOutOfStock,
      "image_url": imageUrl,
      "created_at": createdAt.seconds,  // Firestore's Timestamp in seconds
      "updated_at": updatedAt.seconds,
      "variations": variations.map((v) => v.toJson()).toList(),
    };
  }

  ProductEntity toEntity() {
    return ProductEntity(
      productId: productId,
      categoryId: categoryId,
      name: name,
      description: description,
      basePrice: basePrice,
      isCustomizable: isCustomizable,
      hasVariation: hasVariation,
      isVeg: isVeg,
      isNonVeg: isNonVeg,
      isOutOfStock: isOutOfStock,
      imageUrl: imageUrl,
      createdAt: createdAt,
      updatedAt: updatedAt,
      variations: variations,
    );
  }
}
