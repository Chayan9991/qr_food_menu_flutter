part of 'menu_cubit.dart';

@immutable
sealed class MenuState {}

final class MenuInitial extends MenuState {}

final class MenuLoading extends MenuState {}

final class MenuLoaded extends MenuState {
  final CategoryProductResult menuResult;

  MenuLoaded(this.menuResult);

  List<CategoryEntity> get categoryList => menuResult.categoryList;

  Map<String, List<ProductEntity>> get categoryToProductMap =>
      menuResult.categoryToProductMap;
}

final class MenuError extends MenuState {
  final String error;

  MenuError(this.error);

  String get getMessage => error;
}

final class MenuSelectVariation extends MenuState {
  final VariationEntity? selectedVariation;

  MenuSelectVariation(this.selectedVariation);

  VariationEntity? get getSelectedVariation => selectedVariation;
}

final class MenuSelectCustomization extends MenuState {
  final Map<String, OptionsEntity?> data;

  MenuSelectCustomization(this.data);
}

final class NavigateToDetailedPageFromItemCard extends MenuState {
  final AddToCartEntity addToCartEntity;

  NavigateToDetailedPageFromItemCard(this.addToCartEntity);
}
