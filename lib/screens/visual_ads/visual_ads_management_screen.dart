import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../cards/visual_ads/visual_ads_card.dart';
import '../../cards/visual_ads/visual_ads_search_bar.dart';
import '../../notifiers/visual_ads_notifier.dart';
import '../../routes/app_router.dart';
import '../../theme/app_theme.dart';
import '../../widgets/app_bar.dart';
import '../../widgets/side_nav_bar.dart';

class VisualAdsManagementScreen extends ConsumerStatefulWidget {
  const VisualAdsManagementScreen({super.key});

  @override
  ConsumerState<VisualAdsManagementScreen> createState() =>
      _VisualAdsManagementScreenState();
}

class _VisualAdsManagementScreenState
    extends ConsumerState<VisualAdsManagementScreen> {
  String _query = '';

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final padding = AppLayout.pagePadding(context);
    final adsAsync = ref.watch(visualAdsNotifierProvider);

    return Scaffold(
      appBar: const AppAppBar(
        showLogo: false,
        showBackIfPossible: false,
        title: 'Visual Ads',
        subtitle: 'Create, edit, and manage visual ads',
      ),
      drawer: SideNavBarDrawer(
        companyName: 'Naiyo24',
        tagline: 'Admin console',
        selectedIndex: SideNavBarDrawer.destinations.indexOf(
          SideNavDestination.visualAdsManagement,
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
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => context.goNamed(AppRoutes.createVisualAd),
        icon: const Icon(Icons.add_photo_alternate_rounded),
        label: const Text('Create Visual Ad'),
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
                  VisualAdsSearchBar(
                    hintText: 'Search visual ads by name',
                    onChanged: (v) => setState(() => _query = v),
                  ),
                  const SizedBox(height: 14),
                  adsAsync.when(
                    data: (items) {
                      final q = _query.trim().toLowerCase();
                      final filtered = (q.isEmpty)
                          ? items
                          : items
                                .where((a) => a.name.toLowerCase().contains(q))
                                .toList();

                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          for (final ad in filtered) ...[
                            VisualAdsCard(
                              imageBytes: ad.imageBytes,
                              name: ad.name,
                              onTap: () => context.goNamed(
                                AppRoutes.visualAdPreview,
                                pathParameters: {'adId': ad.id},
                              ),
                              onEdit: () => context.goNamed(
                                AppRoutes.editVisualAd,
                                pathParameters: {'adId': ad.id},
                              ),
                              onDelete: () => ref
                                  .read(visualAdsNotifierProvider.notifier)
                                  .delete(ad.id),
                            ),
                            const SizedBox(height: 12),
                          ],
                        ],
                      );
                    },
                    loading: () => _LoadingCard(theme: theme),
                    error: (e, _) =>
                        const _ErrorCard(message: 'Failed to load visual ads.'),
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
            Text('Loading visual ads...'),
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
