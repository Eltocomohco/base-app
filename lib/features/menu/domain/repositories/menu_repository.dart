import '../../domain/entities/category.dart';
import '../../domain/entities/product.dart';

abstract class MenuRepository {
  Future<List<Category>> getCategories();
  Future<List<Product>> getProductsByCategory(String categoryId);
  Future<List<Product>> searchProducts(String query);
}
