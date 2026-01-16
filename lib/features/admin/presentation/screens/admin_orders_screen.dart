import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:pizzeria_pepe_app/core/theme/app_colors.dart';
import 'package:pizzeria_pepe_app/core/theme/app_text_styles.dart';
import 'package:pizzeria_pepe_app/features/orders/domain/entities/order.dart';
import 'package:pizzeria_pepe_app/features/orders/presentation/providers/orders_provider.dart';

class AdminOrdersScreen extends ConsumerWidget {
  const AdminOrdersScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final allOrdersAsync = ref.watch(allOrdersProvider);

    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        title: Text('Panel de Administración', style: AppTextStyles.displaySmall),
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
      ),
      body: allOrdersAsync.when(
        data: (orders) {
          if (orders.isEmpty) {
            return const Center(child: Text('No hay pedidos registrados'));
          }

          return ListView.builder(
            padding: EdgeInsets.all(16.r),
            itemCount: orders.length,
            itemBuilder: (context, index) {
              final order = orders[index];
              return _AdminOrderCard(order: order);
            },
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, stack) => Center(child: Text('Error: $err')),
      ),
    );
  }
}

class _AdminOrderCard extends ConsumerWidget {
  final OrderEntity order;
  const _AdminOrderCard({required this.order});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final dateStr = DateFormat('dd/MM HH:mm').format(order.createdAt);

    return Card(
      elevation: 2,
      margin: EdgeInsets.only(bottom: 16.h),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.r)),
      child: Padding(
        padding: EdgeInsets.all(16.r),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Pedido #${order.id.substring(0, 5)}', style: AppTextStyles.labelLarge),
                _StatusBadge(status: order.status),
              ],
            ),
            SizedBox(height: 8.h),
            Text('Cliente: ${order.userId.substring(0, 8)}...', style: AppTextStyles.bodyMedium),
            Text('Fecha: $dateStr', style: AppTextStyles.bodySmall),
            const Divider(),
            ...order.items.map((item) => Padding(
                  padding: EdgeInsets.symmetric(vertical: 2.h),
                  child: Text('${item['quantity']}x ${item['product']['name']}', style: AppTextStyles.bodyMedium),
                )),
            const Divider(),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Total: ${order.total.toStringAsFixed(2)}€', style: AppTextStyles.labelLarge.copyWith(color: AppColors.primary)),
                _ActionButton(orderId: order.id, currentStatus: order.status),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _StatusBadge extends StatelessWidget {
  final String status;
  const _StatusBadge({required this.status});

  @override
  Widget build(BuildContext context) {
    Color color;
    String label;
    switch (status) {
      case 'pending':
        color = Colors.orange;
        label = 'PENDIENTE';
        break;
      case 'cooking':
        color = Colors.blue;
        label = 'COCINANDO';
        break;
      case 'delivered':
        color = Colors.green;
        label = 'ENTREGADO';
        break;
      default:
        color = Colors.grey;
        label = status.toUpperCase();
    }

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 4.h),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(20.r),
        border: Border.all(color: color),
      ),
      child: Text(label, style: AppTextStyles.bodySmall.copyWith(color: color, fontWeight: FontWeight.bold)),
    );
  }
}

class _ActionButton extends ConsumerWidget {
  final String orderId;
  final String currentStatus;
  const _ActionButton({required this.orderId, required this.currentStatus});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    String nextStatus;
    String label;
    Color color;

    if (currentStatus == 'pending') {
      nextStatus = 'cooking';
      label = 'COCINAR';
      color = Colors.blue;
    } else if (currentStatus == 'cooking') {
      nextStatus = 'delivered';
      label = 'ENTREGAR';
      color = Colors.green;
    } else {
      return const SizedBox.shrink();
    }

    return ElevatedButton(
      onPressed: () {
        ref.read(ordersRepositoryProvider).updateOrderStatus(orderId, nextStatus);
      },
      style: ElevatedButton.styleFrom(
        backgroundColor: color,
        foregroundColor: Colors.white,
        padding: EdgeInsets.symmetric(horizontal: 16.w),
      ),
      child: Text(label, style: AppTextStyles.button),
    );
  }
}
