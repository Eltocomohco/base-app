import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../providers/menu_providers.dart';

class CategorySelector extends ConsumerWidget {
  const CategorySelector({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final categoriesAsync = ref.watch(categoriesProvider);
    final selectedCategoryId = ref.watch(selectedCategoryProvider);

    return categoriesAsync.when(
      data: (categories) => SizedBox(
        height: 60.h,
        child: ListView.separated(
          scrollDirection: Axis.horizontal,
          padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
          itemCount: categories.length,
          separatorBuilder: (context, index) => SizedBox(width: 12.w),
          itemBuilder: (context, index) {
            final category = categories[index];
            final isSelected = category.id == selectedCategoryId;

            return FilterChip(
              label: Text(category.name),
              labelStyle: isSelected 
                  ? AppTextStyles.labelLarge.copyWith(color: Colors.white, fontSize: 16.sp)
                  : AppTextStyles.bodyMedium.copyWith(fontSize: 14.sp),
              selected: isSelected,
              onSelected: (bool selected) {
                if (selected) {
                  ref.read(selectedCategoryProvider.notifier).select(category.id);
                }
              },
              backgroundColor: Colors.white,
              selectedColor: AppColors.primary,
              checkmarkColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20.r),
                side: BorderSide(
                  color: isSelected ? AppColors.primary : AppColors.textLow.withValues(alpha: 0.2),
                ),
              ),
              padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 4.h),
            );
          },
        ),
      ),
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (err, stack) => const SizedBox(),
    );
  }
}
