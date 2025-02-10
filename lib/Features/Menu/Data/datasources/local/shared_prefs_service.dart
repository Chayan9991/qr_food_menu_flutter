import 'dart:convert';
import 'package:self_order_qr_menu/Features/Menu/Data/model/product_customization_model.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../model/category_model.dart';
import '../../model/product_model.dart';

class SharedPrefsService {
  final SharedPreferences _prefs;
  SharedPrefsService(this._prefs);

  // Cache categories as a list of maps
  Future<void> cacheCategories(List<CategoryModel> categories) async {
    final List<Map<String, dynamic>> categoryMaps = categories
        .map((category) => category.toJson())
        .toList();
    final encodedData =
        jsonEncode(categoryMaps); // Convert categories to JSON string
    await _prefs.setString(
        'categories', encodedData); // Store in SharedPreferences
  }

  // Retrieve cached categories, returning a list of CategoryEntity or empty list
  Future<List<CategoryModel>> getCachedCategories() async {
    final String? encodedData = await _prefs
        .getString('categories');
    if (encodedData != null) {
      final List<dynamic> decodedData =
          jsonDecode(encodedData); // Decode the JSON
      return decodedData
          .map((json) => CategoryModel.fromJson(json))
          .toList(); // Convert back to CategoryModel list
    }
    return []; // Return an empty list if no cache found
  }

  // Cache Products as a list of maps
  Future<void> cacheProducts(List<ProductModel> products) async {
    final List<Map<String, dynamic>> productMaps =
        products.map((product) => (product).toJson()).toList();
    final encodedData =
        jsonEncode(productMaps); // Convert products to JSON string
    await _prefs.setString(
        'products', encodedData); // Store in SharedPreferences
  }

  // Retrieve cached Products, returning a list of ProductEntity or empty list
  Future<List<ProductModel>> getCachedProducts() async {
    final String? encodedData = await _prefs
        .getString('products');
    if (encodedData != null) {
      final List<dynamic> decodedData =
          jsonDecode(encodedData); // Decode the JSON
      return decodedData
          .map((json) => ProductModel.fromJson(json))
          .toList(); // Convert back to ProductModel list
    }
    return []; // Return an empty list if no cache found
  }

  // cache Product Customization as a list of maps
  Future<void> cacheCustomization(List<ProductCustomizationModel>customization) async{
    final List<Map<String, dynamic>> customizationMap = customization.map((data)=>data.toJson()).toList();
    final encodeData = jsonEncode(customizationMap);
    await _prefs.setString("productCustomization", encodeData);
  }
  // Retrieve cached Customization list
  Future<List<ProductCustomizationModel>> getCachedCustomization() async{
    final String? encodedData = await _prefs.getString("productCustomization");
    if(encodedData != null){
      final List<dynamic> decodedData = jsonDecode(encodedData);
      return decodedData.map((json)=>ProductCustomizationModel.fromJson(json)).toList();
    }
    return [] ;
  }

  // Clear the cached categories and products
  Future<void> clearCache() async {
    await _prefs.remove("products"); // Remove the Products cache
    await _prefs.remove('categories'); // Remove the Categories cache
    await _prefs.remove('productCustomization');
    print("Cache is Cleared");
  }
}
