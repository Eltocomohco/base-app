
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:pizzeria_pepe_app/features/cart/presentation/providers/cart_provider.dart';
import 'package:pizzeria_pepe_app/features/menu/domain/entities/product.dart';
import 'package:pizzeria_pepe_app/features/orders/domain/entities/order.dart';
import 'package:pizzeria_pepe_app/features/orders/data/repositories/firestore_orders_repository.dart';
import 'package:pizzeria_pepe_app/features/checkout/presentation/screens/checkout_screen.dart';
import 'package:pizzeria_pepe_app/features/auth/presentation/providers/auth_provider.dart';
import 'package:pizzeria_pepe_app/features/auth/domain/entities/user_entity.dart';
import 'package:pizzeria_pepe_app/features/orders/presentation/providers/orders_provider.dart';
import 'dart:async';

class MockOrdersRepository implements OrdersRepository {
  final List<OrderEntity> orders = [];
  final _controller = StreamController<List<OrderEntity>>.broadcast();

  @override
  Future<void> createOrder(OrderEntity order) async {
    orders.add(order);
    _controller.add(List.from(orders));
  }

  @override
  Stream<List<OrderEntity>> getAllOrders() => _controller.stream;

  @override
  Stream<List<OrderEntity>> getUserOrders(String userId) => _controller.stream;

  @override
  Future<void> updateOrderStatus(String orderId, String newStatus) async {}

  void dispose() {
    _controller.close();
  }
}

void main() {
  final testProduct = Product(
    id: '1',
    name: 'Pizza Test',
    description: 'Desc',
    price: 10.0,
    imageUrl: '',
    categoryId: '4',
  );

  final testUser = const UserEntity(id: 'user123', email: 'test@test.com', name: 'Pepe');

  testWidgets('Full Order Integration Flow', (WidgetTester tester) async {
    final mockOrdersRepo = MockOrdersRepository();
    
    final container = ProviderContainer(
      overrides: [
        ordersRepositoryProvider.overrideWithValue(mockOrdersRepo),
        authProvider.overrideWithValue(testUser),
      ],
    );

    // 1. Setup Cart
    container.read(cartProvider.notifier).addProduct(testProduct);
    expect(container.read(cartProvider).length, 1);

    // 2. Build Checkout Screen
    await tester.pumpWidget(
      UncontrolledProviderScope(
        container: container,
        child: ScreenUtilInit(
          designSize: const Size(375, 812),
          builder: (context, child) => MaterialApp(
            // Use a simple mock observer or just a plain Navigator if needed
            // But CheckoutScreen uses context.go, so we need a GoRouter
            home: const CheckoutScreen(),
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();

    // 3. Fill checkout info
    // The screen has default values. We need to clear them.
    final addressField = find.byType(TextFormField).first;
    final phoneField = find.byType(TextFormField).last;

    await tester.tap(addressField);
    await tester.enterText(addressField, ''); // Clear
    await tester.enterText(addressField, 'Calle Falsa 123');
    
    await tester.tap(phoneField);
    await tester.enterText(phoneField, ''); // Clear
    await tester.enterText(phoneField, '600000000');
    
    await tester.pumpAndSettle();

    // 4. Confirm Order
    final confirmButton = find.text('CONFIRMAR PEDIDO');
    expect(confirmButton, findsOneWidget);
    
    await tester.ensureVisible(confirmButton);
    await tester.pumpAndSettle();
    
    // Silence GoRouter error for now as we only care about repo call
    await tester.tap(confirmButton, warnIfMissed: false);
    await tester.pump(); // This will trigger the async call
    await tester.pump(const Duration(seconds: 1)); // Wait for repo call
    await tester.pumpAndSettle();

    // 5. Verify Repository was called
    expect(mockOrdersRepo.orders.length, 1);
    expect(mockOrdersRepo.orders.first.total, 10.0);
    expect(mockOrdersRepo.orders.first.deliveryAddress, 'Calle Falsa 123');

    // 6. Verify Cart is cleared after order
    expect(container.read(cartProvider), isEmpty);
    
    mockOrdersRepo.dispose();
  });
}
