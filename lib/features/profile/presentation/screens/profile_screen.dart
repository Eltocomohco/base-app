import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import 'package:go_router/go_router.dart';
import '../../../auth/presentation/providers/auth_provider.dart';
import '../../../auth/presentation/screens/login_screen.dart';

class ProfileScreen extends ConsumerWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(authProvider);

    if (user == null) {
      return const LoginScreen();
    }

    return Scaffold(
      appBar: AppBar(title: const Text('Mi Perfil')),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16.r),
        child: Column(
          children: [
            // User Header
            Row(
              children: [
                CircleAvatar(
                  radius: 30.r,
                  backgroundColor: AppColors.primary.withValues(alpha: 0.1),
                  child: Text(
                    user.name != null && user.name!.isNotEmpty 
                        ? user.name!.substring(0, 1).toUpperCase() 
                        : (user.email.isNotEmpty ? user.email.substring(0, 1).toUpperCase() : '?'), 
                    style: AppTextStyles.displayMedium.copyWith(color: AppColors.primary),
                  ),
                ),
                SizedBox(width: 16.w),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(user.name ?? 'Usuario', style: AppTextStyles.labelLarge),
                    Text(user.email, style: AppTextStyles.bodyMedium),
                  ],
                ),
              ],
            ),
            
            SizedBox(height: 32.h),
            
            
            // Menu Options
            if (user.email == 'admin@pepe.com')
              _buildProfileOption(Icons.admin_panel_settings, 'Panel Admin', () => context.push('/admin')),
            
            _buildProfileOption(Icons.history, 'Mis Pedidos', () => context.go('/profile/orders')),
            _buildProfileOption(Icons.location_on_outlined, 'Mis Direcciones', () => context.go('/profile/addresses')),
            _buildProfileOption(Icons.credit_card, 'Métodos de Pago', () {}),
            _buildProfileOption(Icons.settings_outlined, 'Ajustes', () {}),
            
            SizedBox(height: 32.h),
            
            TextButton(
              onPressed: () => ref.read(authProvider.notifier).logout(),
              child: const Text('Cerrar Sesión', style: TextStyle(color: Colors.red)),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProfileOption(IconData icon, String title, VoidCallback onTap) {
    return ListTile(
      leading: Icon(icon, color: AppColors.primary),
      title: Text(title, style: AppTextStyles.bodyLarge),
      trailing: const Icon(Icons.chevron_right),
      onTap: onTap,
    );
  }
}
