import 'package:dartz/dartz.dart';
import 'package:self_order_qr_menu/Features/Menu/Domain/entities/category_entity.dart';
import 'package:self_order_qr_menu/Features/Menu/Domain/entities/category_product_result.dart';
import '../../../../Core/Error/failures.dart';

abstract interface class MenuRepository {
  // Future<List<ProductModel>> fetchProducts();
  // Future<List<CategoryModel>> fetchCategories();
  // Future<List<CategoryEntity>?>? getCachedCategories();
  // Future<Either<Failure, List<ProductEntity>>> getCachedProducts();
  // Future<Either<Failure, List<ProductEntity>>> getProductsByCategoryId(String categoryId);
  Future<Either<Failure, CategoryProductResult>> getCategoryToProductsMap();
}
