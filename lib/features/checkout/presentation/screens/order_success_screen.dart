import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';

class OrderSuccessScreen extends StatelessWidget {
  const OrderSuccessScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Padding(
          padding: EdgeInsets.all(24.r),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                padding: EdgeInsets.all(24.r),
                decoration: const BoxDecoration(
                  color: AppColors.success,
                  shape: BoxShape.circle,
                ),
                child: Icon(Icons.check, color: Colors.white, size: 60.sp)
                    .animate()
                    .scale(duration: 600.ms, curve: Curves.elasticOut)
                    .then()
                    .shimmer(duration: 1500.ms, color: Colors.white.withOpacity(0.5)),
              ).animate().scale(duration: 500.ms, curve: Curves.elasticOut),
              
              SizedBox(height: 32.h),
              
              Text(
                '¡Pedido Confirmado!',
                style: AppTextStyles.displayMedium.copyWith(color: AppColors.primary),
                textAlign: TextAlign.center,
              ).animate().fadeIn().moveY(begin: 20, end: 0),
              
              SizedBox(height: 16.h),
              
              Text(
                'Tu pedido ha sido recibido correctamente en cocina. ¡En breve estará listo!',
                style: AppTextStyles.bodyLarge,
                textAlign: TextAlign.center,
              ),

              SizedBox(height: 48.h),
              
              ElevatedButton(
                onPressed: () => context.go('/'),
                style: ElevatedButton.styleFrom(
                  minimumSize: Size(double.infinity, 50.h),
                ),
                child: const Text('VOLVER A LA CARTA'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
