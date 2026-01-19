import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../domain/repositories/menu_repository.dart';
import '../../data/repositories/firestore_menu_repository.dart';
import '../../domain/entities/category.dart';
import '../../domain/entities/product.dart';

part 'menu_providers.g.dart';

@riverpod
MenuRepository menuRepository(Ref ref) {
  return FirestoreMenuRepository(FirebaseFirestore.instance);
}

@riverpod
Future<List<Category>> categories(Ref ref) {
  return ref.watch(menuRepositoryProvider).getCategories();
}

@riverpod
class SelectedCategory extends _$SelectedCategory {
  @override
  String build() => '4'; // Default to Pizzas

  void select(String categoryId) {
    state = categoryId;
  }
}

@riverpod
Future<List<Product>> currentProducts(Ref ref) {
  final categoryId = ref.watch(selectedCategoryProvider);
  return ref.watch(menuRepositoryProvider).getProductsByCategory(categoryId);
}

@riverpod
Future<Product?> productById(Ref ref, String id) {
  return ref.watch(menuRepositoryProvider).getProductById(id);
}
@riverpod
Future<List<Product>> productsByCategory(Ref ref, String categoryId) {
  return ref.watch(menuRepositoryProvider).getProductsByCategory(categoryId);
}
