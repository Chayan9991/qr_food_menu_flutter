import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:self_order_qr_menu/Core/Error/exceptions.dart';
import 'package:self_order_qr_menu/Features/Menu/Data/model/category_model.dart';
import 'package:self_order_qr_menu/Features/Menu/Data/model/product_model.dart';

import '../model/product_customization_model.dart';

abstract interface class MenuFirebaseDatasource {
  Future<List<ProductModel>> getAllProducts();

  Future<List<CategoryModel>> getAllCategories();

  Future<List<ProductModel>> getProductsByCategoryId(String categoryId);

  Future<List<ProductCustomizationModel>> getProductCustomization();
}

class MenuFirebaseDatasourceImpl implements MenuFirebaseDatasource {
  final FirebaseFirestore firestore;

  MenuFirebaseDatasourceImpl(this.firestore);

  @override
  Future<List<ProductModel>> getAllProducts() async {
    try {
      final snapshot = await firestore.collection("products").get();
      return snapshot.docs.map((doc) {
        final data = doc.data();
        return ProductModel.fromJson(data);
      }).toList();
    } catch (e) {
      throw ServerException("Failed to fetch products: ${e.toString()}");
    }
  }

  @override
  Future<List<CategoryModel>> getAllCategories() async {
    try {
      final snapshot = await firestore.collection("categories").get();
      return snapshot.docs.map((doc) {
        final data = doc.data();
        return CategoryModel.fromJson(data);
      }).toList();
    } catch (e) {
      throw ServerException("Failed to fetch products: ${e.toString()}");
    }
  }

  @override
  Future<List<ProductCustomizationModel>> getProductCustomization() async {
    try {
      final snapshot = await firestore.collection("customization").get();
      return snapshot.docs.map((doc) {
        final data = doc.data();
        return ProductCustomizationModel.fromJson(data);
      }).toList();
    } catch (e) {
      throw ServerException(
          "Failed to fetch Product Customization: ${e.toString()}");
    }
  }

  @override
  Future<List<ProductModel>> getProductsByCategoryId(String categoryId) async {
    try {
      final snapshot = await firestore
          .collection("products")
          .where("categoryId", isEqualTo: categoryId)
          .get();
      return snapshot.docs.map((doc) {
        final data = doc.data();
        return ProductModel.fromJson(data);
      }).toList();
    } catch (e) {
      throw ServerException("Failed to fetch products: ${e.toString()}");
    }
  }
}
