import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../data/repositories/firestore_menu_repository.dart';
// import '../../data/repositories/mock_menu_repository.dart';
import '../../domain/entities/category.dart';
import '../../domain/entities/product.dart';
import '../../domain/repositories/menu_repository.dart';

part 'menu_providers.g.dart';

@riverpod
MenuRepository menuRepository(Ref ref) {
  // Using Firestore now that rules are configured
  return FirestoreMenuRepository(FirebaseFirestore.instance);
  // return MockMenuRepository();
}

@riverpod
class SelectedCategory extends _$SelectedCategory {
  @override
  String build() => '4'; // Default to Pizzas

  void select(String id) => state = id;
}

@riverpod
Future<List<Category>> categories(Ref ref) async {
  final repository = ref.watch(menuRepositoryProvider);
  final categories = await repository.getCategories();
  final selectedId = ref.watch(selectedCategoryProvider);
  
  return categories.map((c) => c.copyWith(isSelected: c.id == selectedId)).toList();
}

@riverpod
Future<List<Product>> productsByCategory(Ref ref, String categoryId) async {
  final repository = ref.watch(menuRepositoryProvider);
  return repository.getProductsByCategory(categoryId);
}

@riverpod
Future<List<Product>> currentProducts(Ref ref) async {
  final selectedId = ref.watch(selectedCategoryProvider);
  return ref.watch(productsByCategoryProvider(selectedId).future);
}
