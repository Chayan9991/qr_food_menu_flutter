import 'package:self_order_qr_menu/Features/Menu/Domain/entities/category_entity.dart';
import 'package:self_order_qr_menu/Features/Menu/Domain/entities/product_customization_entity.dart';
import 'package:self_order_qr_menu/Features/Menu/Domain/entities/product_entity.dart';

class CategoryProductResult {
  final List<CategoryEntity> categoryList;
  final Map<String, List<ProductEntity>> categoryToProductMap;
  final List<ProductCustomizationEntity> productCustomizationList;

  CategoryProductResult(
      {required this.categoryToProductMap, required this.categoryList, required this.productCustomizationList});
}
