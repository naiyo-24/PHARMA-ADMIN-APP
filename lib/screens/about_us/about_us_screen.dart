import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../cards/about_us/about_us_contact_card.dart';
import '../../cards/about_us/about_us_description_card.dart';
import '../../cards/about_us/about_us_director_card.dart';
import '../../cards/about_us/about_us_header_card.dart';
import '../../notifiers/about_us_notifier.dart';
import '../../routes/app_router.dart';
import '../../theme/app_theme.dart';
import '../../widgets/app_bar.dart';
import '../../widgets/side_nav_bar.dart';

class AboutUsScreen extends ConsumerWidget {
  const AboutUsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final padding = AppLayout.pagePadding(context);
    final aboutAsync = ref.watch(aboutUsNotifierProvider);

    return Scaffold(
      appBar: const AppAppBar(
        showLogo: false,
        showBackIfPossible: false,
        title: 'About Us',
        subtitle: 'Company & software',
      ),
      drawer: SideNavBarDrawer(
        companyName: 'Naiyo24',
        tagline: 'Admin console',
        selectedIndex: SideNavBarDrawer.destinations.indexOf(
          SideNavDestination.aboutUs,
        ),
        onSelectedIndex: (index) {
          final dashboardIndex = SideNavBarDrawer.destinations.indexOf(
            SideNavDestination.dashboard,
          );
          final aboutIndex = SideNavBarDrawer.destinations.indexOf(
            SideNavDestination.aboutUs,
          );
          final termsIndex = SideNavBarDrawer.destinations.indexOf(
            SideNavDestination.termsconditions,
          );

          if (index == dashboardIndex) context.goNamed(AppRoutes.dashboard);
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
              child: aboutAsync.when(
                data: (about) {
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      AboutUsHeaderCard(
                        logoAssetPath: about.logoAssetPath,
                        companyName: about.companyName,
                        tagline: about.tagline,
                      ),
                      const SizedBox(height: 14),
                      AboutUsDescriptionCard(
                        briefDescription: about.briefDescription,
                        detailedDescription: about.detailedDescription,
                      ),
                      const SizedBox(height: 14),
                      AboutUsDirectorCard(
                        directorImageAssetPath: about.directorImageAssetPath,
                        directorName: about.directorName,
                        directorMessage: about.directorMessage,
                      ),
                      const SizedBox(height: 14),
                      AboutUsContactCard(
                        address: about.address,
                        phoneNumber: about.phoneNumber,
                        email: about.email,
                        website: about.website,
                      ),
                    ],
                  );
                },
                loading: () => _LoadingCard(theme: theme),
                error: (e, _) => const _ErrorCard(
                  message: 'Failed to load About Us details.',
                ),
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
            Text('Loading About Us...'),
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
