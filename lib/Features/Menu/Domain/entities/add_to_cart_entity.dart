import 'package:self_order_qr_menu/Features/Menu/Domain/entities/category_entity.dart';
import 'package:self_order_qr_menu/Features/Menu/Domain/entities/product_customization_entity.dart';
import 'package:self_order_qr_menu/Features/Menu/Domain/entities/product_entity.dart';

class AddToCartEntity {
  final String productId;
  final String categoryId;
  final String productName;
  final String? productCategoryName;

  final String? productImage;
  final VariationEntity? selectedVariation;
  final Map<String, OptionsEntity?>? selectedCustomization;
  final double productPrice;
  final int quantity;
  final String? addInstructions;

  AddToCartEntity({
    required this.productId,
    required this.productName,
    required this.categoryId,
    this.productCategoryName,
    this.productImage,
    this.selectedVariation,
    this.selectedCustomization,
    required this.productPrice,
    this.quantity = 1,
    this.addInstructions,
  });

  // Add copyWith method
  AddToCartEntity copyWith({
    String? productId,
    String? categoryId,
    String? productName,
    String? productImage,
    String? productCategoryName,
    VariationEntity? selectedVariation,
    Map<String, OptionsEntity?>? selectedCustomization,
    double? productPrice,
    int? quantity,
    String? addInstructions,
  }) {
    return AddToCartEntity(
      productId: productId ?? this.productId,
      categoryId: categoryId ?? this.categoryId,
      productName: productName ?? this.productName,
      productImage: productImage ?? this.productImage,
      selectedVariation: selectedVariation ?? this.selectedVariation,
      selectedCustomization:
          selectedCustomization ?? this.selectedCustomization,
      productPrice: productPrice ?? this.productPrice,
      quantity: quantity ?? this.quantity,
      addInstructions: addInstructions ?? this.addInstructions,
      productCategoryName: productCategoryName ?? this.productCategoryName,
    );
  }

  @override
  String toString() {
    return 'AddToCartEntity{productId: $productId, productName: $productName, productImage: $productImage, selectedCustomization: $selectedCustomization, productTotalPrice: $productPrice, quantity: $quantity, addInstructions: $addInstructions}';
  }
}
