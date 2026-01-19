import 'dart:typed_data';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import 'package:pizzeria_pepe_app/core/theme/app_colors.dart';
import 'package:pizzeria_pepe_app/core/theme/app_text_styles.dart';
import 'package:pizzeria_pepe_app/features/menu/domain/entities/product.dart';
import 'package:pizzeria_pepe_app/features/menu/domain/entities/extra.dart';
import 'package:pizzeria_pepe_app/features/menu/presentation/providers/menu_providers.dart';

class AdminEditProductScreen extends ConsumerStatefulWidget {
  final String? productId; // Null if adding new
  const AdminEditProductScreen({super.key, this.productId});

  @override
  ConsumerState<AdminEditProductScreen> createState() => _AdminEditProductScreenState();
}

class _AdminEditProductScreenState extends ConsumerState<AdminEditProductScreen> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _nameController;
  late TextEditingController _descController;
  late TextEditingController _priceController;
  String? _selectedCategoryId;
  Uint8List? _imageBytes;
  String? _currentImageUrl;
  bool _isLoading = false;
  List<String> _currentExtrasIds = [];

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController();
    _descController = TextEditingController();
    _priceController = TextEditingController();
    
    if (widget.productId != null) {
      // Edit mode: fetch data
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _loadProductData();
      });
    }
  }

  Future<void> _loadProductData() async {
    final product = await ref.read(menuRepositoryProvider).getProductById(widget.productId!);
    if (product != null) {
      setState(() {
        _nameController.text = product.name;
        _descController.text = product.description;
        _priceController.text = product.price.toString();
        _selectedCategoryId = product.categoryId;
        _currentImageUrl = product.imageUrl;
        _currentExtrasIds = List.from(product.availableExtrasIds);
      });
    }
  }

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final XFile? image = await picker.pickImage(source: ImageSource.gallery);
    
    if (image != null) {
      final bytes = await image.readAsBytes();
      setState(() {
        _imageBytes = bytes;
      });
    }
  }

  Future<void> _saveProduct() async {
    if (!_formKey.currentState!.validate()) return;
    if (_selectedCategoryId == null) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Selecciona una categoría')));
      return;
    }
    if (_imageBytes == null && _currentImageUrl == null) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Sube una imagen')));
      return;
    }

    setState(() => _isLoading = true);

    try {
      String imageUrl = _currentImageUrl ?? '';
      
      // Upload image if new one selected
      if (_imageBytes != null) {
        final fileName = '${DateTime.now().millisecondsSinceEpoch}_${_nameController.text.replaceAll(' ', '_')}.jpg';
        imageUrl = await ref.read(menuRepositoryProvider).uploadProductImage(_imageBytes!, fileName);
      }

      final product = Product(
        id: widget.productId ?? '', 
        name: _nameController.text,
        description: _descController.text,
        price: double.parse(_priceController.text.replaceAll(',', '.')),
        imageUrl: imageUrl,
        categoryId: _selectedCategoryId!,
        isVegetarian: false,
        isSpicy: false,
        availableExtrasIds: _currentExtrasIds,
      );

      if (widget.productId == null) {
        await ref.read(menuRepositoryProvider).addProduct(product);
      } else {
        await ref.read(menuRepositoryProvider).updateProduct(product);
      }

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Producto guardado')));
        context.pop();
        // Refresh providers? Riverpod should handle streams/invalidations if we set it up.
        // Since we are using FutureProviders, we might need to invalidate them manually.
        ref.invalidate(currentProductsProvider);
        // Also invalidate category specific
        ref.invalidate(productsByCategoryProvider(_selectedCategoryId!));
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error: $e')));
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final categoriesAsync = ref.watch(categoriesProvider);

    return Scaffold(
      appBar: AppBar(title: Text(widget.productId == null ? 'Nuevo Producto' : 'Editar Producto')),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(24.r),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Image Picker
              GestureDetector(
                onTap: _pickImage,
                child: Container(
                  height: 200.h,
                  decoration: BoxDecoration(
                    color: Colors.grey[200],
                    borderRadius: BorderRadius.circular(12.r),
                    border: Border.all(color: Colors.grey),
                  ),
                  child: _imageBytes != null
                      ? ClipRRect(borderRadius: BorderRadius.circular(12.r), child: Image.memory(_imageBytes!, fit: BoxFit.cover))
                      : (_currentImageUrl != null && _currentImageUrl!.isNotEmpty)
                          ? ClipRRect(borderRadius: BorderRadius.circular(12.r), child: Image.network(_currentImageUrl!, fit: BoxFit.cover))
                          : Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(Icons.add_a_photo, size: 50.sp, color: Colors.grey),
                                SizedBox(height: 8.h),
                                const Text('Toca para añadir foto'),
                              ],
                            ),
                ),
              ),
              SizedBox(height: 24.h),

              // Name
              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(labelText: 'Nombre del Producto', border: OutlineInputBorder()),
                validator: (v) => v!.isEmpty ? 'Requerido' : null,
              ),
              SizedBox(height: 16.h),

              // Description
              TextFormField(
                controller: _descController,
                decoration: const InputDecoration(labelText: 'Descripción', border: OutlineInputBorder()),
                maxLines: 3,
                validator: (v) => v!.isEmpty ? 'Requerido' : null,
              ),
              SizedBox(height: 16.h),

              // Price
              TextFormField(
                controller: _priceController,
                decoration: const InputDecoration(labelText: 'Precio (€)', border: OutlineInputBorder(), suffixText: '€'),
                keyboardType: const TextInputType.numberWithOptions(decimal: true),
                validator: (v) {
                  if (v!.isEmpty) return 'Requerido';
                  if (double.tryParse(v.replaceAll(',', '.')) == null) return 'Inválido';
                  return null;
                },
              ),
              SizedBox(height: 16.h),

              // Category Dropdown
              categoriesAsync.when(
                data: (categories) => DropdownButtonFormField<String>(
                  value: _selectedCategoryId,
                  decoration: const InputDecoration(labelText: 'Categoría', border: OutlineInputBorder()),
                  items: categories.map((c) => DropdownMenuItem(value: c.id, child: Text(c.name))).toList(),
                  onChanged: (v) => setState(() => _selectedCategoryId = v),
                ),
                loading: () => const LinearProgressIndicator(),
                error: (e, s) => Text('Error al cargar categorías: $e'),
              ),
              
              // Extras Selection
              Text('Complementos Disponibles', style: AppTextStyles.bodyLarge.copyWith(fontWeight: FontWeight.bold)),
              SizedBox(height: 8.h),
              FutureBuilder<List<Extra>>(
                 future: ref.read(menuRepositoryProvider).getExtras(),
                 builder: (context, snapshot) {
                   if (!snapshot.hasData) return const LinearProgressIndicator();
                   final allExtras = snapshot.data!;
                   return Column(
                     children: allExtras.map((Extra extra) {
                       return CheckboxListTile(
                         title: Text(extra.name),
                         subtitle: Text('+${extra.price.toStringAsFixed(2)}€'),
                         value: _currentExtrasIds.contains(extra.id),
                         onChanged: (bool? selected) {
                           setState(() {
                             if (selected == true) {
                               _currentExtrasIds.add(extra.id);
                             } else {
                               _currentExtrasIds.remove(extra.id);
                             }
                           });
                         },
                       );
                     }).toList(),
                   );
                 },
              ),
              SizedBox(height: 32.h),

              ElevatedButton(
                onPressed: _isLoading ? null : _saveProduct,
                style: ElevatedButton.styleFrom(
                  padding: EdgeInsets.symmetric(vertical: 16.h),
                  backgroundColor: AppColors.primary,
                ),
                child: _isLoading 
                  ? const CircularProgressIndicator(color: Colors.white) 
                  : Text(widget.productId == null ? 'CREAR PRODUCTO' : 'GUARDAR CAMBIOS', style: AppTextStyles.labelLarge),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
