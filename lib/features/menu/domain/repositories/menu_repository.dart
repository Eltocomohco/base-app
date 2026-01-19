import 'dart:typed_data';
import '../../domain/entities/category.dart';
import '../../domain/entities/product.dart';
import '../../domain/entities/extra.dart';

abstract class MenuRepository {
  Future<List<Category>> getCategories();
  Future<List<Product>> getProductsByCategory(String categoryId);
  Future<List<Product>> searchProducts(String query);
  Future<Product?> getProductById(String id);

  // Admin Methods
  Future<void> addProduct(Product product);
  Future<void> updateProduct(Product product);
  Future<void> deleteProduct(String productId);
  Future<String> uploadProductImage(Uint8List bytes, String fileName);

  Future<List<Extra>> getExtras();
  Future<void> addExtra(Extra extra);
  Future<void> updateExtra(Extra extra);
  Future<void> deleteExtra(String extraId);

  // Category Management
  Future<void> addCategory(Category category);
  Future<void> updateCategory(Category category);
  Future<void> deleteCategory(String categoryId);
}
