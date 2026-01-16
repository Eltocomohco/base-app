import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'checkout_provider.g.dart';

enum PaymentMethod { card, bizum, store }

@riverpod
class SelectedPaymentMethod extends _$SelectedPaymentMethod {
  @override
  PaymentMethod build() => PaymentMethod.store;

  void set(PaymentMethod method) => state = method;
}
