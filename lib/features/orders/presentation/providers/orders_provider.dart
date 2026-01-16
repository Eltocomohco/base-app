import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:pizzeria_pepe_app/features/orders/domain/entities/order.dart';
import 'package:pizzeria_pepe_app/features/orders/data/repositories/firestore_orders_repository.dart';
import 'package:pizzeria_pepe_app/features/auth/presentation/providers/auth_provider.dart';

part 'orders_provider.g.dart';

@riverpod
OrdersRepository ordersRepository(Ref ref) {
  return FirestoreOrdersRepository(FirebaseFirestore.instance);
}

@riverpod
Stream<List<OrderEntity>> userOrders(Ref ref) {
  final user = ref.watch(authProvider);
  if (user == null) return Stream.value([]);
  
  return ref.watch(ordersRepositoryProvider).getUserOrders(user.id);
}

@riverpod
Stream<List<OrderEntity>> allOrders(Ref ref) {
  return ref.watch(ordersRepositoryProvider).getAllOrders();
}
