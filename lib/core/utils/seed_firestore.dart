import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import '../../features/menu/data/repositories/menu_data.dart';
import '../../firebase_options.dart';

Future<void> seedFirestore() async {
  debugPrint('🌱 Starting Seeding Process...');
  
  try {
    final firestore = FirebaseFirestore.instance;
    
    // Check if seeding is needed (e.g., check if categories exist)
    final categoriesCount = await firestore.collection('categories').count().get();
    
    if (categoriesCount.count != null && categoriesCount.count! > 0) {
      debugPrint('✅ Firestore already has data. Skipping seed.');
      return;
    }

    debugPrint('🚀 Seeding categories...');
    final batch = firestore.batch();
    
    for (final category in kMenuCategories) {
      final docRef = firestore.collection('categories').doc(category.id);
      batch.set(docRef, category.toJson());
    }

    debugPrint('🍕 Seeding products...');
    for (final product in kFullMenuProducts) {
      final docRef = firestore.collection('products').doc(product.id);
      batch.set(docRef, product.toJson());
    }

    await batch.commit();
    debugPrint('✨ Seeding completed successfully!');
  } catch (e) {
    debugPrint('❌ Seeding failed: $e');
  }
}
