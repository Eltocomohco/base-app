import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:go_router/go_router.dart';
import 'firebase_options.dart';
import 'core/theme/app_theme.dart';
import 'core/router/app_router.dart';
import 'core/utils/seed_firestore.dart';
import 'features/notifications/presentation/services/notification_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  try {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
    
    // Register background message handler
    FirebaseMessaging.onBackgroundMessage(firebaseMessagingBackgroundHandler);
    
    // Initialize notification service
    await NotificationService().initialize();
    
    // Seed Firestore on first launch
    await seedFirestore();
  } catch (e) {
    debugPrint('Firebase init failed: $e');
  }

  runApp(const ProviderScope(child: PizzeriaPepeApp()));
}

class PizzeriaPepeApp extends ConsumerWidget {
  const PizzeriaPepeApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Explicitly type the result of ref.watch
    final GoRouter router = ref.watch(goRouterProvider);

    return ScreenUtilInit(
      designSize: const Size(375, 812),
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (context, child) {
        return MaterialApp.router(
          title: 'Pizzería Pepe',
          debugShowCheckedModeBanner: false,
          theme: AppTheme.lightTheme,
          routerConfig: router,
        );
      },
    );
  }
}
