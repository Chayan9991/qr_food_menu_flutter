import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:self_order_qr_menu/Core/Error/exceptions.dart';
import 'package:self_order_qr_menu/Core/UseCases/usecases.dart';
import 'package:self_order_qr_menu/Features/Menu/Domain/entities/category_entity.dart';
import 'package:self_order_qr_menu/Features/Menu/Domain/entities/category_product_result.dart';
import 'package:self_order_qr_menu/Features/Menu/Domain/entities/product_entity.dart';
import 'package:self_order_qr_menu/Features/Menu/Domain/usecases/get_category_product_map.dart';

import '../../../Domain/entities/add_to_cart_entity.dart';
import '../../../Domain/entities/product_customization_entity.dart';

part 'menu_state.dart';

class MenuCubit extends Cubit<MenuState> {
  final GetCategoryToProductsMapUseCase getCategoryToProductsMapUseCase;

  MenuCubit({required this.getCategoryToProductsMapUseCase})
      : super(MenuInitial());

  Future<void> loadMenuData() async {
    emit(MenuLoading());
    final result = await getCategoryToProductsMapUseCase(NoParams());

    result.fold(
      (failure) {
        emit(MenuError(
            failure.message ?? "Failed to load category to products map"));
      },
      (success) {
        emit(MenuLoaded(success));
      },
    );
  }

  void selectVariation(VariationEntity? selectedVariation) {
    emit(MenuSelectVariation(selectedVariation));
  }

  void selectCustomization(Map<String, OptionsEntity?> data) {
    emit(MenuSelectCustomization(data));
  }

  void navigateToDetailedPageFromItemCard(AddToCartEntity addToCartEntity) {
    emit(NavigateToDetailedPageFromItemCard(addToCartEntity));
  }
}
