import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../features/menu/presentation/screens/menu_screen.dart';
import '../../features/cart/presentation/screens/cart_screen.dart';
import '../../features/profile/presentation/screens/profile_screen.dart';
import '../../features/checkout/presentation/screens/checkout_screen.dart';
import '../../features/checkout/presentation/screens/order_success_screen.dart';
import '../../features/profile/presentation/screens/order_history_screen.dart';
import '../../features/profile/presentation/screens/my_addresses_screen.dart';
import '../../features/admin/presentation/screens/admin_orders_screen.dart';
import '../../features/menu/presentation/screens/product_detail_screen.dart';
import '../../features/admin/presentation/screens/products/admin_product_list_screen.dart';
import '../../features/admin/presentation/screens/products/admin_edit_product_screen.dart';
import '../../features/admin/presentation/screens/categories/admin_categories_screen.dart';
import '../../features/admin/presentation/screens/notifications/admin_notifications_screen.dart';
import '../../features/admin/presentation/screens/extras/admin_extras_screen.dart';
import 'scaffold_with_nav_bar.dart';

part 'app_router.g.dart';

final _rootNavigatorKey = GlobalKey<NavigatorState>();
final _shellNavigatorMenuKey = GlobalKey<NavigatorState>(debugLabel: 'shellMenu');
final _shellNavigatorCartKey = GlobalKey<NavigatorState>(debugLabel: 'shellCart');
final _shellNavigatorProfileKey = GlobalKey<NavigatorState>(debugLabel: 'shellProfile');

@riverpod
GoRouter goRouter(Ref ref) {
  return GoRouter(
    initialLocation: '/',
    navigatorKey: _rootNavigatorKey,
    routes: [
      StatefulShellRoute.indexedStack(
        builder: (context, state, navigationShell) {
          return ScaffoldWithNavBar(navigationShell: navigationShell);
        },
        branches: [
          StatefulShellBranch(
            navigatorKey: _shellNavigatorMenuKey,
            routes: [
              GoRoute(
                path: '/',
                builder: (context, state) => const MenuScreen(),
              ),
            ],
          ),
          StatefulShellBranch(
            navigatorKey: _shellNavigatorCartKey,
            routes: [
              GoRoute(
                path: '/cart',
                builder: (context, state) => const CartScreen(),
              ),
            ],
          ),
          StatefulShellBranch(
            navigatorKey: _shellNavigatorProfileKey,
            routes: [
              GoRoute(
                path: '/profile',
                builder: (context, state) => const ProfileScreen(),
                routes: [
                  GoRoute(
                    path: 'orders',
                    builder: (context, state) => const OrderHistoryScreen(),
                  ),
                  GoRoute(
                    path: 'addresses',
                    builder: (context, state) => const MyAddressesScreen(),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
      GoRoute(
        path: '/product/:id',
        builder: (context, state) => ProductDetailScreen(productId: state.pathParameters['id']!),
      ),
      GoRoute(
        path: '/checkout',
        builder: (context, state) => const CheckoutScreen(),
        routes: [
          GoRoute(
            path: 'success',
            builder: (context, state) => const OrderSuccessScreen(),
          ),
        ],
      ),
      GoRoute(
        path: '/admin',
        builder: (context, state) => const AdminOrdersScreen(),
        routes: [
          GoRoute(
            path: 'notifications',
            builder: (context, state) => const AdminNotificationsScreen(),
          ),
          GoRoute(
            path: 'products',
            builder: (context, state) => const AdminProductListScreen(),
            routes: [
              GoRoute(
                path: 'categories',
                builder: (context, state) => const AdminCategoriesScreen(),
              ),
              GoRoute(
                path: 'extras',
                builder: (context, state) => const AdminExtrasScreen(),
              ),
              GoRoute(
                path: 'add',
                builder: (context, state) => const AdminEditProductScreen(),
              ),
              GoRoute(
                path: 'edit/:id',
                builder: (context, state) => AdminEditProductScreen(productId: state.pathParameters['id']),
              ),
            ],
          ),
        ],
      ),
    ],
  );
}
