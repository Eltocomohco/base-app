
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:pizzeria_pepe_app/features/menu/presentation/widgets/category_selector.dart';
import 'package:pizzeria_pepe_app/features/menu/presentation/providers/menu_providers.dart';
import 'package:pizzeria_pepe_app/features/menu/domain/entities/category.dart';
import 'package:pizzeria_pepe_app/features/menu/domain/repositories/menu_repository.dart';
import 'dart:typed_data';
import 'package:pizzeria_pepe_app/features/menu/domain/entities/product.dart';
import 'package:pizzeria_pepe_app/features/menu/domain/entities/extra.dart';

class MockMenuRepository implements MenuRepository {
  final List<Category> categories;
  MockMenuRepository(this.categories);

  @override
  Future<List<Category>> getCategories() async => categories;

  @override
  Future<List<Product>> getProductsByCategory(String categoryId) async => [];

  @override
  Future<Product?> getProductById(String id) async => null;

  @override
  Future<List<Extra>> getExtras() async => [];

  @override
  Future<List<Product>> searchProducts(String query) async => [];

  // Admin methods (unused in this test)
  @override
  Future<void> addCategory(Category category) async {}
  @override
  Future<void> addExtra(Extra extra) async {}
  @override
  Future<void> addProduct(Product product) async {}
  @override
  Future<void> deleteCategory(String categoryId) async {}
  @override
  Future<void> deleteExtra(String extraId) async {}
  @override
  Future<void> deleteProduct(String productId) async {}
  @override
  Future<void> updateCategory(Category category) async {}
  @override
  Future<void> updateExtra(Extra extra) async {}
  @override
  Future<void> updateProduct(Product product) async {}
  @override
  Future<String> uploadProductImage(Uint8List bytes, String fileName) async => '';
  @override
  Future<void> deleteImage(String imageUrl) async {}
}

void main() {
  final sampleCategories = [
    const Category(id: '1', name: 'Ofertas', iconAsset: 'assets/icons/pizza.png'),
    const Category(id: '2', name: 'Entrantes', iconAsset: 'assets/icons/pizza.png'),
    const Category(id: '3', name: 'Bebidas', iconAsset: 'assets/icons/pizza.png'),
    const Category(id: '4', name: 'Pizzas', iconAsset: 'assets/icons/pizza.png'),
  ];

  Widget createWidgetUnderTest() {
    return ProviderScope(
      overrides: [
        categoriesProvider.overrideWith((ref) => sampleCategories),
        selectedCategoryProvider.overrideWith(() => SelectedCategory()),
      ],
      child: ScreenUtilInit(
        designSize: const Size(375, 812),
        minTextAdapt: true,
        builder: (context, child) => const MaterialApp(
          home: Scaffold(
            body: CategorySelector(),
          ),
        ),
      ),
    );
  }

  testWidgets('CategorySelector displays categories and updates selection', (WidgetTester tester) async {
    await tester.pumpWidget(createWidgetUnderTest());
    await tester.pump();
    await tester.pump(Duration.zero);
    await tester.pumpAndSettle();

    // Debug: print what we find
    debugPrint('All text found: ${find.byType(Text).evaluate().map((e) => (e.widget as Text).data).toList()}');
    if (find.byType(CircularProgressIndicator).evaluate().isNotEmpty) {
      debugPrint('STILL LOADING');
    }

    // Check if categories are displayed. Might need to scroll to find 'Pizzas'.
    await tester.drag(find.byType(ListView), const Offset(-500, 0));
    await tester.pumpAndSettle();

    debugPrint('All text found after scroll: ${find.byType(Text).evaluate().map((e) => (e.widget as Text).data).toList()}');

    expect(find.text('Pizzas'), findsOneWidget);
    expect(find.text('Bebidas'), findsOneWidget);

    // Initial selected category should be '4' (Pizzas) based on SelectedCategory default
    // We can check if the filter chip is selected.
    // FilterChip uses the 'selected' property which reflects in its visual state.
    
    final pizzasChip = tester.widget<FilterChip>(find.byWidgetPredicate(
      (widget) => widget is FilterChip && (widget.label as Text).data == 'Pizzas'
    ));
    expect(pizzasChip.selected, isTrue);

    final bebidasChipBefore = tester.widget<FilterChip>(find.byWidgetPredicate(
      (widget) => widget is FilterChip && (widget.label as Text).data == 'Bebidas'
    ));
    expect(bebidasChipBefore.selected, isFalse);

    // Tap on 'Bebidas'
    await tester.tap(find.text('Bebidas'));
    await tester.pumpAndSettle();

    // Verify 'Bebidas' is now selected and 'Pizzas' is not
    final bebidasChipAfter = tester.widget<FilterChip>(find.byWidgetPredicate(
      (widget) => widget is FilterChip && (widget.label as Text).data == 'Bebidas'
    ));
    expect(bebidasChipAfter.selected, isTrue);

    final pizzasChipAfter = tester.widget<FilterChip>(find.byWidgetPredicate(
      (widget) => widget is FilterChip && (widget.label as Text).data == 'Pizzas'
    ));
    expect(pizzasChipAfter.selected, isFalse);
  });
}
