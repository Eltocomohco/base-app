import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:pizzeria_pepe_app/core/theme/app_colors.dart';
import 'package:pizzeria_pepe_app/core/theme/app_text_styles.dart';
import 'package:pizzeria_pepe_app/features/orders/presentation/providers/orders_provider.dart';
import 'package:pizzeria_pepe_app/features/orders/domain/entities/order.dart';
import 'package:intl/intl.dart';

class OrderHistoryScreen extends ConsumerWidget {
  const OrderHistoryScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final ordersAsync = ref.watch(userOrdersProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Mis Pedidos')),
      body: ordersAsync.when(
        data: (orders) {
          if (orders.isEmpty) {
            return const Center(child: Text('No tienes pedidos aún'));
          }
          return ListView.separated(
            padding: EdgeInsets.all(16.r),
            itemCount: orders.length,
            separatorBuilder: (context, index) => SizedBox(height: 16.h),
            itemBuilder: (context, index) {
              final order = orders[index];
              return _OrderCard(order: order);
            },
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, st) => Center(child: Text('Error: $e')),
      ),
    );
  }
}

class _OrderCard extends StatelessWidget {
  final OrderEntity order;
  const _OrderCard({required this.order});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: EdgeInsets.all(16.r),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Pedido #${order.id.substring(0, 8)}', style: AppTextStyles.labelLarge),
                Text(
                  DateFormat('dd/MM/yyyy HH:mm').format(order.createdAt),
                  style: AppTextStyles.bodyMedium.copyWith(color: AppColors.textLow),
                ),
              ],
            ),
            SizedBox(height: 8.h),
            Text(
              order.items.map((item) => '${item['quantity']}x ${item['product']['name']}').join(', '),
              style: AppTextStyles.bodyMedium,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
            SizedBox(height: 12.h),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('${order.total.toStringAsFixed(2)} €', style: AppTextStyles.price),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 4.h),
                  decoration: BoxDecoration(
                    color: _getStatusColor(order.status).withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(20.r),
                  ),
                  child: Text(
                    order.status.toUpperCase(),
                    style: AppTextStyles.bodyMedium.copyWith(color: _getStatusColor(order.status), fontSize: 12.sp),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Color _getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'completed':
      case 'delivered':
        return AppColors.success;
      case 'pending':
        return Colors.orange;
      case 'cancelled':
        return Colors.red;
      default:
        return AppColors.primary;
    }
  }
}
