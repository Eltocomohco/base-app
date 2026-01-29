import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../providers/menu_providers.dart';
import '../widgets/category_selector.dart';
import '../widgets/product_card.dart';
import '../../../../core/presentation/widgets/skeleton_card.dart';

class MenuScreen extends ConsumerWidget {
  const MenuScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final productsAsync = ref.watch(currentProductsProvider);

    return Scaffold(
      backgroundColor: AppColors.background,
      body: CustomScrollView(
        physics: const BouncingScrollPhysics(),
        slivers: [
          SliverAppBar(
            expandedHeight: 140.h,
            floating: true,
            pinned: true,
            stretch: true,
            backgroundColor: AppColors.background.withOpacity(0.8),
            elevation: 0,
            flexibleSpace: FlexibleSpaceBar(
              titlePadding: EdgeInsets.only(bottom: 16.h),
              centerTitle: true,
              title: Text(
                'Pizzería Pepe',
                style: AppTextStyles.displayMedium.copyWith(
                  color: AppColors.primary,
                  fontSize: 32.sp,
                ),
              ).animate().fadeIn(duration: 600.ms).scale(delay: 200.ms),
              background: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [AppColors.background, AppColors.background.withOpacity(0.5)],
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                  ),
                ),
              ),
            ),
          ),
          
          SliverToBoxAdapter(
            child: Padding(
               padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
               child: Text('Nuestras Especialidades', style: AppTextStyles.labelLarge),
            ).animate().fadeIn(delay: 300.ms).slideX(begin: -0.1),
          ),

          const SliverToBoxAdapter(child: CategorySelector()),
          
          SliverToBoxAdapter(child: SizedBox(height: 16.h)),

          productsAsync.when(
            data: (products) => SliverList(
              delegate: SliverChildBuilderDelegate(
                (context, index) {
                  return ProductCard(product: products[index])
                    .animate()
                    .fadeIn(duration: 400.ms, delay: (index * 100).ms)
                    .slideY(begin: 0.2, end: 0, curve: Curves.easeOutQuad);
                },
                childCount: products.length,
              ),
            ),
            loading: () => SliverList(
              delegate: SliverChildBuilderDelegate(
                (context, index) => const SkeletonCard()
                    .animate(onPlay: (controller) => controller.repeat())
                    .shimmer(duration: 1200.ms, color: Colors.white24),
                childCount: 3,
              ),
            ),
            error: (err, stack) => SliverFillRemaining(
              child: Center(child: Text('Error: $err')),
            ),
          ),
          
          SliverToBoxAdapter(child: SizedBox(height: 100.h)),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final uri = Uri.parse('https://wa.me/34600000000');
          if (await canLaunchUrl(uri)) await launchUrl(uri);
        },
        backgroundColor: AppColors.accent,
        child: const Icon(Icons.chat_bubble_outline),
      ),
    );
  }
}
