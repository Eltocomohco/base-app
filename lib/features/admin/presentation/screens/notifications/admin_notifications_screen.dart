import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:pizzeria_pepe_app/core/theme/app_colors.dart';
import 'package:pizzeria_pepe_app/core/theme/app_text_styles.dart';
import 'package:pizzeria_pepe_app/features/notifications/presentation/services/notification_service.dart';

class AdminNotificationsScreen extends ConsumerStatefulWidget {
  const AdminNotificationsScreen({super.key});

  @override
  ConsumerState<AdminNotificationsScreen> createState() => _AdminNotificationsScreenState();
}

class _AdminNotificationsScreenState extends ConsumerState<AdminNotificationsScreen> {
  final _titleController = TextEditingController();
  final _bodyController = TextEditingController();
  bool _isSending = false;

  @override
  void dispose() {
    _titleController.dispose();
    _bodyController.dispose();
    super.dispose();
  }

  Future<void> _sendToAllUsers() async {
    if (_titleController.text.isEmpty || _bodyController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Por favor, completa título y mensaje')),
      );
      return;
    }

    setState(() => _isSending = true);

    try {
      // Get all user tokens from Firestore
      final usersSnapshot = await FirebaseFirestore.instance
          .collection('users')
          .where('fcmToken', isNotEqualTo: null)
          .get();

      final tokens = usersSnapshot.docs
          .map((doc) => doc.data()['fcmToken'] as String?)
          .where((token) => token != null && token.isNotEmpty)
          .cast<String>()
          .toList();

      if (tokens.isEmpty) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('No hay usuarios con tokens FCM')),
          );
        }
        return;
      }

      // Send notifications
      final notificationService = NotificationService();
      await notificationService.sendToMultipleTokens(
        tokens,
        _titleController.text,
        _bodyController.text,
        data: {'type': 'marketing'},
      );

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('✅ Notificación enviada a ${tokens.length} usuarios')),
        );
        _titleController.clear();
        _bodyController.clear();
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('❌ Error: $e')),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isSending = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Enviar Notificaciones'),
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16.r),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              '📢 Campaña de Marketing',
              style: AppTextStyles.displaySmall,
            ),
            SizedBox(height: 8.h),
            Text(
              'Envía notificaciones push a todos tus clientes',
              style: AppTextStyles.bodyMedium.copyWith(color: Colors.grey[600]),
            ),
            SizedBox(height: 24.h),
            TextField(
              controller: _titleController,
              decoration: InputDecoration(
                labelText: 'Título',
                hintText: 'Ej: ¡Oferta especial!',
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12.r)),
                prefixIcon: const Icon(Icons.title),
              ),
              maxLength: 50,
            ),
            SizedBox(height: 16.h),
            TextField(
              controller: _bodyController,
              decoration: InputDecoration(
                labelText: 'Mensaje',
                hintText: 'Ej: 2x1 en pizzas hoy hasta las 22:00',
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12.r)),
                prefixIcon: const Icon(Icons.message),
              ),
              maxLines: 4,
              maxLength: 200,
            ),
            SizedBox(height: 24.h),
            Container(
              padding: EdgeInsets.all(16.r),
              decoration: BoxDecoration(
                color: Colors.blue[50],
                borderRadius: BorderRadius.circular(12.r),
                border: Border.all(color: Colors.blue[200]!),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(Icons.preview, color: Colors.blue[700]),
                      SizedBox(width: 8.w),
                      Text('Vista Previa', style: AppTextStyles.labelLarge.copyWith(color: Colors.blue[700])),
                    ],
                  ),
                  SizedBox(height: 12.h),
                  Container(
                    padding: EdgeInsets.all(12.r),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(8.r),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Image.asset('assets/images/logo_icon.png', width: 24.w, height: 24.w),
                            SizedBox(width: 8.w),
                            Text('Pizzería Pepe', style: AppTextStyles.bodySmall.copyWith(fontWeight: FontWeight.bold)),
                          ],
                        ),
                        SizedBox(height: 8.h),
                        Text(
                          _titleController.text.isEmpty ? 'Título de la notificación' : _titleController.text,
                          style: AppTextStyles.bodyMedium.copyWith(fontWeight: FontWeight.bold),
                        ),
                        SizedBox(height: 4.h),
                        Text(
                          _bodyController.text.isEmpty ? 'Mensaje de la notificación' : _bodyController.text,
                          style: AppTextStyles.bodySmall,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 24.h),
            ElevatedButton.icon(
              onPressed: _isSending ? null : _sendToAllUsers,
              icon: _isSending
                  ? SizedBox(
                      width: 20.w,
                      height: 20.w,
                      child: const CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
                    )
                  : const Icon(Icons.send),
              label: Text(_isSending ? 'Enviando...' : 'Enviar a Todos'),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                foregroundColor: Colors.white,
                padding: EdgeInsets.symmetric(vertical: 16.h),
                textStyle: AppTextStyles.button,
              ),
            ),
            SizedBox(height: 16.h),
            Text(
              '💡 Tip: Las notificaciones se enviarán solo a usuarios que hayan iniciado sesión al menos una vez.',
              style: AppTextStyles.bodySmall.copyWith(color: Colors.grey[600], fontStyle: FontStyle.italic),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
