import 'package:flutter/material.dart';
import 'package:food_app/features/home/presentation/view/home_view.dart';
import 'package:food_app/features/order_tracking/presentation/view/order_tracking_view.dart';
import 'package:food_app/features/splash/presentation/view/splash_view.dart';
import 'package:go_router/go_router.dart';

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

BuildContext getContext() {
  final context = navigatorKey.currentContext;
  if (context == null) {
    throw FlutterError(
      'Navigator currentContext is null. The navigator is not in the tree '
      'or has been disposed.',
    );
  }
  return context;
}

class AppRoutes {
  static final GoRouter router = GoRouter(
    navigatorKey: navigatorKey,
    initialLocation: SplashView.route,
    routes: [
      GoRoute(
        path: SplashView.route,
        pageBuilder: (context, state) =>
            const NoTransitionPage(child: SplashView()),
      ),
      GoRoute(
        path: HomeView.route,
        pageBuilder: (context, state) =>
            const NoTransitionPage(child: HomeView()),
      ),
      GoRoute(
        path: OrderTrackingView.route,
        pageBuilder: (context, state) => NoTransitionPage(
          child: OrderTrackingView(
            orderId: (state.extra as String?) ?? 'ORD-4417',
          ),
        ),
      ),
      GoRoute(
        path: '/order/:id',
        pageBuilder: (context, state) => NoTransitionPage(
          child: OrderTrackingView(
            orderId: state.pathParameters['id'] ?? 'ORD-4417',
          ),
        ),
      ),

    ],
  );
}
