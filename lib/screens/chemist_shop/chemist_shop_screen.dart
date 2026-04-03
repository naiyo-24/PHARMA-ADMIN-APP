import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../cards/chemist_shop/chemist_shop_card.dart';
import '../../cards/chemist_shop/chemist_shop_search_bar.dart';
import '../../notifiers/chemist_shop_notifier.dart';
import '../../routes/app_router.dart';
import '../../theme/app_theme.dart';
import '../../widgets/app_bar.dart';
import '../../widgets/side_nav_bar.dart';

class ChemistShopScreen extends ConsumerStatefulWidget {
  const ChemistShopScreen({super.key});

  @override
  ConsumerState<ChemistShopScreen> createState() => _ChemistShopScreenState();
}

class _ChemistShopScreenState extends ConsumerState<ChemistShopScreen> {
  String _query = '';

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final padding = AppLayout.pagePadding(context);
    final listAsync = ref.watch(chemistShopNotifierProvider);

    return Scaffold(
      appBar: const AppAppBar(
        showLogo: false,
        showBackIfPossible: false,
        title: 'Chemist Shop Management',
        subtitle: 'View chemist shops and details',
        showMenuIfNoBack: true,
      ),
      drawer: SideNavBarDrawer(
        companyName: 'Naiyo24',
        tagline: 'Admin console',
        selectedIndex: SideNavBarDrawer.destinations.indexOf(
          SideNavDestination.chemistShopManagement,
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: padding,
          child: Align(
            alignment: Alignment.topCenter,
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 1120),
              child: listAsync.when(
                data: (items) {
                  final q = _query.trim().toLowerCase();
                  final filtered = q.isEmpty
                      ? items
                      : items
                            .where((s) {
                              return s.name.toLowerCase().contains(q) ||
                                  s.address.toLowerCase().contains(q);
                            })
                            .toList(growable: false);

                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      ChemistShopSearchBar(
                        hintText: 'Search chemist shops by name or address',
                        onChanged: (v) => setState(() => _query = v),
                      ),
                      const SizedBox(height: 14),
                      if (items.isEmpty)
                        _EmptyCard(theme: theme)
                      else if (filtered.isEmpty)
                        _EmptyCard(
                          theme: theme,
                          message:
                              'No chemist shops found. Try a different search.',
                        )
                      else
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            for (final s in filtered) ...[
                              ChemistShopCard(
                                photoPath: s.photoPath,
                                shopName: s.name,
                                shopAddress: s.address,
                                onTap: () => context.goNamed(
                                  AppRoutes.chemistShopDetails,
                                  pathParameters: {'shopId': s.id},
                                ),
                              ),
                              const SizedBox(height: 12),
                            ],
                          ],
                        ),
                      const SizedBox(height: 92),
                    ],
                  );
                },
                loading: () => _LoadingCard(theme: theme),
                error: (e, _) => const _ErrorCard(
                  message: 'Failed to load chemist shop list.',
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _EmptyCard extends StatelessWidget {
  const _EmptyCard({required this.theme, this.message});

  final ThemeData theme;
  final String? message;

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
      child: Padding(
        padding: const EdgeInsets.all(18),
        child: Text(
          message ?? 'No chemist shops found.',
          style: theme.textTheme.bodyMedium?.copyWith(
            fontWeight: FontWeight.w800,
            color: theme.colorScheme.onSurface.withAlpha(180),
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
            Text('Loading chemist shops...'),
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
            fontWeight: FontWeight.w800,
          ),
        ),
      ),
    );
  }
}
