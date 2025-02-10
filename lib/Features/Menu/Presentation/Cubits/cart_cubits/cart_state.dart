
import '../../../Domain/entities/add_to_cart_entity.dart';

abstract class CartState {}

class CartInitial extends CartState {}

class CartLoaded extends CartState {
  final List<AddToCartEntity> items;

  CartLoaded(this.items);
}

class ItemAdded extends CartState {
  final List<AddToCartEntity> items;

  ItemAdded(this.items);

  @override
  String toString() {
    // TODO: implement toString
    return items.toString();
  }
}

class ItemRemoved extends CartState {
  final List<AddToCartEntity> items;

  ItemRemoved(this.items);
}

class ItemModified extends CartState {
  final List<AddToCartEntity> items;

  ItemModified(this.items);
}
