import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../domain/entities/product.dart';
import '../../../../features/cart/presentation/providers/cart_provider.dart';

class ProductCard extends ConsumerWidget {
  final Product product;

  const ProductCard({super.key, required this.product});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return RepaintBoundary(
      child: GestureDetector(
        onTap: () => context.push('/product/${product.id}'),
        child: Container(
          margin: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20.r),
            boxShadow: AppColors.softShadow,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 1. Image
               ClipRRect(
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(20.r),
                  topRight: Radius.circular(20.r),
                ),
                child: Stack(
                  children: [
                    Hero(
                      tag: 'product_${product.id}',
                      child: product.imageUrl.startsWith('http') 
                      ? CachedNetworkImage(
                        imageUrl: product.imageUrl,
                        height: 190.h,
                        width: double.infinity,
                        fit: BoxFit.cover,
                        memCacheHeight: 400,
                        placeholder: (context, url) => Container(
                           color: Colors.grey[100],
                           child: const Center(child: CircularProgressIndicator()),
                        ),
                        errorWidget: (context, url, error) => Image.asset('assets/images/logo_icon.png', fit: BoxFit.contain),
                      )
                      : Image.asset(
                        product.imageUrl,
                        height: 190.h,
                        width: double.infinity,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) => Image.asset('assets/images/logo_icon.png', fit: BoxFit.contain),
                      ),
                    ),
                    // Badges overlay
                    Positioned(
                      top: 12.h,
                      right: 12.w,
                      child: Row(
                        children: [
                          if (product.isSpicy)
                            _buildBadge(Icons.local_fire_department, AppColors.primary),
                          if (product.isVegetarian)
                            _buildBadge(Icons.eco, AppColors.success),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
  
              // 2. Content
              Padding(
                padding: EdgeInsets.all(16.r),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                     Text(
                       product.name, 
                       style: AppTextStyles.labelLarge.copyWith(
                         fontSize: 24.sp,
                         height: 1.1,
                       ),
                       maxLines: 2,
                       overflow: TextOverflow.ellipsis,
                     ),
                    SizedBox(height: 6.h),
                    Text(
                      product.description,
                      style: AppTextStyles.bodyMedium.copyWith(color: AppColors.textMedium),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    SizedBox(height: 16.h),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          '${product.price.toStringAsFixed(2)} €',
                          style: AppTextStyles.price.copyWith(fontSize: 22.sp),
                        ),
                        Container(
                          decoration: BoxDecoration(
                            gradient: AppColors.primaryGradient,
                            borderRadius: BorderRadius.circular(30.r),
                            boxShadow: [
                              BoxShadow(
                                color: AppColors.primary.withOpacity(0.3),
                                blurRadius: 12,
                                offset: const Offset(0, 4),
                              ),
                            ],
                          ),
                          child: ElevatedButton(
                            onPressed: () {
                              ref.read(cartProvider.notifier).addProduct(product);
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text('${product.name} añadido al pedido'),
                                  duration: const Duration(seconds: 1),
                                  backgroundColor: AppColors.success,
                                  behavior: SnackBarBehavior.floating,
                                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.r)),
                                ),
                              );
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.transparent,
                              shadowColor: Colors.transparent,
                              padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 8.h),
                              minimumSize: Size(0, 40.h),
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30.r)),
                            ),
                            child: Text(
                              'AÑADIR', 
                              style: AppTextStyles.button.copyWith(color: Colors.white),
                            ), 
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    ).animate().fadeIn(duration: 400.ms).slideY(begin: 0.1, end: 0);
  }

  Widget _buildBadge(IconData icon, Color color) {
    return Container(
      margin: EdgeInsets.only(left: 6.w),
      padding: EdgeInsets.all(6.r),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.9),
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Icon(icon, color: color, size: 18),
    );
  }
}
