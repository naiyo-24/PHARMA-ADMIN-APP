import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../cards/terms_conditions/terms_conditions_card.dart';
import '../../cards/terms_conditions/terms_conditions_header_card.dart';
import '../../notifiers/terms_conditions_notifier.dart';
import '../../routes/app_router.dart';
import '../../theme/app_theme.dart';
import '../../widgets/app_bar.dart';
import '../../widgets/side_nav_bar.dart';

class TermsConditionsScreen extends ConsumerWidget {
  const TermsConditionsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final padding = AppLayout.pagePadding(context);
    final termsAsync = ref.watch(termsConditionsNotifierProvider);

    return Scaffold(
      appBar: const AppAppBar(
        showLogo: false,
        showBackIfPossible: false,
        title: 'Terms & Conditions',
        subtitle: 'Policy & compliance',
      ),
      drawer: SideNavBarDrawer(
        companyName: 'Naiyo24',
        tagline: 'Admin console',
        selectedIndex: SideNavBarDrawer.destinations.indexOf(
          SideNavDestination.termsconditions,
        ),
        onSelectedIndex: (index) {
          final dashboardIndex = SideNavBarDrawer.destinations.indexOf(
            SideNavDestination.dashboard,
          );
          final mrIndex = SideNavBarDrawer.destinations.indexOf(
            SideNavDestination.mrManagement,
          );
          final profileIndex = SideNavBarDrawer.destinations.indexOf(
            SideNavDestination.profile,
          );
          final aboutIndex = SideNavBarDrawer.destinations.indexOf(
            SideNavDestination.aboutUs,
          );
          final termsIndex = SideNavBarDrawer.destinations.indexOf(
            SideNavDestination.termsconditions,
          );

          if (index == dashboardIndex) context.goNamed(AppRoutes.dashboard);
          if (index == mrIndex) context.goNamed(AppRoutes.mrManagement);
          if (index == profileIndex) context.goNamed(AppRoutes.profile);
          if (index == aboutIndex) context.goNamed(AppRoutes.aboutUs);
          if (index == termsIndex) context.goNamed(AppRoutes.termsConditions);
        },
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: padding,
          child: Align(
            alignment: Alignment.topCenter,
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 1120),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const TermsConditionsHeaderCard(
                    logoAssetPath: 'assets/logo/naiyo24_logo.png',
                    companyName: 'Naiyo24',
                    tagline: 'MR Management App',
                  ),
                  const SizedBox(height: 14),
                  termsAsync.when(
                    data: (terms) {
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          for (final t in terms) ...[
                            TermsConditionsCard(
                              header: t.header,
                              description: t.description,
                            ),
                            const SizedBox(height: 12),
                          ],
                        ],
                      );
                    },
                    loading: () => _LoadingCard(theme: theme),
                    error: (e, _) => const _ErrorCard(
                      message: 'Failed to load terms and conditions.',
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

class _LoadingCard extends StatelessWidget {
  const _LoadingCard({required this.theme});

  final ThemeData theme;

  @override
  Widget build(BuildContext context) {
    final outline = theme.colorScheme.outline.withAlpha(204);

    return Card(
      elevation: 0,
      surfaceTintColor: Colors.transparent,
      color: theme.colorScheme.surface,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(24),
        side: BorderSide(color: outline),
      ),
      child: const Padding(
        padding: EdgeInsets.all(18),
        child: Row(
          children: [
            SizedBox(
              width: 18,
              height: 18,
              child: CircularProgressIndicator(strokeWidth: 2),
            ),
            SizedBox(width: 12),
            Text('Loading terms...'),
          ],
        ),
      ),
    );
  }
}

class _ErrorCard extends StatelessWidget {
  const _ErrorCard({required this.message});

  final String message;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final outline = theme.colorScheme.outline.withAlpha(204);

    return Card(
      elevation: 0,
      surfaceTintColor: Colors.transparent,
      color: theme.colorScheme.surface,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(24),
        side: BorderSide(color: outline),
      ),
      child: Padding(
        padding: const EdgeInsets.all(18),
        child: Text(
          message,
          style: theme.textTheme.bodyMedium?.copyWith(
            color: theme.colorScheme.error,
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
    );
  }
}
