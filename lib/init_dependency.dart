import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get_it/get_it.dart';
import 'package:self_order_qr_menu/Features/Menu/Domain/usecases/get_category_product_map.dart';
import 'package:self_order_qr_menu/Features/Menu/Presentation/Cubits/cart_cubits/cart_cubit.dart';
import 'package:self_order_qr_menu/Features/Menu/Presentation/Cubits/menu_cubit/menu_cubit.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:self_order_qr_menu/Features/Menu/Data/datasources/menu_firebase_datasource.dart';
import 'package:self_order_qr_menu/Features/Menu/Data/repositories/menu_repositoryImpl.dart';
import 'package:self_order_qr_menu/Features/Menu/Domain/repositories/menu_repository.dart';
import 'Features/Menu/Data/datasources/local/shared_prefs_service.dart';

final serviceLocator = GetIt.instance;

Future<void> initDependencies() async {
  // Initialize Firebase
  serviceLocator.registerLazySingleton(() => FirebaseFirestore.instance);

  // Initialize SharedPreferences (asynchronous)
  final sharedPreferences = await SharedPreferences.getInstance();
  serviceLocator.registerSingleton<SharedPreferences>(sharedPreferences);

  // Initialize SharedPrefsService
  serviceLocator
      .registerLazySingleton(() => SharedPrefsService(sharedPreferences));

  _initMenuFeature();
}

void _initMenuFeature() {
  // **Data Source**
  serviceLocator.registerFactory<MenuFirebaseDatasource>(
      () => MenuFirebaseDatasourceImpl(serviceLocator()));

  // **Repository**
  serviceLocator.registerLazySingleton<MenuRepository>(() => MenuRepositoryImpl(
      menuFirebaseDatasource: serviceLocator(),
      sharedPrefsService: serviceLocator()));

  // **Use Cases**
  // serviceLocator.registerFactory<GetAllProductsUseCase>(
  //     () => GetAllProductsUseCase(serviceLocator()));
  // serviceLocator.registerFactory<GetProductByCategoryIdUseCase>(
  //     () => GetProductByCategoryIdUseCase());

  serviceLocator.registerLazySingleton(
      () => GetCategoryToProductsMapUseCase(serviceLocator()));

  // **Cubit**
  // serviceLocator.registerFactory<ProductCubit>(() => ProductCubit(
  //     getProductsByCategoryIdUseCase: serviceLocator(),
  //     getAllProductsUseCase: serviceLocator(),
  //     sharedPrefsService: serviceLocator()));

  serviceLocator.registerFactory<MenuCubit>(
      () => MenuCubit(getCategoryToProductsMapUseCase: serviceLocator()));

  serviceLocator.registerFactory<CartCubit>(() => CartCubit());
}
