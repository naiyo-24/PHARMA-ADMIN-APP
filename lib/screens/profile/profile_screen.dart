import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../cards/profile/profile_header_card.dart';
import '../../cards/profile/profile_option_card.dart';
import '../../notifiers/auth_notifier.dart';
import '../../notifiers/profile_notifier.dart';
import '../../routes/app_router.dart';
import '../../theme/app_theme.dart';
import '../../widgets/app_bar.dart';
import '../../widgets/side_nav_bar.dart';

class ProfileScreen extends ConsumerWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final padding = AppLayout.pagePadding(context);
    final userAsync = ref.watch(profileNotifierProvider);

    return Scaffold(
      appBar: const AppAppBar(
        showLogo: false,
        showBackIfPossible: false,
        title: 'My Profile',
        subtitle: 'Company & account',
      ),
      drawer: SideNavBarDrawer(
        companyName: 'Naiyo24',
        tagline: 'Admin console',
        selectedIndex: SideNavBarDrawer.destinations.indexOf(
          SideNavDestination.profile,
        ),
        onSelectedIndex: (index) {
          final dashboardIndex = SideNavBarDrawer.destinations.indexOf(
            SideNavDestination.dashboard,
          );
          final mrIndex = SideNavBarDrawer.destinations.indexOf(
            SideNavDestination.mrManagement,
          );
          final asmIndex = SideNavBarDrawer.destinations.indexOf(
            SideNavDestination.asmManagement,
          );
          final visualAdsIndex = SideNavBarDrawer.destinations.indexOf(
            SideNavDestination.visualAdsManagement,
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
          if (index == asmIndex) context.goNamed(AppRoutes.asmManagement);
          if (index == visualAdsIndex) {
            context.goNamed(AppRoutes.visualAdsManagement);
          }
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
              child: userAsync.when(
                data: (user) {
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      ProfileHeaderCard(
                        companyName: user.companyName,
                        cinNumber: user.cinNumber,
                        onEdit: null,
                      ),
                      const SizedBox(height: 14),
                      ProfileOptionCard(
                        title: 'My subscription',
                        icon: Icons.workspace_premium_rounded,
                        onTap: null,
                      ),
                      const SizedBox(height: 12),
                      ProfileOptionCard(
                        title: 'Update profile',
                        icon: Icons.manage_accounts_rounded,
                        onTap: null,
                      ),
                      const SizedBox(height: 12),
                      ProfileOptionCard(
                        title: 'Notifications',
                        icon: Icons.notifications,
                        onTap: null,
                      ),
                      const SizedBox(height: 12),
                      ProfileOptionCard(
                        title: 'Report an issue',
                        icon: Icons.bug_report_rounded,
                        onTap: null,
                      ),
                      const SizedBox(height: 12),
                      ProfileOptionCard(
                        title: 'Log out',
                        icon: Icons.logout_rounded,
                        onTap: () {
                          ref.read(authNotifierProvider.notifier).signOut();
                          context.goNamed(AppRoutes.login);
                        },
                      ),
                      const SizedBox(height: 12),
                      ProfileOptionCard(
                        title: 'Delete account',
                        icon: Icons.delete_forever_rounded,
                        destructive: true,
                        onTap: null,
                      ),
                    ],
                  );
                },
                loading: () => _LoadingCard(theme: theme),
                error: (e, _) =>
                    const _ErrorCard(message: 'Failed to load profile.'),
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
            Text('Loading profile...'),
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
