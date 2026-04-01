
import 'dart:async';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../routes/app_router.dart';
import '../../theme/app_theme.dart';

class SplashScreen extends StatefulWidget {
	const SplashScreen({super.key});

	@override
	State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
		with SingleTickerProviderStateMixin {
	late final AnimationController _controller;
	late final Animation<double> _logoBlur;
	late final Animation<double> _logoOpacity;
	late final Animation<double> _logoScale;
	late final Animation<Offset> _titleOffset;
	late final Animation<Offset> _taglineOffset;
	Timer? _timer;

	@override
	void initState() {
		super.initState();

		_controller = AnimationController(
			vsync: this,
			duration: const Duration(milliseconds: 1100),
		);

		final curve = CurvedAnimation(parent: _controller, curve: Curves.easeOutCubic);
		_logoBlur = Tween<double>(begin: 14, end: 0).animate(curve);
		_logoOpacity = Tween<double>(begin: 0.0, end: 1.0).animate(
			CurvedAnimation(parent: _controller, curve: const Interval(0.05, 0.65)),
		);
		_logoScale = Tween<double>(begin: 0.94, end: 1.0).animate(curve);

		_titleOffset = Tween<Offset>(
			begin: const Offset(-0.35, 0),
			end: Offset.zero,
		).animate(CurvedAnimation(parent: _controller, curve: const Interval(0.15, 0.85, curve: Curves.easeOutCubic)));

		_taglineOffset = Tween<Offset>(
			begin: const Offset(0.35, 0),
			end: Offset.zero,
		).animate(CurvedAnimation(parent: _controller, curve: const Interval(0.25, 0.95, curve: Curves.easeOutCubic)));

		_controller.forward();

		_timer = Timer(const Duration(milliseconds: 2500), () {
			if (!mounted) return;
			context.goNamed(AppRoutes.login);
		});
	}

	@override
	void dispose() {
		_timer?.cancel();
		_controller.dispose();
		super.dispose();
	}

	@override
	Widget build(BuildContext context) {
		final theme = Theme.of(context);
		final padding = AppLayout.pagePadding(context);

		return Scaffold(
			body: SafeArea(
				child: Center(
					child: Padding(
						padding: padding,
						child: ConstrainedBox(
							constraints: const BoxConstraints(maxWidth: 560),
							child: Column(
								mainAxisAlignment: MainAxisAlignment.center,
								crossAxisAlignment: CrossAxisAlignment.center,
								children: [
									AnimatedBuilder(
										animation: _controller,
										builder: (context, child) {
											return Opacity(
												opacity: _logoOpacity.value,
												child: Transform.scale(
													scale: _logoScale.value,
													child: ImageFiltered(
														imageFilter: ImageFilter.blur(
															sigmaX: _logoBlur.value,
															sigmaY: _logoBlur.value,
														),
														child: child,
													),
												),
											);
										},
										child: Image.asset(
											'assets/logo/naiyo24_logo.png',
											width: 120,
											height: 120,
											fit: BoxFit.contain,
										),
									),
									const SizedBox(height: 20),
									SlideTransition(
										position: _titleOffset,
										child: FadeTransition(
											opacity: CurvedAnimation(
												parent: _controller,
												curve: const Interval(0.15, 0.85),
											),
											child: Text(
												'Naiyo24 - MR Management App',
												textAlign: TextAlign.center,
												style: theme.textTheme.header.copyWith(
													fontWeight: FontWeight.w800,
												),
											),
										),
									),
									const SizedBox(height: 10),
									SlideTransition(
										position: _taglineOffset,
										child: FadeTransition(
											opacity: CurvedAnimation(
												parent: _controller,
												curve: const Interval(0.25, 0.95),
											),
											child: Text(
												'Track your medical representatives with confidence.',
												textAlign: TextAlign.center,
												style: theme.textTheme.tagline.copyWith(
													color: theme.colorScheme.onSurface.withAlpha(191),
													fontWeight: FontWeight.w600,
												),
											),
										),
									),
								],
							),
						),
					),
				),
			),
		);
	}
}

