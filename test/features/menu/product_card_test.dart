
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:pizzeria_pepe_app/features/menu/presentation/widgets/product_card.dart';
import 'package:pizzeria_pepe_app/features/menu/domain/entities/product.dart';
import 'package:pizzeria_pepe_app/features/cart/presentation/providers/cart_provider.dart';

void main() {
  const testProduct = Product(
    id: '1',
    name: 'Pizza Carbonara',
    description: 'Nuestra deliciosa carbonara',
    price: 12.50,
    imageUrl: 'assets/images/logo_icon.png',
    categoryId: '4',
    isSpicy: true,
    isVegetarian: false,
  );

  Widget createWidgetUnderTest() {
    return ProviderScope(
      child: ScreenUtilInit(
        designSize: const Size(375, 812),
        minTextAdapt: true,
        builder: (context, child) => const MaterialApp(
          home: Scaffold(
            body: ProductCard(product: testProduct),
          ),
        ),
      ),
    );
  }

  testWidgets('ProductCard displays correctness information', (WidgetTester tester) async {
    await tester.pumpWidget(createWidgetUnderTest());
    await tester.pumpAndSettle(); // Complete fadeIn and slide animations

    // Verify name and price
    expect(find.text('Pizza Carbonara'), findsOneWidget);
    expect(find.text('12.50 €'), findsOneWidget);
    expect(find.text('Nuestra deliciosa carbonara'), findsOneWidget);

    // Verify spicy icon (fire) is present
    expect(find.byIcon(Icons.local_fire_department), findsOneWidget);
    
    // Verify vegetarian icon (eco) is NOT present for this product
    expect(find.byIcon(Icons.eco), findsNothing);
  });

  testWidgets('Tapping AÑADIR updates the cart', (WidgetTester tester) async {
    final container = ProviderContainer();
    
    await tester.pumpWidget(
      UncontrolledProviderScope(
        container: container,
        child: ScreenUtilInit(
          designSize: const Size(375, 812),
          builder: (context, child) => const MaterialApp(
            home: Scaffold(
              body: ProductCard(product: testProduct),
            ),
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();

    // Initial cart should be empty
    expect(container.read(cartProvider), isEmpty);

    // Tap AÑADIR
    await tester.tap(find.text('AÑADIR'));
    await tester.pump(); // Process the tap
    await tester.pumpAndSettle(); // Wait for snackbar animation

    // Check cart state
    final cart = container.read(cartProvider);
    expect(cart.length, 1);
    expect(cart.first.product.id, '1');
    expect(cart.first.quantity, 1);

    // Verify snackbar appears
    expect(find.byType(SnackBar), findsOneWidget);
    expect(find.text('Pizza Carbonara añadido al pedido'), findsOneWidget);
    
    // Clean up snackbar to avoid pending timers
    ScaffoldMessenger.of(tester.element(find.byType(ProductCard))).removeCurrentSnackBar();
    await tester.pumpAndSettle();
  });
}
