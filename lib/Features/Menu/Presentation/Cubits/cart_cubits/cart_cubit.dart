import 'package:bloc/bloc.dart';
import '../../../Domain/entities/add_to_cart_entity.dart';
import 'cart_state.dart';

class CartCubit extends Cubit<CartState> {
  final List<AddToCartEntity> _items = [];

  CartCubit() : super(CartInitial());

  // Add item to the Cart
  void addItemToCart(AddToCartEntity item) {
    _items.add(item);
    print("Item added to the cart");
    emit(ItemAdded(List.from(_items)));
  }

  // Remove items from the Cart
  void removeItemFromCart(AddToCartEntity item) {
    _items.remove(item);
    print("Item removed from the Cart");
    emit(ItemRemoved(List.from(_items)));
  }

  // Modify an existing item in the Cart
  void modifyCartItem(AddToCartEntity oldItem, AddToCartEntity newItem) {
    final index = _items.indexWhere((i) => i.productId == oldItem.productId);

    if (index != -1) {
      _items[index] = newItem;
      print("Item modified in the cart");
      emit(ItemModified(List.from(_items)));
    } else {
      print("Item not found in cart to modify");
    }
  }

  // Get current cart items
  List<AddToCartEntity>? getItems() => List.from(_items);

  // Find a single item by productId
  AddToCartEntity? getSingleItemById(String productId) {
    try {
      return _items.firstWhere((item) => item.productId == productId);
    } catch (_) {
      return null;
    }
  }
}
