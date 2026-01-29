
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pizzeria_pepe_app/features/cart/presentation/providers/cart_provider.dart';
import 'package:pizzeria_pepe_app/features/cart/domain/entities/cart_item.dart';
import 'package:pizzeria_pepe_app/features/menu/domain/entities/product.dart';

void main() {
  group('CartNotifier tests', () {
    late ProviderContainer container;

    // Helper to create a product
    Product createProduct({required String id, String name = 'Test Product', double price = 10.0}) {
      return Product(
        id: id,
        name: name,
        description: 'Description',
        price: price,
        imageUrl: '',
        categoryId: 'cat1',
      );
    }

    setUp(() {
      container = ProviderContainer();
    });

    tearDown(() {
      container.dispose();
    });

    test('Initial state is empty', () {
      final cart = container.read(cartProvider);
      expect(cart, isEmpty);
      expect(container.read(cartTotalProvider), 0.0);
    });

    test('addItem adds a new product correctly', () {
      final product = createProduct(id: '1', price: 12.0);
      final item = CartItem(product: product, quantity: 1);
      
      container.read(cartProvider.notifier).addItem(item);
      
      final state = container.read(cartProvider);
      expect(state.length, 1);
      expect(state.first.product.id, '1');
      expect(state.first.quantity, 1);
      expect(container.read(cartTotalProvider), 12.0);
    });

    test('addItem increments quantity if same product AND same extras AND same notes', () {
      final product = createProduct(id: '1', price: 10.0);
      final item = CartItem(product: product, quantity: 1, selectedExtras: ['cheese'], notes: 'Extra hot');
      
      final notifier = container.read(cartProvider.notifier);
      notifier.addItem(item);
      notifier.addItem(item); // Add the same thing again
      
      final state = container.read(cartProvider);
      expect(state.length, 1);
      expect(state.first.quantity, 2);
      // Total: (10 + 1 extra) * 2 = 22.0
      expect(container.read(cartTotalProvider), 22.0);
    });

    test('addItem creates new entry if extras are different', () {
      final product = createProduct(id: '1', price: 10.0);
      
      final notifier = container.read(cartProvider.notifier);
      notifier.addItem(CartItem(product: product, quantity: 1, selectedExtras: ['cheese']));
      notifier.addItem(CartItem(product: product, quantity: 1, selectedExtras: ['onions']));
      
      final state = container.read(cartProvider);
      expect(state.length, 2);
      expect(container.read(cartTotalProvider), 22.0); // (10+1) + (10+1)
    });

    test('removeItem decrements quantity correctly', () {
      final product = createProduct(id: '1', price: 10.0);
      final item = CartItem(product: product, quantity: 2);
      
      final notifier = container.read(cartProvider.notifier);
      notifier.addItem(item);
      
      notifier.removeItem(item);
      
      final state = container.read(cartProvider);
      expect(state.first.quantity, 1);
      expect(container.read(cartTotalProvider), 10.0);
    });

    test('removeItem removes item entirely if quantity is 1', () {
      final product = createProduct(id: '1', price: 10.0);
      final item = CartItem(product: product, quantity: 1);
      
      final notifier = container.read(cartProvider.notifier);
      notifier.addItem(item);
      notifier.removeItem(item);
      
      expect(container.read(cartProvider), isEmpty);
    });

    test('clear removes all items', () {
      final p1 = createProduct(id: '1');
      final p2 = createProduct(id: '2');
      
      final notifier = container.read(cartProvider.notifier);
      notifier.addProduct(p1);
      notifier.addProduct(p2);
      
      notifier.clear();
      
      expect(container.read(cartProvider), isEmpty);
      expect(container.read(cartTotalProvider), 0.0);
    });

    test('Complex calculation: multiple items with multiple extras', () {
      final p1 = createProduct(id: '1', price: 8.0); // + 2 extras = 10.0
      final p2 = createProduct(id: '2', price: 15.0); // + 0 extras = 15.0
      
      final notifier = container.read(cartProvider.notifier);
      notifier.addItem(CartItem(product: p1, quantity: 2, selectedExtras: ['extra1', 'extra2']));
      notifier.addItem(CartItem(product: p2, quantity: 1));
      
      // Total: (10.0 * 2) + 15.0 = 35.0
      expect(container.read(cartTotalProvider), 35.0);
      expect(container.read(cartItemCountProvider), 3);
    });
  });
}
