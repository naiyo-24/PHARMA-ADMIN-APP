import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../cards/mr_management/mr_card.dart';
import '../../cards/mr_management/mr_search_bar.dart';
import '../../notifiers/mr_management_notifier.dart';
import '../../routes/app_router.dart';
import '../../theme/app_theme.dart';
import '../../widgets/app_bar.dart';
import '../../widgets/side_nav_bar.dart';

class MrManagementScreen extends ConsumerStatefulWidget {
  const MrManagementScreen({super.key});

  @override
  ConsumerState<MrManagementScreen> createState() => _MrManagementScreenState();
}

class _MrManagementScreenState extends ConsumerState<MrManagementScreen> {
  String _query = '';

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final padding = AppLayout.pagePadding(context);
    final listAsync = ref.watch(mrManagementNotifierProvider);

    return Scaffold(
      appBar: const AppAppBar(
        showLogo: false,
        showBackIfPossible: false,
        title: 'MR Management',
        subtitle: 'Onboard, edit, and manage MRs',
      ),
      drawer: SideNavBarDrawer(
        companyName: 'Naiyo24',
        tagline: 'Admin console',
        selectedIndex: SideNavBarDrawer.destinations.indexOf(
          SideNavDestination.mrManagement,
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
        onPressed: () => context.goNamed(AppRoutes.onboardMr),
        icon: const Icon(Icons.person_add_alt_1_rounded),
        label: const Text('Onboard MR'),
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
                  MrSearchBar(
                    hintText: 'Search MR by name, phone, or headquarter',
                    onChanged: (v) => setState(() => _query = v),
                  ),
                  const SizedBox(height: 14),
                  listAsync.when(
                    data: (items) {
                      final q = _query.trim().toLowerCase();
                      final filtered = (q.isEmpty)
                          ? items
                          : items.where((m) {
                              return m.name.toLowerCase().contains(q) ||
                                  m.phoneNumber.toLowerCase().contains(q) ||
                                  m.headquarter.toLowerCase().contains(q);
                            }).toList();

                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          for (final mr in filtered) ...[
                            MrCard(
                              photoBytes: mr.photoBytes,
                              name: mr.name,
                              phoneNumber: mr.phoneNumber,
                              headquarter: mr.headquarter,
                              onTap: () => context.goNamed(
                                AppRoutes.mrDetails,
                                pathParameters: {'mrId': mr.id},
                              ),
                              onEdit: () => context.goNamed(
                                AppRoutes.editMr,
                                pathParameters: {'mrId': mr.id},
                              ),
                              onDelete: () => ref
                                  .read(mrManagementNotifierProvider.notifier)
                                  .delete(mr.id),
                            ),
                            const SizedBox(height: 12),
                          ],
                        ],
                      );
                    },
                    loading: () => _LoadingCard(theme: theme),
                    error: (e, _) =>
                        const _ErrorCard(message: 'Failed to load MR list.'),
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
            Text('Loading MRs...'),
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
