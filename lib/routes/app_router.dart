import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../screens/auth/login_screen.dart';
import '../screens/auth/signup_screen.dart';
import '../screens/auth/splash_screen.dart';
import '../screens/about_us/about_us_screen.dart';
import '../screens/dashboard/dashboard_screen.dart';
import '../screens/mr_management/mr_details_screen.dart';
import '../screens/mr_management/mr_management_screen.dart';
import '../screens/mr_management/onboard_edit_mr_screen.dart';
import '../screens/profile/profile_screen.dart';
import '../screens/terms_conditions/terms_conditions_screen.dart';

sealed class AppRoutes {
  static const splash = 'splash';
  static const login = 'login';
  static const signup = 'signup';
  static const dashboard = 'dashboard';
  static const termsConditions = 'termsConditions';
  static const aboutUs = 'aboutUs';
  static const profile = 'profile';
  static const mrManagement = 'mrManagement';
  static const mrDetails = 'mrDetails';
  static const onboardMr = 'onboardMr';
  static const editMr = 'editMr';

  static const splashPath = '/';
  static const loginPath = '/login';
  static const signupPath = '/signup';
  static const dashboardPath = '/dashboard';
  static const termsConditionsPath = '/terms-conditions';
  static const aboutUsPath = '/about-us';
  static const profilePath = '/profile';
  static const mrManagementPath = '/mr-management';
  static const mrDetailsPath = ':mrId';
  static const onboardMrPath = 'onboard';
  static const editMrPath = ':mrId/edit';
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
        path: AppRoutes.mrManagementPath,
        name: AppRoutes.mrManagement,
        builder: (context, state) => const MrManagementScreen(),
        routes: [
          GoRoute(
            path: AppRoutes.mrDetailsPath,
            name: AppRoutes.mrDetails,
            builder: (context, state) {
              final mrId = state.pathParameters['mrId'] ?? '';
              return MrDetailsScreen(mrId: mrId);
            },
          ),
          GoRoute(
            path: AppRoutes.onboardMrPath,
            name: AppRoutes.onboardMr,
            builder: (context, state) => const OnboardEditMrScreen(),
          ),
          GoRoute(
            path: AppRoutes.editMrPath,
            name: AppRoutes.editMr,
            builder: (context, state) {
              final mrId = state.pathParameters['mrId'] ?? '';
              return OnboardEditMrScreen(mrId: mrId);
            },
          ),
        ],
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
        path: AppRoutes.profilePath,
        name: AppRoutes.profile,
        builder: (context, state) => const ProfileScreen(),
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
