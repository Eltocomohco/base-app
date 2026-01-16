import 'package:cloud_firestore/cloud_firestore.dart';
import '../../domain/entities/category.dart';
import '../../domain/entities/product.dart';
import '../../domain/repositories/menu_repository.dart';

class FirestoreMenuRepository implements MenuRepository {
  final FirebaseFirestore _firestore;

  FirestoreMenuRepository(this._firestore);

  @override
  Future<List<Category>> getCategories() async {
    // In a real app, you might store categories in a collection.
    // For now, we'll keep hardcoding them or fetch from a 'categories' collection.
    // To match the previous mock, let's keep them hardcoded or fetch 
    // real ones if you upload them. Let's assume we want to fetch them.
    // But for safety during migration, let's return the static list 
    // matching the IDs we use for Products.
    
    // Simplification for Phase 2: Return static categories, 
    // but fetch Products from Firestore.
    return const [
      Category(id: '1', name: 'Entrantes', iconAsset: 'assets/icons/starter.png'), // Replace with real icons
      Category(id: '2', name: 'Ensaladas', iconAsset: 'assets/icons/salad.png'),
      Category(id: '3', name: 'Pasta', iconAsset: 'assets/icons/pasta.png'),
      Category(id: '4', name: 'Pizzas', iconAsset: 'assets/icons/pizza.png'),
      Category(id: '5', name: 'Hamburguesas', iconAsset: 'assets/icons/burger.png'),
      Category(id: '6', name: 'Postres', iconAsset: 'assets/icons/dessert.png'),
    ];
  }

  @override
  Future<List<Product>> getProductsByCategory(String categoryId) async {
    try {
      final snapshot = await _firestore
          .collection('products')
          .where('categoryId', isEqualTo: categoryId)
          .get();

      return snapshot.docs.map((doc) {
        final data = doc.data();
        // Ensure ID is from the doc
        data['id'] = doc.id; 
        return Product.fromJson(data);
      }).toList();
    } catch (e) {
      // Fallback or rethrow
      return [];
    }
  }

  @override
  Future<List<Product>> searchProducts(String query) async {
    // Basic search (Firestore doesn't support native full-text search easily)
    // We will do client-side filtering for this demo size
    final snapshot = await _firestore.collection('products').get();
    final allProducts = snapshot.docs.map((doc) {
       final data = doc.data();
       data['id'] = doc.id;
       return Product.fromJson(data);
    }).toList();

    return allProducts.where((p) => 
      p.name.toLowerCase().contains(query.toLowerCase())
    ).toList();
  }
}
