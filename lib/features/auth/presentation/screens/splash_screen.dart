import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:pizzeria_pepe_app/core/theme/app_colors.dart';
import 'package:pizzeria_pepe_app/core/theme/app_text_styles.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    // Simulate loading time then navigate
    Future.delayed(const Duration(seconds: 3), () {
      if (mounted) {
        context.go('/');
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primary, // Brand color background
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Logo Container with white circle background for contrast
            Container(
              padding: EdgeInsets.all(20.r),
              decoration: BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 20,
                    offset: const Offset(0, 10),
                  ),
                ],
              ),
              child: Image.asset(
                'assets/images/logo.png',
                width: 120.w,
                height: 120.w,
              ),
            )
            .animate()
            .scale(duration: 600.ms, curve: Curves.easeOutBack)
            .fadeIn(duration: 600.ms),
            
            SizedBox(height: 24.h),
            
            // Brand Name
            Text(
              'Pizzería Pepe',
              style: AppTextStyles.displayLarge.copyWith(
                color: Colors.white,
                fontSize: 40.sp,
              ),
            )
            .animate()
            .fadeIn(delay: 400.ms, duration: 600.ms)
            .slideY(begin: 0.3, end: 0, curve: Curves.easeOutQuad),

            SizedBox(height: 8.h),

            // Slogan
            Text(
              'Horneando tus sueños...',
              style: AppTextStyles.bodyLarge.copyWith(
                color: Colors.white.withOpacity(0.9),
                fontStyle: FontStyle.italic,
              ),
            )
            .animate()
            .fadeIn(delay: 800.ms, duration: 600.ms),

            SizedBox(height: 48.h),
            
            // Subtle Loader
            SizedBox(
              width: 24.w,
              height: 24.w,
              child: const CircularProgressIndicator(
                color: Colors.white,
                strokeWidth: 2,
              ),
            )
            .animate()
            .fadeIn(delay: 1000.ms),
          ],
        ),
      ),
    );
  }
}
