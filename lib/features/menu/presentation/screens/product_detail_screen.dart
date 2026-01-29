import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../presentation/providers/menu_providers.dart';
import '../../../cart/domain/entities/cart_item.dart';
import '../../../cart/presentation/providers/cart_provider.dart';

const List<String> availableExtras = [
  'Queso Extra',
  'Bacon',
  'Champiñones',
  'Cebolla',
  'Jamón York',
  'Pimiento',
  'Aceitunas',
  'Atún'
];

class ProductDetailScreen extends ConsumerStatefulWidget {
  final String productId;

  const ProductDetailScreen({super.key, required this.productId});

  @override
  ConsumerState<ProductDetailScreen> createState() => _ProductDetailScreenState();
}

class _ProductDetailScreenState extends ConsumerState<ProductDetailScreen> {
  final List<String> _selectedExtras = [];
  final TextEditingController _notesController = TextEditingController();
  int _quantity = 1;

  @override
  void dispose() {
    _notesController.dispose();
    super.dispose();
  }

  void _toggleExtra(String extra) {
    setState(() {
      if (_selectedExtras.contains(extra)) {
        _selectedExtras.remove(extra);
      } else {
        _selectedExtras.add(extra);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final productAsync = ref.watch(productByIdProvider(widget.productId));

    return Scaffold(
      backgroundColor: AppColors.background,
      body: productAsync.when(
        data: (product) {
          if (product == null) {
             return const Center(child: Text('Producto no encontrado'));
          }
          final double basePrice = product.price;
          final double extrasPrice = _selectedExtras.length * 1.0; 
          final double totalPrice = (basePrice + extrasPrice) * _quantity;

          return Stack(
            children: [
              CustomScrollView(
                slivers: [
                   SliverAppBar(
                     expandedHeight: 250.h,
                     pinned: true,
                     backgroundColor: AppColors.background,
                     flexibleSpace: FlexibleSpaceBar(
                       background: Stack(
                         fit: StackFit.expand,
                         children: [
                           Hero(
                             tag: 'product_${product.id}',
                             child: Image.network(
                               product.imageUrl,
                               fit: BoxFit.cover,
                               errorBuilder: (c,e,s) => Container(color: Colors.grey[300]),
                             ),
                           ),
                           const DecoratedBox(
                             decoration: BoxDecoration(
                               gradient: LinearGradient(
                                 begin: Alignment.topCenter,
                                 end: Alignment.bottomCenter,
                                 colors: [Colors.black54, Colors.transparent],
                                 stops: [0.0, 0.3],
                               ),
                             ),
                           ),
                         ],
                       ),
                     ),
                     leading: IconButton(
                       icon: const CircleAvatar(
                         backgroundColor: Colors.white,
                         child: Icon(Icons.arrow_back, color: Colors.black),
                       ),
                       onPressed: () => context.pop(),
                     ),
                   ),
                   SliverToBoxAdapter(
                     child: Padding(
                       padding: EdgeInsets.all(16.r),
                       child: Column(
                         crossAxisAlignment: CrossAxisAlignment.start,
                         children: [
                           Text(product.name, style: AppTextStyles.displayMedium),
                           SizedBox(height: 8.h),
                           Text(product.description, style: AppTextStyles.bodyMedium),
                           SizedBox(height: 16.h),
                           
                           Text('Personaliza tu pizza', style: AppTextStyles.labelLarge),
                           SizedBox(height: 8.h),

                           // Extras
                           ...availableExtras.map((extra) {
                             final isSelected = _selectedExtras.contains(extra);
                             return CheckboxListTile(
                               value: isSelected,
                               activeColor: AppColors.primary,
                               title: Text(extra),
                               subtitle: Text('+1.00 €', style: AppTextStyles.price.copyWith(fontSize: 12.sp)),
                               onChanged: (val) => _toggleExtra(extra),
                               dense: true,
                               contentPadding: EdgeInsets.zero,
                             );
                           }),

                           SizedBox(height: 16.h),
                           Text('Notas para el chef', style: AppTextStyles.labelLarge),
                           SizedBox(height: 8.h),
                           TextField(
                             controller: _notesController,
                             decoration: InputDecoration(
                               hintText: 'Sin cebolla, muy hecha...',
                               border: OutlineInputBorder(borderRadius: BorderRadius.circular(8.r)),
                               filled: true,
                               fillColor: Colors.white,
                             ),
                             maxLines: 2,
                           ),

                           SizedBox(height: 100.h), // Space for bottom bar
                         ],
                       ),
                     ),
                   ),
                ],
              ),
              Positioned(
                bottom: 0,
                left: 0,
                right: 0,
                child: Container(
                  padding: EdgeInsets.all(16.r),
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 10, offset: Offset(0, -4))],
                  ),
                  child: Row(
                    children: [
                      // Quantity Selector
                      Container(
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.grey[300]!),
                          borderRadius: BorderRadius.circular(8.r),
                        ),
                        child: Row(
                          children: [
                            IconButton(
                              icon: const Icon(Icons.remove),
                              onPressed: _quantity > 1 ? () => setState(() => _quantity--) : null,
                            ),
                            Text('$_quantity', style: AppTextStyles.bodyLarge),
                            IconButton(
                              icon: const Icon(Icons.add),
                              onPressed: () => setState(() => _quantity++),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(width: 16.w),
                      // Add Button
                      Expanded(
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            padding: EdgeInsets.symmetric(vertical: 16.h),
                            backgroundColor: AppColors.primary,
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.r)),
                          ),
                          onPressed: () {
                            final cartItem = CartItem(
                              product: product,
                              quantity: _quantity,
                              selectedExtras: List.from(_selectedExtras), // Copy
                              notes: _notesController.text.isEmpty ? null : _notesController.text,
                            );
                            ref.read(cartProvider.notifier).addItem(cartItem);
                            context.pop();
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text('Añadido al carrito')),
                            );
                          },
                          child: Text(
                            'AÑADIR ${totalPrice.toStringAsFixed(2)} €',
                            style: AppTextStyles.button.copyWith(color: Colors.white),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, stack) => Center(child: Text('Error: $err')),
      ),
    );
  }
}
