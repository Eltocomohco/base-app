import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:uuid/uuid.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../cart/presentation/providers/cart_provider.dart';
import '../../../orders/domain/entities/order.dart';
import 'package:pizzeria_pepe_app/features/auth/presentation/providers/auth_provider.dart';
import '../../../orders/presentation/providers/orders_provider.dart';
import '../providers/checkout_provider.dart';

class CheckoutScreen extends ConsumerStatefulWidget {
  const CheckoutScreen({super.key});

  @override
  ConsumerState<CheckoutScreen> createState() => _CheckoutScreenState();
}

class _CheckoutScreenState extends ConsumerState<CheckoutScreen> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _addressController;
  late TextEditingController _phoneController;

  @override
  void initState() {
    super.initState();
    // Simulate pre-filling data from a logged-in user
    _addressController = TextEditingController(text: 'Calle Mayor 12, 3A');
    _phoneController = TextEditingController(text: '600123456');
  }

  @override
  void dispose() {
    _addressController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final paymentMethod = ref.watch(selectedPaymentMethodProvider);
    final total = ref.watch(cartTotalProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Tramitar Pedido')),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16.r),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Direction Section
              Text('📍 Dirección de Entrega', style: AppTextStyles.labelLarge),
              SizedBox(height: 8.h),
              TextFormField(
                controller: _addressController,
                decoration: InputDecoration(
                  hintText: 'Calle, Número, Piso...',
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12.r)),
                  filled: true,
                  fillColor: Colors.white,
                ),
                validator: (value) => value == null || value.isEmpty ? 'Por favor ignresa una dirección' : null,
              ),
               SizedBox(height: 8.h),
              TextFormField(
                controller: _phoneController,
                decoration: InputDecoration(
                  hintText: 'Teléfono de contacto',
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12.r)),
                   filled: true,
                  fillColor: Colors.white,
                ),
                keyboardType: TextInputType.phone,
                validator: (value) => value == null || value.isEmpty ? 'Por favor ingresa un teléfono' : null,
              ),
              
              SizedBox(height: 24.h),

              // Payment Methods
              Text('💳 Método de Pago', style: AppTextStyles.labelLarge),
              SizedBox(height: 8.h),
              Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12.r),
                  boxShadow: const [BoxShadow(color: Colors.black12, blurRadius: 4)],
                ),
                child: Column(
                  children: [
                    RadioListTile<PaymentMethod>(
                      title: const Text('Tarjeta de Crédito'),
                      secondary: const Icon(Icons.credit_card, color: AppColors.primary),
                      value: PaymentMethod.card,
                      groupValue: paymentMethod,
                      onChanged: (val) => ref.read(selectedPaymentMethodProvider.notifier).set(val!),
                    ),
                    const Divider(height: 1),
                    RadioListTile<PaymentMethod>(
                      title: const Text('Bizum'),
                      secondary: const Icon(Icons.mobile_friendly, color: AppColors.primary),
                      value: PaymentMethod.bizum,
                      groupValue: paymentMethod,
                      onChanged: (val) => ref.read(selectedPaymentMethodProvider.notifier).set(val!),
                    ),
                    const Divider(height: 1),
                     RadioListTile<PaymentMethod>(
                      title: const Text('Pagar en Tienda / Repartidor'),
                      secondary: const Icon(Icons.storefront, color: AppColors.primary),
                      value: PaymentMethod.store,
                      groupValue: paymentMethod,
                      onChanged: (val) => ref.read(selectedPaymentMethodProvider.notifier).set(val!),
                    ),
                  ],
                ),
              ),

              SizedBox(height: 32.h),

              // Summary
              Container(
                 padding: EdgeInsets.all(16.r),
                 decoration: BoxDecoration(
                   color: AppColors.surface,
                   borderRadius: BorderRadius.circular(12.r),
                   border: Border.all(color: AppColors.primary.withValues(alpha: 0.1)),
                 ),
                 child: Row(
                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
                   children: [
                     Text('Total a Pagar', style: AppTextStyles.displayMedium.copyWith(fontSize: 24.sp)),
                     Text('${total.toStringAsFixed(2)} €', style: AppTextStyles.displayMedium.copyWith(fontSize: 24.sp, color: AppColors.primary)),
                   ],
                 ),
              ),

               SizedBox(height: 32.h),

              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () async {
                    if (_formKey.currentState!.validate()) {
                      // Create order
                      final cartItems = ref.read(cartProvider);
                      
                      // Serialize cart items to avoid Freezed circular dependency
                      final serializedItems = cartItems.map((item) => {
                        'product': {
                          'id': item.product.id,
                          'name': item.product.name,
                          'price': item.product.price,
                          'imageUrl': item.product.imageUrl,
                          'categoryId': item.product.categoryId,
                        },
                        'quantity': item.quantity,
                      }).toList();
                      
                      final user = ref.read(authProvider);
                      final order = OrderEntity(
                        id: const Uuid().v4(),
                        userId: user?.id ?? 'anonymous', 
                        items: serializedItems,
                        total: total,
                        status: 'pending',
                        createdAt: DateTime.now(),
                        deliveryAddress: _addressController.text,
                        contactPhone: _phoneController.text,
                        paymentMethod: paymentMethod.name, // Convert enum to string
                      );

                      // Save to Firestore
                      try {
                        final repository = ref.read(ordersRepositoryProvider);
                        await repository.createOrder(order);
                        
                        // Clear cart and navigate
                        ref.read(cartProvider.notifier).clear();
                        if (context.mounted) {
                          context.go('/checkout/success');
                        }
                      } catch (e, stackTrace) {
                        print('❌ ERROR saving order: $e');
                        print('Stack trace: $stackTrace');
                        if (context.mounted) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text('Error al guardar el pedido: $e')),
                          );
                        }
                      }
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    padding: EdgeInsets.symmetric(vertical: 16.h),
                    backgroundColor: AppColors.primary,
                  ),
                  child: Text(
                    'CONFIRMAR PEDIDO',
                    style: AppTextStyles.button.copyWith(color: Colors.white),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
