import '../../domain/entities/category.dart';
import '../../domain/entities/product.dart';
import '../../domain/repositories/menu_repository.dart';
import 'menu_data.dart';

class MockMenuRepository implements MenuRepository {
  @override
  Future<List<Category>> getCategories() async {
    return [
      const Category(id: '1', name: 'Entrantes', iconAsset: 'assets/icons/starter.png', isSelected: false),
      const Category(id: '2', name: 'Ensaladas', iconAsset: 'assets/icons/salad.png', isSelected: false),
      const Category(id: '3', name: 'Pasta', iconAsset: 'assets/icons/pasta.png', isSelected: false),
      const Category(id: '4', name: 'Pizzas', iconAsset: 'assets/icons/pizza.png', isSelected: true), // Pizzas default
      const Category(id: '5', name: 'Hamburguesas', iconAsset: 'assets/icons/burger.png', isSelected: false),
      const Category(id: '6', name: 'Postres', iconAsset: 'assets/icons/dessert.png', isSelected: false),
    ];
  }

  @override
  Future<List<Product>> getProductsByCategory(String categoryId) async {
    await Future<void>.delayed(const Duration(milliseconds: 300)); // Simulate latency
    return kFullMenuProducts.where((p) => p.categoryId == categoryId).toList();
  }

  @override
  Future<List<Product>> searchProducts(String query) async {
    await Future<void>.delayed(const Duration(milliseconds: 300));
    return kFullMenuProducts.where((p) => p.name.toLowerCase().contains(query.toLowerCase())).toList();
  }
}
