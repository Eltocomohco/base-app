// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'menu_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(menuRepository)
final menuRepositoryProvider = MenuRepositoryProvider._();

final class MenuRepositoryProvider
    extends $FunctionalProvider<MenuRepository, MenuRepository, MenuRepository>
    with $Provider<MenuRepository> {
  MenuRepositoryProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'menuRepositoryProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$menuRepositoryHash();

  @$internal
  @override
  $ProviderElement<MenuRepository> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  MenuRepository create(Ref ref) {
    return menuRepository(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(MenuRepository value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<MenuRepository>(value),
    );
  }
}

String _$menuRepositoryHash() => r'29b18fceb0c2a1b9003ea0aeae993e91dded5efa';

@ProviderFor(categories)
final categoriesProvider = CategoriesProvider._();

final class CategoriesProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<Category>>,
          List<Category>,
          FutureOr<List<Category>>
        >
    with $FutureModifier<List<Category>>, $FutureProvider<List<Category>> {
  CategoriesProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'categoriesProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$categoriesHash();

  @$internal
  @override
  $FutureProviderElement<List<Category>> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<List<Category>> create(Ref ref) {
    return categories(ref);
  }
}

String _$categoriesHash() => r'8d1a0770278191ca80ab63635bf49c868189be65';

@ProviderFor(SelectedCategory)
final selectedCategoryProvider = SelectedCategoryProvider._();

final class SelectedCategoryProvider
    extends $NotifierProvider<SelectedCategory, String> {
  SelectedCategoryProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'selectedCategoryProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$selectedCategoryHash();

  @$internal
  @override
  SelectedCategory create() => SelectedCategory();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(String value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<String>(value),
    );
  }
}

String _$selectedCategoryHash() => r'ae09429b48531fcd8b12977321b584ccaab13ec9';

abstract class _$SelectedCategory extends $Notifier<String> {
  String build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref = this.ref as $Ref<String, String>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<String, String>,
              String,
              Object?,
              Object?
            >;
    element.handleCreate(ref, build);
  }
}

@ProviderFor(currentProducts)
final currentProductsProvider = CurrentProductsProvider._();

final class CurrentProductsProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<Product>>,
          List<Product>,
          FutureOr<List<Product>>
        >
    with $FutureModifier<List<Product>>, $FutureProvider<List<Product>> {
  CurrentProductsProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'currentProductsProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$currentProductsHash();

  @$internal
  @override
  $FutureProviderElement<List<Product>> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<List<Product>> create(Ref ref) {
    return currentProducts(ref);
  }
}

String _$currentProductsHash() => r'dd9e62008ac3549fa445084e8eca7e2e4b076476';

@ProviderFor(productById)
final productByIdProvider = ProductByIdFamily._();

final class ProductByIdProvider
    extends
        $FunctionalProvider<AsyncValue<Product?>, Product?, FutureOr<Product?>>
    with $FutureModifier<Product?>, $FutureProvider<Product?> {
  ProductByIdProvider._({
    required ProductByIdFamily super.from,
    required String super.argument,
  }) : super(
         retry: null,
         name: r'productByIdProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$productByIdHash();

  @override
  String toString() {
    return r'productByIdProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $FutureProviderElement<Product?> $createElement($ProviderPointer pointer) =>
      $FutureProviderElement(pointer);

  @override
  FutureOr<Product?> create(Ref ref) {
    final argument = this.argument as String;
    return productById(ref, argument);
  }

  @override
  bool operator ==(Object other) {
    return other is ProductByIdProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$productByIdHash() => r'f80faadc9667424f94084a1b4fecbfbdb286815a';

final class ProductByIdFamily extends $Family
    with $FunctionalFamilyOverride<FutureOr<Product?>, String> {
  ProductByIdFamily._()
    : super(
        retry: null,
        name: r'productByIdProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  ProductByIdProvider call(String id) =>
      ProductByIdProvider._(argument: id, from: this);

  @override
  String toString() => r'productByIdProvider';
}

@ProviderFor(productsByCategory)
final productsByCategoryProvider = ProductsByCategoryFamily._();

final class ProductsByCategoryProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<Product>>,
          List<Product>,
          FutureOr<List<Product>>
        >
    with $FutureModifier<List<Product>>, $FutureProvider<List<Product>> {
  ProductsByCategoryProvider._({
    required ProductsByCategoryFamily super.from,
    required String super.argument,
  }) : super(
         retry: null,
         name: r'productsByCategoryProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$productsByCategoryHash();

  @override
  String toString() {
    return r'productsByCategoryProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $FutureProviderElement<List<Product>> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<List<Product>> create(Ref ref) {
    final argument = this.argument as String;
    return productsByCategory(ref, argument);
  }

  @override
  bool operator ==(Object other) {
    return other is ProductsByCategoryProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$productsByCategoryHash() =>
    r'4c746b36e0a2ebf08ef603c83a7970e2de2e9d9f';

final class ProductsByCategoryFamily extends $Family
    with $FunctionalFamilyOverride<FutureOr<List<Product>>, String> {
  ProductsByCategoryFamily._()
    : super(
        retry: null,
        name: r'productsByCategoryProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  ProductsByCategoryProvider call(String categoryId) =>
      ProductsByCategoryProvider._(argument: categoryId, from: this);

  @override
  String toString() => r'productsByCategoryProvider';
}
