import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../screens/auth/login_screen.dart';
import '../screens/auth/signup_screen.dart';
import '../screens/auth/splash_screen.dart';
import '../screens/about_us/about_us_screen.dart';
import '../screens/dashboard/dashboard_screen.dart';
import '../screens/terms_conditions/terms_conditions_screen.dart';

sealed class AppRoutes {
  static const splash = 'splash';
  static const login = 'login';
  static const signup = 'signup';
  static const dashboard = 'dashboard';
  static const termsConditions = 'termsConditions';
  static const aboutUs = 'aboutUs';

  static const splashPath = '/';
  static const loginPath = '/login';
  static const signupPath = '/signup';
  static const dashboardPath = '/dashboard';
  static const termsConditionsPath = '/terms-conditions';
  static const aboutUsPath = '/about-us';
}

final appRouterProvider = Provider<GoRouter>((ref) {
  return GoRouter(
    initialLocation: AppRoutes.splashPath,
    debugLogDiagnostics: false,
    routes: [
      GoRoute(
        path: AppRoutes.splashPath,
        name: AppRoutes.splash,
        builder: (context, state) => const SplashScreen(),
      ),
      GoRoute(
        path: AppRoutes.dashboardPath,
        name: AppRoutes.dashboard,
        builder: (context, state) => const DashboardScreen(),
      ),
      GoRoute(
        path: AppRoutes.termsConditionsPath,
        name: AppRoutes.termsConditions,
        builder: (context, state) => const TermsConditionsScreen(),
      ),
      GoRoute(
        path: AppRoutes.aboutUsPath,
        name: AppRoutes.aboutUs,
        builder: (context, state) => const AboutUsScreen(),
      ),
      GoRoute(
        path: AppRoutes.loginPath,
        name: AppRoutes.login,
        builder: (context, state) => const LoginScreen(),
      ),
      GoRoute(
        path: AppRoutes.signupPath,
        name: AppRoutes.signup,
        builder: (context, state) => const SignupScreen(),
      ),
    ],
    errorBuilder: (context, state) {
      return Scaffold(
        body: Center(
          child: Text(
            'Route not found',
            style: Theme.of(context).textTheme.titleLarge,
          ),
        ),
      );
    },
  );
});
