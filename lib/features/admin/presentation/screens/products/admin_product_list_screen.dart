import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:pizzeria_pepe_app/features/menu/presentation/providers/menu_providers.dart';
import 'package:pizzeria_pepe_app/core/theme/app_colors.dart';
import 'package:pizzeria_pepe_app/core/theme/app_text_styles.dart';
import 'package:pizzeria_pepe_app/features/menu/domain/entities/product.dart';

class AdminProductListScreen extends ConsumerWidget {
  const AdminProductListScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    
    final categoriesAsync = ref.watch(categoriesProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Gestión de Productos'),
        actions: [
          TextButton(
            onPressed: () => context.push('/admin/products/extras'),
            child: const Text('EXTRAS', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
      body: categoriesAsync.when(
        data: (categories) => DefaultTabController(
          length: categories.length,
          child: Column(
            children: [
              TabBar(
                isScrollable: true,
                labelColor: AppColors.primary,
                unselectedLabelColor: Colors.grey,
                indicatorColor: AppColors.primary,
                tabs: categories.map((c) => Tab(text: c.name)).toList(),
              ),
              Expanded(
                child: TabBarView(
                  children: categories.map((category) => _ProductList(categoryId: category.id)).toList(),
                ),
              ),
            ],
          ),
        ),
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, stack) => Center(child: Text('Error: $err')),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => context.push('/admin/products/add'),
        backgroundColor: AppColors.primary,
        child: const Icon(Icons.add),
      ),
    );
  }
}

class _ProductList extends ConsumerWidget {
  final String categoryId;
  const _ProductList({required this.categoryId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final productsAsync = ref.watch(productsByCategoryProvider(categoryId));

    return productsAsync.when(
      data: (List<Product> products) {
        if (products.isEmpty) {
          return Center(child: Text('No hay productos en esta categoría', style: AppTextStyles.bodyMedium));
        }
        return ListView.builder(
          padding: EdgeInsets.all(16.r),
          itemCount: products.length,
          itemBuilder: (context, index) {
            final product = products[index];
            return Card(
              margin: EdgeInsets.only(bottom: 12.h),
              child: ListTile(
                leading: ClipRRect(
                  borderRadius: BorderRadius.circular(4.r),
                  child: Image.network(
                    product.imageUrl,
                    width: 50.w,
                    height: 50.w,
                    fit: BoxFit.cover,
                    errorBuilder: (_,__,___) => Container(color: Colors.grey, width: 50.w, height: 50.w),
                  ),
                ),
                title: Text(product.name, style: AppTextStyles.bodyMedium.copyWith(fontWeight: FontWeight.bold)),
                subtitle: Text('${product.price.toStringAsFixed(2)} €', style: AppTextStyles.bodySmall),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Switch(
                      value: product.available,
                      onChanged: (val) async {
                         await ref.read(menuRepositoryProvider).updateProduct(product.copyWith(available: val));
                         // Force refresh of this category
                         ref.invalidate(productsByCategoryProvider(categoryId));
                      },
                      activeThumbColor: Colors.green,
                    ),
                    IconButton(
                      icon: const Icon(Icons.edit, color: Colors.blue),
                      onPressed: () => context.push('/admin/products/edit/${product.id}'),
                    ),
                  ],
                ),
              ),
            ).animate().fadeIn().slideX();
          },
        );
      },
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (err, stack) => Center(child: Text('Error: $err')),
    );
  }
}
