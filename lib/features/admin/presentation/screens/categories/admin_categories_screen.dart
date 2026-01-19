import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:pizzeria_pepe_app/core/theme/app_colors.dart';
import 'package:pizzeria_pepe_app/features/menu/domain/entities/category.dart';
import 'package:pizzeria_pepe_app/features/menu/presentation/providers/menu_providers.dart';

class AdminCategoriesScreen extends ConsumerWidget {
  const AdminCategoriesScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // We can reuse the existing categories provider
    final categoriesAsync = ref.watch(categoriesProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Gestión de Categorías')),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showCategoryDialog(context, ref),
        backgroundColor: AppColors.primary,
        child: const Icon(Icons.add),
      ),
      body: categoriesAsync.when(
        data: (categories) {
          if (categories.isEmpty) return const Center(child: Text('No hay categorías'));
          
          return ListView.builder(
            padding: EdgeInsets.all(16.r),
            itemCount: categories.length,
            itemBuilder: (context, index) {
              final category = categories[index];
              return Card(
                child: ListTile(
                  leading: Image.asset(category.iconAsset, width: 32.w, height: 32.w, errorBuilder: (_,__,___) => const Icon(Icons.category)),
                  title: Text(category.name),
                  subtitle: Text('ID: ${category.id}'),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.edit, color: Colors.blue),
                        onPressed: () => _showCategoryDialog(context, ref, category: category),
                      ),
                      IconButton(
                        icon: const Icon(Icons.delete, color: Colors.red),
                        onPressed: () => _confirmDelete(context, ref, category),
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, stack) => Center(child: Text('Error: $err')),
      ),
    );
  }

  void _showCategoryDialog(BuildContext context, WidgetRef ref, {Category? category}) {
    final nameController = TextEditingController(text: category?.name ?? '');
    final idController = TextEditingController(text: category?.id ?? '');
    
    // For now we default to a generic icon or let them type the path. 
    // Ideally we'd have an icon picker.
    final iconController = TextEditingController(text: category?.iconAsset ?? 'assets/icons/pizza.png');

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(category == null ? 'Nueva Categoría' : 'Editar Categoría'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: idController, 
              decoration: const InputDecoration(labelText: 'ID (Opcional si es nueva)'),
              enabled: category == null, // Allow ID edit only on creation for ordering
            ),
            SizedBox(height: 8.h),
            TextField(controller: nameController, decoration: const InputDecoration(labelText: 'Nombre')),
             SizedBox(height: 8.h),
            TextField(controller: iconController, decoration: const InputDecoration(labelText: 'Asset Icon Path')),
            // Helper text for icons
            Text('Ej: assets/icons/dessert.png', style: TextStyle(fontSize: 10.sp, color: Colors.grey)),
          ],
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancelar')),
          ElevatedButton(
            onPressed: () async {
              if (nameController.text.isNotEmpty) {
                final newCategory = Category(
                  id: idController.text.trim(), // Empty ID means auto-gen in Repo, but we might want manual for order
                  name: nameController.text.trim(),
                  iconAsset: iconController.text.trim().isEmpty ? 'assets/icons/pizza.png' : iconController.text.trim(),
                  isSelected: false,
                );

                if (category == null) {
                  await ref.read(menuRepositoryProvider).addCategory(newCategory);
                } else {
                  // For update, keep original ID
                  await ref.read(menuRepositoryProvider).updateCategory(newCategory.copyWith(id: category.id));
                }
                
                // Refresh categories
                ref.invalidate(categoriesProvider);
                
                if (context.mounted) Navigator.pop(context);
              }
            },
            child: const Text('Guardar'),
          ),
        ],
      ),
    );
  }

  void _confirmDelete(BuildContext context, WidgetRef ref, Category category) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Eliminar Categoría'),
        content: Text('¿Seguro que quieres eliminar "${category.name}"?'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancelar')),
          TextButton(
            onPressed: () async {
              await ref.read(menuRepositoryProvider).deleteCategory(category.id);
               ref.invalidate(categoriesProvider);
              if (context.mounted) Navigator.pop(context);
            },
            child: const Text('Eliminar', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }
}
