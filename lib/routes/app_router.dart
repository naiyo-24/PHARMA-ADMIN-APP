
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../screens/auth/login_screen.dart';
import '../screens/auth/signup_screen.dart';
import '../screens/auth/splash_screen.dart';

sealed class AppRoutes {
	static const splash = 'splash';
	static const login = 'login';
	static const signup = 'signup';

	static const splashPath = '/';
	static const loginPath = '/login';
	static const signupPath = '/signup';
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

