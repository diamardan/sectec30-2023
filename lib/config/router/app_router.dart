import 'package:sectec30/features/authentication/check_auth_status_screen.dart';
import 'package:sectec30/features/authentication/login_screen.dart';
import 'package:sectec30/features/authentication/providers/auth_provider.dart';
import 'package:sectec30/features/home/screens/about_screen.dart';
import 'package:sectec30/features/home/screens/home_screen.dart';
import 'package:sectec30/features/home/screens/settings_screen.dart';
import 'package:sectec30/features/home/screens/term_conditions_screen.dart';
import 'package:sectec30/features/identity_card/screens/identity_card_screen.dart';
import 'package:sectec30/features/identity_card/screens/identity_card_screen2.dart';
import 'package:sectec30/features/notification/screens/notification_detail_screen.dart';
import 'package:sectec30/features/notification/screens/notification_screen.dart';
import 'package:sectec30/features/attendance/screens/attendance_screen.dart';
import 'package:sectec30/features/profile/screens/profile_screen.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'app_router_notifier.dart';

final goRouterProvider = Provider((ref) {
  final goRouterNotifier = ref.read(goRouterNotifierProvider);

  return GoRouter(
    initialLocation: '/splash',
    refreshListenable: goRouterNotifier,
    routes: [
      ///* Primera pantalla
      GoRoute(
        path: '/splash',
        builder: (context, state) => const CheckAuthStatusScreen(),
      ),

      ///* Auth Routes
      GoRoute(
        path: '/login',
        builder: (context, state) => const LoginScreen(),
      ),

      ///App
      GoRoute(
        path: '/',
        builder: (context, state) => HomeScreen(),
      ),
      GoRoute(
        path: '/profile',
        builder: (context, state) => ProfileScreen(),
      ),
      GoRoute(
        path: '/identity-card',
        builder: (context, state) => NewIdentityCardScreen(),
      ),
      GoRoute(
          path: '/precense',
          builder: (context, state) => const AttendanceScreen()),
      GoRoute(
          path: '/notifications',
          builder: (context, state) => NotificationScreen()),
      GoRoute(
        path: '/notification-detail',
        name: 'notification-detail',
        builder: (context, state) => NotificationDetailScreen(
          id: state.extra as String,
        ),
      ),
      GoRoute(path: '/settings', builder: (context, state) => SettingsScreen()),
      GoRoute(path: '/about', builder: (context, state) => const AboutScreen()),

      GoRoute(
          path: '/privacy-policy',
          builder: (context, state) => TermConditionsScreen()),
    ],
    redirect: (context, GoRouterState state) {
      final isGoingTo = state.matchedLocation;
      final authStatus = goRouterNotifier.authStatus;

      if (isGoingTo == '/splash' && authStatus == AuthStatus.checking)
        return null;

      if (authStatus == AuthStatus.notAuthenticated) {
        if (isGoingTo == '/login' || isGoingTo == '/register') return null;

        return '/login';
      }

      if (authStatus == AuthStatus.authenticated) {
        if (isGoingTo == '/login' ||
            isGoingTo == '/register' ||
            isGoingTo == '/splash') {
          return '/';
        }
      }

      return null;
    },
  );
});
