import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../providers/cart_provider.dart';

class CartScreen extends ConsumerWidget {
  const CartScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final cartItems = ref.watch(cartProvider);
    final total = ref.watch(cartTotalProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Mi Pedido'),
      ),
      body: cartItems.isEmpty
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                   Icon(Icons.shopping_cart_outlined, size: 64.sp, color: AppColors.textLow),
                   SizedBox(height: 16.h),
                   Text('Tu pedido está vacío', style: AppTextStyles.labelLarge),
                ],
              ),
            )
          : Column(
              children: [
                Expanded(
                  child: ListView.separated(
                    padding: EdgeInsets.all(16.r),
                    itemCount: cartItems.length,
                    separatorBuilder: (context, index) => SizedBox(height: 12.h),
                    itemBuilder: (context, index) {
                      final item = cartItems[index];
                      return Container(
                        margin: EdgeInsets.only(bottom: 12.h),
                        padding: EdgeInsets.all(12.r),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(12.r),
                          boxShadow: const [BoxShadow(color: Colors.black12, blurRadius: 4, offset: Offset(0, 2))],
                        ),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Image
                            ClipRRect(
                              borderRadius: BorderRadius.circular(8.r),
                              child: (item.product.imageUrl.isNotEmpty)
                                  ? Image.network(item.product.imageUrl, width: 60.w, height: 60.w, fit: BoxFit.cover, errorBuilder: (_,__,___) => Container(color: Colors.grey, width: 60.w, height: 60.w))
                                  : Container(color: Colors.grey, width: 60.w, height: 60.w),
                            ),
                            SizedBox(width: 12.w),
                            // Details
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(item.product.name, style: AppTextStyles.bodyLarge.copyWith(fontWeight: FontWeight.bold)),
                                  Text('${item.pricePerUnit.toStringAsFixed(2)} €', style: AppTextStyles.price),
                                  if (item.selectedExtras.isNotEmpty)
                                    Padding(
                                      padding: EdgeInsets.only(top: 4.h),
                                      child: Text('+ ${item.selectedExtras.join(', ')}', style: AppTextStyles.bodySmall.copyWith(color: AppColors.textLow)),
                                    ),
                                  if (item.notes != null && item.notes!.isNotEmpty)
                                    Padding(
                                      padding: EdgeInsets.only(top: 4.h),
                                      child: Text('Nota: ${item.notes}', style: AppTextStyles.bodySmall.copyWith(fontStyle: FontStyle.italic, color: Colors.blueGrey)),
                                    ),
                                ],
                              ),
                            ),
                            // Quantity Controls
                            Column(
                              children: [
                                Row(
                                  children: [
                                    IconButton(
                                      icon: const Icon(Icons.remove_circle_outline, color: AppColors.primary),
                                      onPressed: () => ref.read(cartProvider.notifier).removeItem(item),
                                      padding: EdgeInsets.zero,
                                      constraints: const BoxConstraints(),
                                    ),
                                    Padding(
                                      padding: EdgeInsets.symmetric(horizontal: 8.w),
                                      child: Text('${item.quantity}', style: AppTextStyles.labelLarge),
                                    ),
                                    IconButton(
                                      icon: const Icon(Icons.add_circle_outline, color: AppColors.primary),
                                      onPressed: () => ref.read(cartProvider.notifier).addItem(item.copyWith(quantity: 1)),
                                      padding: EdgeInsets.zero,
                                      constraints: const BoxConstraints(),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ],
                        ),
                      ).animate()
                        .fadeIn(duration: 400.ms, delay: (index * 80).ms)
                        .slideX(begin: 0.2, end: 0, curve: Curves.easeOutQuad);
                    },
                  ),
                ),
                Container(
                  padding: EdgeInsets.all(24.r),
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    boxShadow: [
                      BoxShadow(color: Colors.black12, blurRadius: 10, offset: Offset(0, -4)),
                    ],
                  ),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('Total', style: AppTextStyles.displayMedium),
                          Text('${total.toStringAsFixed(2)} €', style: AppTextStyles.displayMedium.copyWith(color: AppColors.primary)),
                        ],
                      ),
                      SizedBox(height: 16.h),
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: () => context.go('/checkout'),
                          child: const Text('TRAMITAR PEDIDO'),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
    );
  }
}
