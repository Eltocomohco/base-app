import 'dart:typed_data';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import '../../domain/entities/category.dart';
import '../../domain/entities/product.dart';
import '../../domain/entities/extra.dart';
import '../../domain/repositories/menu_repository.dart';

class FirestoreMenuRepository implements MenuRepository {
  final FirebaseFirestore _firestore;

  FirestoreMenuRepository(this._firestore);

  // Admin Methods - Categories
  @override
  Future<List<Category>> getCategories() async {
    try {
      final snapshot = await _firestore.collection('categories').orderBy('id').get();
      if (snapshot.docs.isEmpty) {
        // Fallback or seed logic could go here, but for now return empty or default
         return const [
          Category(id: '1', name: 'Entrantes', iconAsset: 'assets/icons/starter.png'), 
          Category(id: '2', name: 'Ensaladas', iconAsset: 'assets/icons/salad.png'),
          Category(id: '3', name: 'Pasta', iconAsset: 'assets/icons/pasta.png'),
          Category(id: '4', name: 'Pizzas', iconAsset: 'assets/icons/pizza.png'),
          Category(id: '5', name: 'Hamburguesas', iconAsset: 'assets/icons/burger.png'),
          Category(id: '6', name: 'Postres', iconAsset: 'assets/icons/dessert.png'),
        ];
      }
      return snapshot.docs.map((doc) {
        final data = doc.data();
        data['id'] = doc.id;
        return Category.fromJson(data);
      }).toList();
    } catch (e) {
      // Fallback in case of offline/error
       return const [
          Category(id: '1', name: 'Entrantes', iconAsset: 'assets/icons/starter.png'), 
          Category(id: '2', name: 'Ensaladas', iconAsset: 'assets/icons/salad.png'),
          Category(id: '3', name: 'Pasta', iconAsset: 'assets/icons/pasta.png'),
          Category(id: '4', name: 'Pizzas', iconAsset: 'assets/icons/pizza.png'),
          Category(id: '5', name: 'Hamburguesas', iconAsset: 'assets/icons/burger.png'),
          Category(id: '6', name: 'Postres', iconAsset: 'assets/icons/dessert.png'),
        ];
    }
  }

  @override
  Future<void> addCategory(Category category) async {
    final docRef = category.id.isNotEmpty 
        ? _firestore.collection('categories').doc(category.id)
        : _firestore.collection('categories').doc();
        
    final newCategory = category.copyWith(id: docRef.id);
    await docRef.set(newCategory.toJson());
  }

  @override
  Future<void> updateCategory(Category category) async {
    await _firestore.collection('categories').doc(category.id).update(category.toJson());
  }

  @override
  Future<void> deleteCategory(String categoryId) async {
    await _firestore.collection('categories').doc(categoryId).delete();
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

  @override
  Future<Product?> getProductById(String id) async {
    try {
      final doc = await _firestore.collection('products').doc(id).get();
      if (doc.exists) {
        final data = doc.data()!;
        data['id'] = doc.id;
        return Product.fromJson(data);
      }
      return null;
    } catch (e) {
      return null;
    }
  }
  // Admin Methods - Products
  @override
  Future<void> addProduct(Product product) async {
    // We let Firestore generate ID if empty, or use product.id if set (unlikely for new)
    // Actually, usually we want a new doc.
    final docRef = _firestore.collection('products').doc();
    // Create copy with the new ID
    final newProduct = product.copyWith(id: docRef.id);
    await docRef.set(newProduct.toJson());
  }

  @override
  Future<void> updateProduct(Product product) async {
    await _firestore.collection('products').doc(product.id).update(product.toJson());
  }

  @override
  Future<void> deleteProduct(String productId) async {
    await _firestore.collection('products').doc(productId).delete();
  }

  @override
  Future<String> uploadProductImage(Uint8List bytes, String fileName) async {
    final ref = FirebaseStorage.instance.ref().child('products/$fileName');
    final uploadTask = ref.putData(bytes);
    final snapshot = await uploadTask;
    return await snapshot.ref.getDownloadURL();
  }

  // Admin Methods - Extras
  @override
  Future<List<Extra>> getExtras() async {
    final snapshot = await _firestore.collection('extras').get();
    return snapshot.docs.map((doc) {
      final data = doc.data();
      data['id'] = doc.id;
      return Extra.fromJson(data);
    }).toList();
  }

  @override
  Future<void> addExtra(Extra extra) async {
    final docRef = _firestore.collection('extras').doc();
    final newExtra = extra.copyWith(id: docRef.id);
    await docRef.set(newExtra.toJson());
  }

  @override
  Future<void> updateExtra(Extra extra) async {
    await _firestore.collection('extras').doc(extra.id).update(extra.toJson());
  }

  @override
  Future<void> deleteExtra(String extraId) async {
    await _firestore.collection('extras').doc(extraId).delete();
  }
}
