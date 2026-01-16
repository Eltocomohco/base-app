import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';

class MyAddressesScreen extends StatelessWidget {
  const MyAddressesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Mis Direcciones')),
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        backgroundColor: AppColors.primary,
        child: const Icon(Icons.add, color: Colors.white),
      ),
      body: ListView(
        padding: EdgeInsets.all(16.r),
        children: [
          _AddressCard(
            title: 'Casa',
            address: 'Calle Mayor, 12, 3ºA',
            isDefault: true,
          ),
          SizedBox(height: 16.h),
          _AddressCard(
            title: 'Trabajo',
            address: 'Av. de la Innovación, 5, Oficina 202',
            isDefault: false,
          ),
        ],
      ),
    );
  }
}

class _AddressCard extends StatelessWidget {
  final String title;
  final String address;
  final bool isDefault;

  const _AddressCard({
    required this.title,
    required this.address,
    required this.isDefault,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12.r),
        side: isDefault ? const BorderSide(color: AppColors.primary, width: 2) : BorderSide.none,
      ),
      child: ListTile(
        leading: Icon(
          isDefault ? Icons.home : Icons.work,
          color: isDefault ? AppColors.primary : AppColors.textLow,
        ),
        title: Text(title, style: AppTextStyles.labelLarge),
        subtitle: Text(address, style: AppTextStyles.bodyMedium),
        trailing: IconButton(
          icon: const Icon(Icons.edit_outlined),
          onPressed: () {},
        ),
      ),
    );
  }
}
