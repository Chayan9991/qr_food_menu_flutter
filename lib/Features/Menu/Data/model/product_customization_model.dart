import 'package:self_order_qr_menu/Features/Menu/Domain/entities/product_customization_entity.dart';

import '../../Domain/entities/product_entity.dart';

class ProductCustomizationModel extends ProductCustomizationEntity {
  ProductCustomizationModel({
    required super.categoryId,
    required super.optionData,
  });

  // Factory constructor to create the model from JSON data
  factory ProductCustomizationModel.fromJson(Map<String, dynamic> json) {
    return ProductCustomizationModel(
      categoryId: json["category_id"] as String,
      optionData: (json["options"] as List)
          .map((e) => OptionDataModel.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
  }

  // Method to convert the model to JSON
  Map<String, dynamic> toJson() {
    return {
      "category_id": categoryId,
      "options":
          optionData.map((e) => (e as OptionDataModel).toJson()).toList(),
    };
  }

  ProductCustomizationEntity toEntity() {
    return ProductCustomizationEntity(
        categoryId: categoryId, optionData: optionData);
  }

  @override
  String toString() {
    return "Category Id: $categoryId and data $optionData";
  }
}

class OptionDataModel extends OptionDataEntity {
  OptionDataModel({
    required super.type,
    required super.options,
  });

  factory OptionDataModel.fromJson(Map<String, dynamic> json) {
    return OptionDataModel(
      type: json["type"] as String,
      options: (json["options"] as List)
          .map((e) => OptionModel.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "type": type,
      "options": options.map((e) => (e as OptionModel).toJson()).toList(),
    };
  }

  @override
  String toString() {
    return "Type: $type, Options: $options";
  }
}

class OptionModel extends OptionsEntity {
  OptionModel({
    required super.name,
    required super.price,
    required super.isVeg,
  });

  factory OptionModel.fromJson(Map<String, dynamic> json) {
    return OptionModel(
      name: json["name"] as String,
      // Handle both int and double for price field
      price: (json["price"] is int)
          ? (json["price"] as int).toDouble()
          : json["price"] as double,
      isVeg: json["isVeg"] as bool,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "name": name,
      "price": price,
      "isVeg": isVeg,
    };
  }

  @override
  String toString() {
    return "Name: $name, Price: $price, IsVeg: $isVeg";
  }
}
