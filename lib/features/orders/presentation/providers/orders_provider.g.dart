// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'orders_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(ordersRepository)
final ordersRepositoryProvider = OrdersRepositoryProvider._();

final class OrdersRepositoryProvider
    extends
        $FunctionalProvider<
          OrdersRepository,
          OrdersRepository,
          OrdersRepository
        >
    with $Provider<OrdersRepository> {
  OrdersRepositoryProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'ordersRepositoryProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$ordersRepositoryHash();

  @$internal
  @override
  $ProviderElement<OrdersRepository> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  OrdersRepository create(Ref ref) {
    return ordersRepository(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(OrdersRepository value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<OrdersRepository>(value),
    );
  }
}

String _$ordersRepositoryHash() => r'8f99612b28055fb5bf6425f1fc24c30b06630fe0';

@ProviderFor(userOrders)
final userOrdersProvider = UserOrdersProvider._();

final class UserOrdersProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<OrderEntity>>,
          List<OrderEntity>,
          Stream<List<OrderEntity>>
        >
    with
        $FutureModifier<List<OrderEntity>>,
        $StreamProvider<List<OrderEntity>> {
  UserOrdersProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'userOrdersProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$userOrdersHash();

  @$internal
  @override
  $StreamProviderElement<List<OrderEntity>> $createElement(
    $ProviderPointer pointer,
  ) => $StreamProviderElement(pointer);

  @override
  Stream<List<OrderEntity>> create(Ref ref) {
    return userOrders(ref);
  }
}

String _$userOrdersHash() => r'32d980150b255adae9bfc4d693f67d5067d0c4fd';
