import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../providers/menu_providers.dart';
import '../widgets/category_selector.dart';
import '../widgets/product_card.dart';

class MenuScreen extends ConsumerWidget {
  const MenuScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final productsAsync = ref.watch(currentProductsProvider);

    return Scaffold(
      backgroundColor: AppColors.background,
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 120.h,
            floating: true,
            pinned: true,
            backgroundColor: AppColors.background,
            elevation: 0,
            flexibleSpace: FlexibleSpaceBar(
              titlePadding: EdgeInsets.only(bottom: 16.h),
              centerTitle: true,
              title: Text(
                'Pizzería Pepe',
                style: AppTextStyles.displayMedium.copyWith(color: AppColors.primary),
              ),
              background: Container(color: AppColors.background), // Could put a subtle texture here
            ),
          ),
          
          SliverToBoxAdapter(
            child: Padding(
               padding: EdgeInsets.symmetric(horizontal: 16.w),
               child: Text('Nuestras Especialidades', style: AppTextStyles.labelLarge),
            ),
          ),

          const SliverToBoxAdapter(child: CategorySelector()),
          
          SliverToBoxAdapter(child: SizedBox(height: 16.h)),

          productsAsync.when(
            data: (products) => SliverList(
              delegate: SliverChildBuilderDelegate(
                (context, index) => ProductCard(product: products[index]),
                childCount: products.length,
              ),
            ),
            loading: () => const SliverFillRemaining(
              child: Center(child: CircularProgressIndicator()),
            ),
            error: (err, stack) => SliverFillRemaining(
              child: Center(child: Text('Error: $err')),
            ),
          ),
          
          SliverToBoxAdapter(child: SizedBox(height: 100.h)), // Bottom padding
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final uri = Uri.parse("https://wa.me/34600000000"); // Replace with real number
          if (await canLaunchUrl(uri)) await launchUrl(uri);
        },
        backgroundColor: AppColors.accent,
        child: const Icon(Icons.chat_bubble_outline),
      ),
    );
  }
}
