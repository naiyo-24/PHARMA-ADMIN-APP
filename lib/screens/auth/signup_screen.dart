import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';

import '../../notifiers/auth_notifier.dart';
import '../../providers/auth_provider.dart';
import '../../routes/app_router.dart';
import '../../theme/app_theme.dart';

class SignupScreen extends ConsumerStatefulWidget {
  const SignupScreen({super.key});

  @override
  ConsumerState<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends ConsumerState<SignupScreen> {
  final _pageController = PageController();
  int _pageIndex = 0;

  final _companyController = TextEditingController();
  final _phoneController = TextEditingController();
  final _emailController = TextEditingController();
  final _gstController = TextEditingController();
  final _cinController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _obscure = true;

  @override
  void dispose() {
    _pageController.dispose();
    _companyController.dispose();
    _phoneController.dispose();
    _emailController.dispose();
    _gstController.dispose();
    _cinController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final padding = AppLayout.pagePadding(context);
    final auth = ref.watch(authNotifierProvider);
    final isLoading = auth.isLoading;
    final iconColor = theme.colorScheme.onSurface.withAlpha(204);
    final green = theme.colorScheme.primary;

    ref.listen(authNotifierProvider, (prev, next) {
      if (!mounted) return;
      next.whenOrNull(
        error: (e, _) {
          final message = e is AuthException ? e.message : 'Sign-up failed.';
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text(message)));
        },
      );
    });

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: padding,
          child: Align(
            alignment: Alignment.topLeft,
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 560),
              child: Column(
                children: [
                  Expanded(
                    child: PageView(
                      controller: _pageController,
                      physics: const NeverScrollableScrollPhysics(),
                      onPageChanged: (i) => setState(() => _pageIndex = i),
                      children: [
                        _SignupSlide(
                          title: 'Company details',
                          caption:
                              'Start with the basics. We’ll use this to set up your MR management workspace.',
                          fields: [
                            TextFormField(
                              controller: _companyController,
                              textInputAction: TextInputAction.next,
                              decoration: const InputDecoration(
                                labelText: 'Company name',
                                prefixIcon: Icon(Iconsax.building, size: 20),
                              ),
                            ),
                            const SizedBox(height: 14),
                            TextFormField(
                              controller: _phoneController,
                              keyboardType: TextInputType.phone,
                              textInputAction: TextInputAction.done,
                              decoration: const InputDecoration(
                                labelText: 'Phone no',
                                prefixIcon: Icon(Iconsax.call, size: 20),
                              ),
                            ),
                          ],
                          footer: _alreadyHaveAccount(theme),
                          actions: _slideActions(isLoading: isLoading),
                        ),
                        _SignupSlide(
                          title: 'Contact & identity',
                          caption:
                              'Use an email you’ll always have access to. GST is optional.',
                          fields: [
                            TextFormField(
                              controller: _emailController,
                              keyboardType: TextInputType.emailAddress,
                              textInputAction: TextInputAction.next,
                              decoration: InputDecoration(
                                labelText: 'Email ID',
                                prefixIcon: Icon(
                                  Iconsax.sms,
                                  size: 20,
                                  color: green,
                                ),
                              ),
                            ),
                            const SizedBox(height: 14),
                            TextFormField(
                              controller: _gstController,
                              textInputAction: TextInputAction.done,
                              decoration: const InputDecoration(
                                labelText: 'GST no (if any)',
                                prefixIcon: Icon(Iconsax.document, size: 20),
                              ),
                            ),
                          ],
                          footer: _alreadyHaveAccount(theme),
                          actions: _slideActions(isLoading: isLoading),
                        ),
                        _SignupSlide(
                          title: 'Security',
                          caption:
                              'Set your CIN number and choose a strong password to protect your data.',
                          fields: [
                            TextFormField(
                              controller: _cinController,
                              textInputAction: TextInputAction.next,
                              decoration: const InputDecoration(
                                labelText: 'CIN no',
                                prefixIcon: Icon(
                                  Iconsax.document_text,
                                  size: 20,
                                ),
                              ),
                            ),
                            const SizedBox(height: 14),
                            TextFormField(
                              controller: _passwordController,
                              obscureText: _obscure,
                              textInputAction: TextInputAction.done,
                              decoration: InputDecoration(
                                labelText: 'Password',
                                prefixIcon: Icon(
                                  Iconsax.lock,
                                  size: 20,
                                  color: green,
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
                            ),
                          ],
                          footer: _alreadyHaveAccount(theme),
                          actions: _slideActions(isLoading: isLoading),
                        ),
                      ],
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

  Widget _slideActions({required bool isLoading}) {
    return Padding(
      padding: const EdgeInsets.only(top: 10),
      child: Row(
        children: [
          if (_pageIndex > 0)
            Expanded(
              child: OutlinedButton(
                onPressed: isLoading ? null : () => _goToPage(_pageIndex - 1),
                child: const Text('Back'),
              ),
            ),
          if (_pageIndex > 0) const SizedBox(width: 12),
          Expanded(
            child: FilledButton(
              onPressed: isLoading ? null : _onPrimary,
              child: isLoading
                  ? const SizedBox(
                      width: 18,
                      height: 18,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                  : Text(_pageIndex < 2 ? 'Next' : 'Sign up'),
            ),
          ),
        ],
      ),
    );
  }

  Widget _alreadyHaveAccount(ThemeData theme) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.only(top: 18),
        child: Text.rich(
          TextSpan(
            style: theme.textTheme.bodyMedium?.copyWith(
              color: theme.colorScheme.onSurface.withAlpha(191),
              fontWeight: FontWeight.w600,
            ),
            children: [
              const TextSpan(text: 'Already have an account? '),
              WidgetSpan(
                alignment: PlaceholderAlignment.baseline,
                baseline: TextBaseline.alphabetic,
                child: InkWell(
                  onTap: () => context.goNamed(AppRoutes.login),
                  child: Text(
                    'Sign in',
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
    );
  }

  void _goToPage(int index) {
    _pageController.animateToPage(
      index,
      duration: const Duration(milliseconds: 320),
      curve: Curves.easeOutCubic,
    );
  }

  Future<void> _onPrimary() async {
    FocusScope.of(context).unfocus();

    if (_pageIndex < 2) {
      if (!_validateCurrentSlide()) return;
      _goToPage(_pageIndex + 1);
      return;
    }

    if (!_validateAll()) return;

    try {
      await ref
          .read(authNotifierProvider.notifier)
          .signUp(
            companyName: _companyController.text,
            phoneNumber: _phoneController.text,
            email: _emailController.text,
            gstNumber: _gstController.text,
            cinNumber: _cinController.text,
            password: _passwordController.text,
          );

      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Account created. Please sign in.')),
      );
      context.goNamed(AppRoutes.login);
    } catch (_) {
      // Error is surfaced via ref.listen.
    }
  }

  bool _validateCurrentSlide() {
    String? error;
    if (_pageIndex == 0) {
      if (_companyController.text.trim().isEmpty) {
        error = 'Company name is required.';
      } else if (_phoneController.text
              .trim()
              .replaceAll(RegExp(r'\D'), '')
              .length <
          10) {
        error = 'Enter a valid phone number.';
      }
    } else if (_pageIndex == 1) {
      final email = _emailController.text.trim();
      final ok = RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$').hasMatch(email);
      if (email.isEmpty) {
        error = 'Email is required.';
      } else if (!ok) {
        error = 'Enter a valid email.';
      }
    }

    if (error != null) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(error)));
      return false;
    }
    return true;
  }

  bool _validateAll() {
    final company = _companyController.text.trim();
    final phoneDigits = _phoneController.text.trim().replaceAll(
      RegExp(r'\D'),
      '',
    );
    final email = _emailController.text.trim();
    final cin = _cinController.text.trim();
    final password = _passwordController.text;
    final emailOk = RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$').hasMatch(email);

    String? error;
    if (company.isEmpty) {
      error = 'Company name is required.';
    } else if (phoneDigits.length < 10) {
      error = 'Enter a valid phone number.';
    } else if (email.isEmpty) {
      error = 'Email is required.';
    } else if (!emailOk) {
      error = 'Enter a valid email.';
    } else if (cin.isEmpty) {
      error = 'CIN no is required.';
    } else if (password.isEmpty) {
      error = 'Password is required.';
    } else if (password.length < 6) {
      error = 'Password must be at least 6 characters.';
    }

    if (error != null) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(error)));
      return false;
    }
    return true;
  }
}

class _SignupSlide extends StatelessWidget {
  const _SignupSlide({
    required this.title,
    required this.caption,
    required this.fields,
    required this.footer,
    required this.actions,
  });

  final String title;
  final String caption;
  final List<Widget> fields;
  final Widget footer;
  final Widget actions;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final surface = theme.colorScheme.surface;
    theme.colorScheme.outline.withAlpha(204);
    final iconColor = theme.colorScheme.onSurface.withAlpha(204);

    return Align(
      alignment: Alignment.topCenter,
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const SizedBox(height: 6),
            Text(
              title,
              style: theme.textTheme.header.copyWith(
                fontWeight: FontWeight.w800,
              ),
              textAlign: TextAlign.start,
            ),
            const SizedBox(height: 8),
            Text(
              caption,
              style: theme.textTheme.description.copyWith(
                color: theme.colorScheme.onSurface.withAlpha(191),
                fontWeight: FontWeight.w600,
                fontStyle: FontStyle.italic,
              ),
              textAlign: TextAlign.start,
            ),
            const SizedBox(height: 18),
            Card(
              color: surface,
              elevation: 0,
              surfaceTintColor: Colors.transparent,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(24),
                
              ),
              child: Padding(
                padding: const EdgeInsets.all(4),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    IconTheme(
                      data: IconThemeData(color: iconColor, size: 20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: fields,
                      ),
                    ),
                    footer,
                    actions,
                  ],
                ),
              ),
            ),
            const SizedBox(height: 8),
          ],
        ),
      ),
    );
  }
}
