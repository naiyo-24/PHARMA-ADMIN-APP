import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';

import '../../notifiers/auth_notifier.dart';
import '../../providers/auth_provider.dart';
import '../../routes/app_router.dart';
import '../../theme/app_theme.dart';

class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key});

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _obscure = true;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final padding = AppLayout.pagePadding(context);
    final auth = ref.watch(authNotifierProvider);
    final isLoading = auth.isLoading;
    final surface = theme.colorScheme.surface;
    theme.colorScheme.outline.withAlpha(204);
    final iconColor = theme.colorScheme.onSurface.withAlpha(204);

    ref.listen(authNotifierProvider, (prev, next) {
      if (!mounted) return;
      next.whenOrNull(
        error: (e, _) {
          final message = e is AuthException ? e.message : 'Sign-in failed.';
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text(message)));
        },
      );
    });

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: padding,
          child: Align(
            alignment: Alignment.topCenter,
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 520),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const SizedBox(height: 8),

                  Align(
                    alignment: Alignment.centerLeft,
                    child: Image.asset(
                      'assets/logo/naiyo24_logo.png',
                      width: 64,
                      height: 64,
                      fit: BoxFit.contain,
                    ),
                  ),
                  const SizedBox(height: 16),

                  Text(
                    'Welcome back',
                    textAlign: TextAlign.start,
                    style: theme.textTheme.header.copyWith(
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Get ready to sign in using your email ID and password to track your medical representatives.',
                    textAlign: TextAlign.start,
                    style: theme.textTheme.description.copyWith(
                      color: theme.colorScheme.onSurface.withAlpha(191),
                      fontWeight: FontWeight.w600,
                      fontStyle: FontStyle.italic,
                    ),
                  ),
                  const SizedBox(height: 22),
                  Card(
                    color: surface,
                    elevation: 0,
                    surfaceTintColor: Colors.transparent,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(24),
                      
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(8),
                      child: Form(
                        key: _formKey,
                        child: Column(
                          children: [
                            TextFormField(
                              controller: _emailController,
                              keyboardType: TextInputType.emailAddress,
                              textInputAction: TextInputAction.next,
                              autofillHints: const [AutofillHints.username],
                              decoration: InputDecoration(
                                labelText: 'Email ID',
                                prefixIcon: Icon(
                                  Iconsax.sms,
                                  size: 20,
                                  color: iconColor,
                                ),
                              ),
                              validator: (v) {
                                final value = (v ?? '').trim();
                                if (value.isEmpty) return 'Email is required.';
                                final ok = RegExp(
                                  r'^[^@\s]+@[^@\s]+\.[^@\s]+$',
                                ).hasMatch(value);
                                if (!ok) return 'Enter a valid email.';
                                return null;
                              },
                            ),
                            const SizedBox(height: 14),
                            TextFormField(
                              controller: _passwordController,
                              obscureText: _obscure,
                              textInputAction: TextInputAction.done,
                              autofillHints: const [AutofillHints.password],
                              decoration: InputDecoration(
                                labelText: 'Password',
                                prefixIcon: Icon(
                                  Iconsax.lock,
                                  size: 20,
                                  color: iconColor,
                                ),
                                suffixIcon: IconButton(
                                  onPressed: () =>
                                      setState(() => _obscure = !_obscure),
                                  icon: Icon(
                                    _obscure ? Iconsax.eye : Iconsax.eye_slash,
                                    size: 20,
                                    color: iconColor,
                                  ),
                                ),
                              ),
                              validator: (v) {
                                final value = v ?? '';
                                if (value.isEmpty) {
                                  return 'Password is required.';
                                }
                                if (value.length < 6) {
                                  return 'Password must be at least 6 characters.';
                                }
                                return null;
                              },
                              onFieldSubmitted: (_) => _onSignIn(),
                            ),
                            const SizedBox(height: 18),
                            SizedBox(
                              width: double.infinity,
                              child: OutlinedButton(
                                onPressed: isLoading ? null : _onSignIn,
                                style: OutlinedButton.styleFrom(
                                  backgroundColor: surface,
                                  foregroundColor: theme.colorScheme.primary,
                                  side: BorderSide(
                                    color: theme.colorScheme.primary.withAlpha(
                                      isLoading ? 89 : 204,
                                    ),
                                  ),
                                ),
                                child: isLoading
                                    ? const SizedBox(
                                        width: 18,
                                        height: 18,
                                        child: CircularProgressIndicator(
                                          strokeWidth: 2,
                                        ),
                                      )
                                    : const Text('Sign in'),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 14),
                  Center(
                    child: Text.rich(
                      TextSpan(
                        style: theme.textTheme.bodyMedium?.copyWith(
                          color: theme.colorScheme.onSurface.withAlpha(191),
                          fontWeight: FontWeight.w600,
                        ),
                        children: [
                          const TextSpan(text: 'Having trouble logging in? '),
                          WidgetSpan(
                            alignment: PlaceholderAlignment.baseline,
                            baseline: TextBaseline.alphabetic,
                            child: InkWell(
                              onTap: () {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text('Contact support for help.'),
                                  ),
                                );
                              },
                              child: Text(
                                'Contact support',
                                style: theme.textTheme.bodyMedium?.copyWith(
                                  color: theme.colorScheme.primary,
                                  fontWeight: FontWeight.w800,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Divider(color: theme.dividerColor, thickness: 2,),
                  const SizedBox(height: 4),
                  Center(
                    child: Text.rich(
                      TextSpan(
                        style: theme.textTheme.bodyMedium?.copyWith(
                          color: theme.colorScheme.onSurface.withAlpha(191),
                          fontWeight: FontWeight.w600,
                        ),
                        children: [
                          const TextSpan(text: 'New here? '),
                          WidgetSpan(
                            alignment: PlaceholderAlignment.baseline,
                            baseline: TextBaseline.alphabetic,
                            child: InkWell(
                              onTap: () => context.pushNamed(AppRoutes.signup),
                              child: Text(
                                'Signup now',
                                style: theme.textTheme.bodyMedium?.copyWith(
                                  color: theme.colorScheme.primary,
                                  fontWeight: FontWeight.w800,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  const SizedBox(height: 12),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _onSignIn() async {
    final isValid = _formKey.currentState?.validate() ?? false;
    if (!isValid) return;

    FocusScope.of(context).unfocus();

    try {
      await ref
          .read(authNotifierProvider.notifier)
          .signIn(
            email: _emailController.text,
            password: _passwordController.text,
          );
      if (!mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Signed in successfully.')));
    } catch (_) {
      // Error is surfaced via ref.listen.
    }
  }
}
