import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:pizzeria_pepe_app/core/theme/app_colors.dart';
import 'package:pizzeria_pepe_app/features/menu/domain/entities/extra.dart';
import 'package:pizzeria_pepe_app/features/menu/presentation/providers/menu_providers.dart';

class AdminExtrasScreen extends ConsumerWidget {
  const AdminExtrasScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // For now, assume we fetch extras.
    // We need a provider for Extras. We will create it on the fly or need to add it to menu_providers.
    // Let's assume there is one or create a FutureBuilder calling the repo directly for now as simple MVP.
    final repo = ref.watch(menuRepositoryProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Gestión de Extras')),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showAddExtraDialog(context, ref),
        backgroundColor: AppColors.primary,
        child: const Icon(Icons.add),
      ),
      body: FutureBuilder<List<Extra>>(
        future: repo.getExtras(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }

          final extras = snapshot.data ?? [];
          if (extras.isEmpty) return const Center(child: Text('No hay extras definidos.'));

          return ListView.builder(
            padding: EdgeInsets.all(16.r),
            itemCount: extras.length,
            itemBuilder: (context, index) {
              final extra = extras[index];
              return Card(
                child: ListTile(
                  title: Text(extra.name),
                  subtitle: Text('${extra.price.toStringAsFixed(2)} €'),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                       Switch(
                         value: extra.available, 
                         onChanged: (val) async {
                           await repo.updateExtra(extra.copyWith(available: val));
                           // Force rebuild? In real app use a Stream or StateNotifier
                           (context as Element).markNeedsBuild();
                         }
                       ),
                       IconButton(
                         icon: const Icon(Icons.delete, color: Colors.red),
                         onPressed: () async {
                            await repo.deleteExtra(extra.id);
                            // Force rebuild
                            (context as Element).markNeedsBuild();
                         },
                       ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }

  void _showAddExtraDialog(BuildContext context, WidgetRef ref) {
    final nameController = TextEditingController();
    final priceController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Nuevo Extra'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(controller: nameController, decoration: const InputDecoration(labelText: 'Nombre')),
            TextField(controller: priceController, decoration: const InputDecoration(labelText: 'Precio'), keyboardType: TextInputType.number),
          ],
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancelar')),
          ElevatedButton(
            onPressed: () async {
              if (nameController.text.isNotEmpty && priceController.text.isNotEmpty) {
                 final extra = Extra(
                   id: '',
                   name: nameController.text,
                   price: double.tryParse(priceController.text.replaceAll(',', '.')) ?? 0.0,
                   available: true,
                 );
                 await ref.read(menuRepositoryProvider).addExtra(extra);
                 if (context.mounted) Navigator.pop(context);
                 // In a better arch, the list would auto-update.
              }
            },
            child: const Text('Guardar'),
          ),
        ],
      ),
    );
  }
}
