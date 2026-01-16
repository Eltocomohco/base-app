import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../entities/cart_item.dart';
import '../../../menu/domain/entities/product.dart';

final cartProvider = StateNotifierProvider<CartNotifier, List<CartItem>>((ref) {
  return CartNotifier();
});

class CartNotifier extends StateNotifier<List<CartItem>> {
  CartNotifier() : super([]);

  void addItem(CartItem item) {
    final existingIndex = state.indexWhere((i) => i.product.id == item.product.id);
    
    if (existingIndex != -1) {
      state = [
        for (int i = 0; i < state.length; i++)
          if (i == existingIndex)
            state[i].copyWith(quantity: state[i].quantity + 1)
          else
            state[i],
      ];
    } else {
      state = [...state, item];
    }
  }

  void addProduct(Product product) {
    addItem(CartItem(product: product, quantity: 1));
  }

  void removeItem(String productId) {
    final existingIndex = state.indexWhere((i) => i.product.id == productId);
    
    if (existingIndex != -1) {
      if (state[existingIndex].quantity > 1) {
        state = [
          for (int i = 0; i < state.length; i++)
            if (i == existingIndex)
              state[i].copyWith(quantity: state[i].quantity - 1)
            else
              state[i],
        ];
      } else {
        state = [
          for (int i = 0; i < state.length; i++)
            if (i != existingIndex) state[i],
        ];
      }
    }
  }

  void decreaseQuantity(String productId) {
    removeItem(productId);
  }

  void clear() {
    state = [];
  }

  double get subtotal {
    return state.fold(0.0, (sum, item) => sum + (item.product.price * item.quantity));
  }

  int get totalItems {
    return state.fold(0, (sum, item) => sum + item.quantity);
  }
}
