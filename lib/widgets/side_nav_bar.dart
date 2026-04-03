import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../routes/app_router.dart';

enum SideNavDestination {
  dashboard,
  mrManagement,
  asmManagement,
  teamManagement,
  visualAdsManagement,
  attendanceRecords,
  dcr,
  tripPlanManagement,
  orderManagement,
  monthlyTargets,
  distributorManagement,
  chemistShopManagement,
  salarySlipManagement,
  announcements,
  profile,
  aboutUs,
  helpCenter,
  termsconditions,
  privacyPolicy,
}

extension SideNavDestinationX on SideNavDestination {
  String get label {
    switch (this) {
      case SideNavDestination.dashboard:
        return 'Dashboard';
      case SideNavDestination.mrManagement:
        return 'MR Management';
      case SideNavDestination.asmManagement:
        return 'ASM Management';
      case SideNavDestination.teamManagement:
        return 'Team Management';
      case SideNavDestination.visualAdsManagement:
        return 'Visual Ads Management';
      case SideNavDestination.attendanceRecords:
        return 'Attendance Records';
      case SideNavDestination.dcr:
        return 'DCR Management';
      case SideNavDestination.tripPlanManagement:
        return 'Trip Plan Management';
      case SideNavDestination.orderManagement:
        return 'Order Management';
      case SideNavDestination.distributorManagement:
        return 'Distributor Management';
      case SideNavDestination.chemistShopManagement:
        return 'Chemist Shop Management';
      case SideNavDestination.salarySlipManagement:
        return 'Salary Slip Management';
      case SideNavDestination.announcements:
        return 'Announcement Management';
      case SideNavDestination.monthlyTargets:
        return 'Monthly Targets';
      case SideNavDestination.profile:
        return 'My Profile';
      case SideNavDestination.aboutUs:
        return 'About Us';
      case SideNavDestination.helpCenter:
        return 'Help Center';
      case SideNavDestination.termsconditions:
        return 'Terms & Conditions';
      case SideNavDestination.privacyPolicy:
        return 'Privacy Policy';
    }
  }

  IconData get icon {
    switch (this) {
      case SideNavDestination.dashboard:
        return Icons.dashboard_rounded;
      case SideNavDestination.mrManagement:
        return Icons.groups_rounded;
      case SideNavDestination.asmManagement:
        return Icons.manage_accounts_rounded;
      case SideNavDestination.teamManagement:
        return Icons.hub_rounded;
      case SideNavDestination.visualAdsManagement:
        return Icons.view_carousel_rounded;
      case SideNavDestination.attendanceRecords:
        return Icons.event_available_rounded;
      case SideNavDestination.dcr:
        return Icons.description_rounded;
      case SideNavDestination.tripPlanManagement:
        return Icons.map_rounded;
      case SideNavDestination.orderManagement:
        return Icons.shopping_bag_rounded;
      case SideNavDestination.distributorManagement:
        return Icons.inventory_2_rounded;
      case SideNavDestination.chemistShopManagement:
        return Icons.store_rounded;
      case SideNavDestination.salarySlipManagement:
        return Icons.receipt_long_rounded;
      case SideNavDestination.announcements:
        return Icons.notifications_active_rounded;
      case SideNavDestination.profile:
        return Icons.person_rounded;
      case SideNavDestination.monthlyTargets:
        return Icons.calendar_today_rounded;
      case SideNavDestination.aboutUs:
        return Icons.info_rounded;
      case SideNavDestination.helpCenter:
        return Icons.support_agent_rounded;
      case SideNavDestination.termsconditions:
        return Icons.article_rounded;
      case SideNavDestination.privacyPolicy:
        return Icons.privacy_tip_rounded;
    }
  }
}

class SideNavBarDrawer extends StatelessWidget {
  const SideNavBarDrawer({
    super.key,
    this.companyName = 'Your Company',
    this.tagline = 'Manage MR, teams, and field ops',
    this.logoAssetPath = 'assets/logo/naiyo24_logo.png',
    this.selected,
    this.onSelected,
    this.selectedIndex,
    this.currentIndex,
    this.onSelectedIndex,
    this.enableInternalRouting = true,
    this.width,
  });

  final String companyName;
  final String tagline;
  final String? logoAssetPath;

  final SideNavDestination? selected;
  final ValueChanged<SideNavDestination>? onSelected;

  final int? selectedIndex;
  final int? currentIndex;
  final ValueChanged<int>? onSelectedIndex;

  final bool enableInternalRouting;

  final double? width;

  static const destinations = <SideNavDestination>[
    SideNavDestination.dashboard,
    SideNavDestination.mrManagement,
    SideNavDestination.asmManagement,
    SideNavDestination.teamManagement,
    SideNavDestination.visualAdsManagement,
    SideNavDestination.attendanceRecords,
    SideNavDestination.dcr,
    SideNavDestination.tripPlanManagement,
    SideNavDestination.orderManagement,
    SideNavDestination.distributorManagement,
    SideNavDestination.chemistShopManagement,
    SideNavDestination.salarySlipManagement,
    SideNavDestination.announcements,
    SideNavDestination.profile,
    SideNavDestination.aboutUs,
    SideNavDestination.helpCenter,
    SideNavDestination.termsconditions,
  ];

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final computedIndex = selected == null
        ? null
        : destinations.indexWhere((d) => d == selected);
    final resolvedSelectedIndex =
        (selectedIndex ?? currentIndex) ??
        ((computedIndex == null || computedIndex < 0) ? null : computedIndex);

    final isDark = theme.brightness == Brightness.dark;
    final selectedTextColor = isDark
        ? theme.colorScheme.onSurface
        : theme.colorScheme.surface;
    final unselectedTextColor = theme.colorScheme.onSurface.withAlpha(191);
    final unselectedIconColor = theme.colorScheme.onSurface.withAlpha(204);

    final navTheme = NavigationDrawerThemeData(
      backgroundColor: theme.colorScheme.surface,
      elevation: 0,
      surfaceTintColor: Colors.transparent,
      tileHeight: 52,
      indicatorShape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(18),
      ),
      indicatorColor: isDark
          ? theme.colorScheme.surfaceContainerHighest
          : theme.colorScheme.onSurface,
      iconTheme: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.selected)) {
          return IconThemeData(color: theme.colorScheme.primary, size: 22);
        }
        return IconThemeData(color: unselectedIconColor, size: 22);
      }),
      labelTextStyle: WidgetStateProperty.resolveWith((states) {
        final base = theme.textTheme.bodyMedium?.copyWith(
          fontWeight: FontWeight.w800,
          letterSpacing: 0.1,
        );
        if (states.contains(WidgetState.selected)) {
          return base?.copyWith(color: selectedTextColor);
        }
        return base?.copyWith(color: unselectedTextColor);
      }),
    );

    return Drawer(
      width: width,
      child: SafeArea(
        child: NavigationDrawerTheme(
          data: navTheme,
          child: NavigationDrawer(
            selectedIndex: resolvedSelectedIndex,
            onDestinationSelected: (index) {
              final destination = destinations[index];
              final router = GoRouter.of(context);
              Navigator.of(context).maybePop();
              onSelectedIndex?.call(index);
              onSelected?.call(destination);
              if (enableInternalRouting) {
                final routeName = _routeNameForDestination(destination);
                if (routeName != null) {
                  router.goNamed(routeName);
                }
              }
            },
            children: [
              _SideNavHeader(
                companyName: companyName,
                tagline: tagline,
                logoAssetPath: logoAssetPath,
              ),
              const SizedBox(height: 6),
              for (final d in destinations)
                NavigationDrawerDestination(
                  icon: Icon(d.icon),
                  selectedIcon: Icon(d.icon),
                  label: Text(d.label),
                ),
              const SizedBox(height: 102),
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 6, 16, 18),
                child: Center(
                  child: Text(
                    'Powered by Naiyo24',
                    textAlign: TextAlign.center,
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: theme.colorScheme.onSurface.withAlpha(166),
                      fontWeight: FontWeight.w800,
                      letterSpacing: 0.25,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  String? _routeNameForDestination(SideNavDestination destination) {
    switch (destination) {
      case SideNavDestination.dashboard:
        return AppRoutes.dashboard;
      case SideNavDestination.mrManagement:
        return AppRoutes.mrManagement;
      case SideNavDestination.asmManagement:
        return AppRoutes.asmManagement;
      case SideNavDestination.teamManagement:
        return AppRoutes.teamManagement;
      case SideNavDestination.visualAdsManagement:
        return AppRoutes.visualAdsManagement;
      case SideNavDestination.attendanceRecords:
        return AppRoutes.attendanceManagement;
      case SideNavDestination.announcements:
        return AppRoutes.announcementManagement;
      case SideNavDestination.profile:
        return AppRoutes.profile;
      case SideNavDestination.aboutUs:
        return AppRoutes.aboutUs;
      case SideNavDestination.monthlyTargets:
        return null;
      case SideNavDestination.termsconditions:
        return AppRoutes.termsConditions;
      case SideNavDestination.dcr:
      case SideNavDestination.tripPlanManagement:
      case SideNavDestination.orderManagement:
      case SideNavDestination.distributorManagement:
      case SideNavDestination.helpCenter:
      case SideNavDestination.privacyPolicy:
        return null;
      case SideNavDestination.salarySlipManagement:
        return AppRoutes.salarySlipManagement;
      case SideNavDestination.chemistShopManagement:
        return AppRoutes.chemistShopManagement;
    }
  }
}

class _SideNavHeader extends StatelessWidget {
  const _SideNavHeader({
    required this.companyName,
    required this.tagline,
    required this.logoAssetPath,
  });

  final String companyName;
  final String tagline;
  final String? logoAssetPath;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final outline = theme.colorScheme.outline.withAlpha(76);
    final brand = theme.colorScheme.primary;

    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 10),
      child: Container(
        padding: const EdgeInsets.all(4),
        decoration: BoxDecoration(
          color: theme.colorScheme.surfaceContainerHighest,
          borderRadius: BorderRadius.circular(18),
          border: Border.all(color: outline),
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(18),
          child: Stack(
            children: [
              Positioned.fill(
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [
                        brand.withAlpha(isDark ? 22 : 28),
                        theme.colorScheme.surfaceContainerHighest,
                      ],
                    ),
                  ),
                ),
              ),
              Positioned(
                left: 0,
                top: 0,
                bottom: 0,
                child: Container(
                  width: 4,
                  color: brand.withAlpha(isDark ? 191 : 230),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(24),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    _HeaderLogo(logoAssetPath: logoAssetPath),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            companyName,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: theme.textTheme.titleMedium?.copyWith(
                              fontWeight: FontWeight.w900,
                              letterSpacing: -0.2,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            tagline,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: theme.textTheme.bodySmall?.copyWith(
                              color: theme.colorScheme.onSurface.withAlpha(166),
                              fontWeight: FontWeight.w800,
                              letterSpacing: 0.15,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _HeaderLogo extends StatelessWidget {
  const _HeaderLogo({required this.logoAssetPath});

  final String? logoAssetPath;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final outline = theme.colorScheme.outline.withAlpha(102);

    Widget child;
    if (logoAssetPath != null && logoAssetPath!.trim().isNotEmpty) {
      child = Image.asset(
        logoAssetPath!,
        width: 40,
        height: 40,
        fit: BoxFit.contain,
        errorBuilder: (context, error, stackTrace) {
          return Icon(
            Icons.local_pharmacy_rounded,
            size: 22,
            color: theme.colorScheme.primary,
          );
        },
      );
    } else {
      child = Icon(
        Icons.local_pharmacy_rounded,
        size: 22,
        color: theme.colorScheme.primary,
      );
    }

    return Container(
      width: 44,
      height: 44,
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: outline),
      ),
      child: Center(child: child),
    );
  }
}
