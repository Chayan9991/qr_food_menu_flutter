import 'package:dartz/dartz.dart';
import 'package:self_order_qr_menu/Core/Error/exceptions.dart';
import 'package:self_order_qr_menu/Core/Error/failures.dart';
import 'package:self_order_qr_menu/Features/Menu/Data/datasources/local/shared_prefs_service.dart';
import 'package:self_order_qr_menu/Features/Menu/Data/datasources/menu_firebase_datasource.dart';
import 'package:self_order_qr_menu/Features/Menu/Data/model/product_customization_model.dart';
import 'package:self_order_qr_menu/Features/Menu/Domain/entities/category_entity.dart';
import 'package:self_order_qr_menu/Features/Menu/Domain/entities/category_product_result.dart';
import 'package:self_order_qr_menu/Features/Menu/Domain/entities/product_customization_entity.dart';
import 'package:self_order_qr_menu/Features/Menu/Domain/entities/product_entity.dart';
import 'package:self_order_qr_menu/Features/Menu/Domain/repositories/menu_repository.dart';

import '../model/category_model.dart';
import '../model/product_model.dart';

class MenuRepositoryImpl implements MenuRepository {
  MenuFirebaseDatasource menuFirebaseDatasource;
  SharedPrefsService sharedPrefsService;

  MenuRepositoryImpl(
      {required this.menuFirebaseDatasource, required this.sharedPrefsService});

  // @override
  // Future<Either<Failure, List<ProductEntity>>> getAllProducts() async{
  //   try{
  //     final products = await menuFirebaseDatasource.getAllProducts();
  //     return right(products.map((productModel) => productModel.toEntity()).toList());
  //   }on ServerException catch(e){
  //     return left(Failure(e.message));
  //   }
  // }
  //
  // @override
  // Future<Either<Failure, List<CategoryEntity>>> getAllCategories() async{
  //   try{
  //     final categories = await menuFirebaseDatasource.getAllCategories();
  //     return right(categories.map((categoryModel) => categoryModel.toEntity()).toList());
  //   }on ServerException catch(e){
  //     return left(Failure(e.message));
  //   }
  // }
  //
  // @override
  // Future<List<CategoryEntity>?>? getCachedCategories() {
  //   try{
  //     final cachedCategories = sharedPrefsService.getCachedCategories();
  //     if(cachedCategories != null){
  //      return cachedCategories;
  //     }else{
  //       return null;
  //     }
  //   }catch(e){
  //     print(e.toString());
  //   }
  // }
  //
  // @override
  // Future<Either<Failure,List<ProductEntity>>> getCachedProducts() async{
  //   try{
  //     final cachedProducts = sharedPrefsService.getCachedProducts();
  //     if(cachedProducts != null){
  //       return right(cachedProducts as List<ProductEntity>);
  //     }else return left(Failure("No cached product found!")) ;
  //       }on ServerException catch(e){
  //     return left(Failure(e.message));
  //   }
  // }
  //
  // @override
  // Future<Either<Failure, List<ProductEntity>>> getProductsByCategoryId(String categoryId) async {
  //   try {
  //     final products = await menuFirebaseDatasource.getProductsByCategoryId(categoryId);
  //
  //     final productEntity = products.map((e) {
  //       return ProductModel.fromJson(e as Map<String, dynamic>).toEntity();
  //     }).toList();
  //
  //     return right(productEntity);
  //   } on ServerException catch (e) {
  //     return left(Failure(e.message));
  //   }
  // }

  @override
  Future<Either<Failure, CategoryProductResult>>
      getCategoryToProductsMap() async {
    //fetch category and products
    try {
      final categories = await _fetchCategories();
      final products = await _fetchProducts();
      final productCustomization = await _fetchProductCustomization();

      final Map<String, List<ProductEntity>> categoryToProductsMap = {};
      final List<CategoryEntity> categoryList =
          categories.map((category) => category.toEntity()).toList();
      final List<ProductCustomizationEntity> productCustomizationList =
          productCustomization.map((element) => element.toEntity()).toList();

      // Initialize the map with empty lists for each categoryId
      for (var category in categories) {
        categoryToProductsMap[category.categoryId] = [];
      }

      // Populate the map with products
      for (var product in products) {
        final categoryId = product.categoryId;

        if (categoryToProductsMap.containsKey(categoryId)) {
          categoryToProductsMap[categoryId]?.add(product.toEntity());
        } else {
          print(
              "No matching category found for product: ${product.productId}, categoryId: $categoryId");
        }
      }

      //Returning Category List and CategoryProductMap as an Object

      return right(CategoryProductResult(
          categoryToProductMap: categoryToProductsMap,
          categoryList: categoryList,
          productCustomizationList: productCustomizationList));
    } on ServerException catch (e) {
      return left(Failure(e.message));
    }
  }

  Future<List<CategoryModel>> _fetchCategories() async {
    try {
      // Try to fetch categories from cache
      final cachedCategories = await sharedPrefsService.getCachedCategories();
      if (cachedCategories.isNotEmpty) {
        print("Categories are cached...");
        return cachedCategories;
      }

      // Fetch categories from Firebase if not cached
      final categories = await menuFirebaseDatasource.getAllCategories();
      print("category firebase call");
      if (categories == null || categories.isEmpty) {
        throw const ServerException("No categories found in Firebase.");
      }

      // Cache the data after fetching it from Firebase
      await sharedPrefsService.cacheCategories(categories);
      // Convert to entities
      return categories;
    } catch (e) {
      print("Error fetching categories: $e");
      throw ServerException(e.toString());
    }
  }

  Future<List<ProductModel>> _fetchProducts() async {
    try {
      // Try to fetch products from cache
      final cachedProducts = await sharedPrefsService.getCachedProducts();
      if (cachedProducts.isNotEmpty) {
        print("Products are cached...");
        return cachedProducts;
      }

      // Fetch products from Firebase if not cached
      final products = await menuFirebaseDatasource.getAllProducts();
      print("product firebase call");
      if (products == null || products.isEmpty) {
        throw const ServerException("No products found in Firebase.");
      }
      //cache the products
      await sharedPrefsService.cacheProducts(products);
      // Convert to entities
      return products;
    } catch (e) {
      throw ServerException(e.toString());
    }
  }

  Future<List<ProductCustomizationModel>> _fetchProductCustomization() async {
    try {
      // Try to fetch product customization from cache storage
      final cachedCustomization =
          await sharedPrefsService.getCachedCustomization();
      if (cachedCustomization.isNotEmpty) {
        print("Product Customization List is Cached...");
        return cachedCustomization;
      }

      // Fetch customization list from Firebase if not cached
      final productCustomization =
          await menuFirebaseDatasource.getProductCustomization();
      print("Product Customization Firebase call...");

      if (productCustomization.isEmpty) {
        throw const ServerException("No Customization found in Firebase");
      }

      // Cache the product customization
      await sharedPrefsService.cacheCustomization(productCustomization);

      // Return the fetched data
      return productCustomization;
    } catch (e) {
      print("Error in fetching Product Customization: $e");
      throw ServerException(e.toString());
    }
  }
}
