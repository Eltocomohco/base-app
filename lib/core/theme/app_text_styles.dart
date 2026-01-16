import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'app_colors.dart';

class AppTextStyles {
  // Calligraphic Headings (Lobster Two)
  static TextStyle get displayLarge => GoogleFonts.lobsterTwo(
        fontSize: 32.sp,
        fontWeight: FontWeight.bold,
        color: AppColors.textHigh,
      );

  static TextStyle get displayMedium => GoogleFonts.lobsterTwo(
        fontSize: 28.sp,
        fontWeight: FontWeight.bold,
        color: AppColors.textHigh,
      );

  // Modern Buttons & Capsules (Bebas Neue)
  static TextStyle get button => GoogleFonts.bebasNeue(
        fontSize: 18.sp,
        fontWeight: FontWeight.w500,
        color: AppColors.textInverse,
        letterSpacing: 1.0,
      );

  static TextStyle get labelLarge => GoogleFonts.bebasNeue(
        fontSize: 20.sp,
        color: AppColors.textHigh,
        letterSpacing: 0.5,
      );

  // Body Text (Montserrat/Lato - defaulting to Montserrat for clean look)
  static TextStyle get bodyLarge => GoogleFonts.montserrat(
        fontSize: 16.sp,
        color: AppColors.textHigh,
        height: 1.5,
      );

  static TextStyle get bodyMedium => GoogleFonts.montserrat(
        fontSize: 14.sp,
        color: AppColors.textMedium,
        height: 1.4,
      );

  static TextStyle get price => GoogleFonts.montserrat(
        fontSize: 18.sp,
        fontWeight: FontWeight.bold,
        color: AppColors.primary,
      );
}
