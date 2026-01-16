import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../../../features/menu/domain/entities/product.dart';
import '../../domain/entities/cart_item.dart';

part 'cart_provider.g.dart';

@riverpod
class Cart extends _$Cart {
  @override
  List<CartItem> build() => [];

  void addProduct(Product product) {
    // Check if optional customization should be supported later, here simple add
    // Using indexWhere to find if it exists
    final index = state.indexWhere((item) => item.product.id == product.id);
    
    if (index >= 0) {
      // Update quantity
      state = [
        ...state.sublist(0, index),
        state[index].copyWith(quantity: state[index].quantity + 1),
        ...state.sublist(index + 1),
      ];
    } else {
      // Add new
      state = [...state, CartItem(product: product, quantity: 1)];
    }
  }

  void removeProduct(String productId) {
     state = state.where((item) => item.product.id != productId).toList();
  }

  void decreaseQuantity(String productId) {
     final index = state.indexWhere((item) => item.product.id == productId);
     if (index >= 0) {
       if (state[index].quantity > 1) {
          state = [
            ...state.sublist(0, index),
            state[index].copyWith(quantity: state[index].quantity - 1),
            ...state.sublist(index + 1),
          ];
       } else {
         removeProduct(productId);
       }
     }
  }

  void clear() {
    state = [];
  }
}

@riverpod
double cartTotal(Ref ref) {
  final cart = ref.watch(cartProvider);
  return cart.fold(0, (sum, item) => sum + item.totalPrice);
}

@riverpod
int cartItemCount(Ref ref) {
  final cart = ref.watch(cartProvider);
  return cart.fold(0, (sum, item) => sum + item.quantity);
}
