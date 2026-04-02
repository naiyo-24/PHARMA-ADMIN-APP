import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../cards/asm_management/asm_card.dart';
import '../../cards/asm_management/asm_search_bar.dart';
import '../../notifiers/asm_management_notifier.dart';
import '../../routes/app_router.dart';
import '../../theme/app_theme.dart';
import '../../widgets/app_bar.dart';
import '../../widgets/side_nav_bar.dart';

class AsmManagementScreen extends ConsumerStatefulWidget {
  const AsmManagementScreen({super.key});

  @override
  ConsumerState<AsmManagementScreen> createState() =>
      _AsmManagementScreenState();
}

class _AsmManagementScreenState extends ConsumerState<AsmManagementScreen> {
  String _query = '';

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final padding = AppLayout.pagePadding(context);
    final listAsync = ref.watch(asmManagementNotifierProvider);

    return Scaffold(
      appBar: const AppAppBar(
        showLogo: false,
        showBackIfPossible: false,
        title: 'ASM Management',
        subtitle: 'Onboard, edit, and manage ASMs',
      ),
      drawer: SideNavBarDrawer(
        companyName: 'Naiyo24',
        tagline: 'Admin console',
        selectedIndex: SideNavBarDrawer.destinations.indexOf(
          SideNavDestination.asmManagement,
        ),
        onSelectedIndex: (index) => context.goNamed(AppRoutes.asmManagement),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => context.goNamed(AppRoutes.onboardAsm),
        icon: const Icon(Icons.person_add_alt_1_rounded),
        label: const Text('Onboard ASM'),
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
                  AsmSearchBar(
                    hintText: 'Search ASM by name, phone, or headquarter',
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
                          for (final asm in filtered) ...[
                            AsmCard(
                              photoBytes: asm.photoBytes,
                              name: asm.name,
                              phoneNumber: asm.phoneNumber,
                              headquarter: asm.headquarter,
                              onTap: () => context.goNamed(
                                AppRoutes.asmDetails,
                                pathParameters: {'asmId': asm.id},
                              ),
                              onEdit: () => context.goNamed(
                                AppRoutes.editAsm,
                                pathParameters: {'asmId': asm.id},
                              ),
                              onDelete: () => ref
                                  .read(asmManagementNotifierProvider.notifier)
                                  .delete(asm.id),
                            ),
                            const SizedBox(height: 12),
                          ],
                        ],
                      );
                    },
                    loading: () => _LoadingCard(theme: theme),
                    error: (e, _) =>
                        const _ErrorCard(message: 'Failed to load ASM list.'),
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
            Text('Loading ASMs...'),
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
