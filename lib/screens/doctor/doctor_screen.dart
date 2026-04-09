import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../cards/doctor/doctor_card.dart';
import '../../cards/doctor/doctor_search_filter_bar.dart';
import '../../models/doctor.dart';
import '../../notifiers/asm_management_notifier.dart';
import '../../notifiers/doctor_notifier.dart';
import '../../notifiers/mr_management_notifier.dart';
import '../../routes/app_router.dart';
import '../../theme/app_theme.dart';
import '../../widgets/app_bar.dart';
import '../../widgets/side_nav_bar.dart';

class DoctorScreen extends ConsumerStatefulWidget {
  const DoctorScreen({super.key});

  @override
  ConsumerState<DoctorScreen> createState() => _DoctorScreenState();
}

class _DoctorScreenState extends ConsumerState<DoctorScreen> {
  String _query = '';
  String? _selectedMrId;
  String? _selectedAsmId;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final padding = AppLayout.pagePadding(context);
    final listAsync = ref.watch(doctorNotifierProvider);
    final mrAsync = ref.watch(mrManagementNotifierProvider);
    final asmAsync = ref.watch(asmManagementNotifierProvider);

    final mrOptions = mrAsync.maybeWhen(
      data: (items) =>
          items.map((m) => (id: m.id, label: m.name)).toList(growable: false),
      orElse: () => const <({String id, String label})>[],
    );
    final asmOptions = asmAsync.maybeWhen(
      data: (items) =>
          items.map((a) => (id: a.id, label: a.name)).toList(growable: false),
      orElse: () => const <({String id, String label})>[],
    );

    return Scaffold(
      appBar: const AppAppBar(
        showLogo: false,
        showBackIfPossible: false,
        title: 'Doctor Management',
        subtitle: 'Search and view doctor list',
        showMenuIfNoBack: true,
      ),
      drawer: SideNavBarDrawer(
        companyName: 'Naiyo24',
        tagline: 'Admin console',
        selectedIndex: SideNavBarDrawer.destinations.indexOf(
          SideNavDestination.doctorManagement,
        ),
      ),
      bottomNavigationBar: SafeArea(
        minimum: EdgeInsets.fromLTRB(
          padding.left,
          0,
          padding.right,
          padding.bottom,
        ),
        child: Padding(
          padding: const EdgeInsets.only(top: 10),
          child: Align(
            alignment: Alignment.center,
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 1120),
              child: FilledButton.icon(
                onPressed: () => context.goNamed(AppRoutes.createDoctor),
                icon: const Icon(Icons.add_rounded),
                label: const Text('Add a new doctor'),
              ),
            ),
          ),
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: padding,
          child: Align(
            alignment: Alignment.topCenter,
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 1120),
              child: listAsync.when(
                data: (items) {
                  final q = _query.trim().toLowerCase();
                  final filtered = items
                      .where((d) {
                        final matchesQuery = q.isEmpty
                            ? true
                            : d.name.toLowerCase().contains(q) ||
                                  d.specialization.toLowerCase().contains(q);

                        final matchesMr = _selectedMrId == null
                            ? true
                            : (d.addedByType == DoctorAddedByType.mr &&
                                  d.addedById == _selectedMrId);
                        final matchesAsm = _selectedAsmId == null
                            ? true
                            : (d.addedByType == DoctorAddedByType.asm &&
                                  d.addedById == _selectedAsmId);
                        return matchesQuery && matchesMr && matchesAsm;
                      })
                      .toList(growable: false);

                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      DoctorSearchFilterBar(
                        onQueryChanged: (v) => setState(() => _query = v),
                        mrOptions: mrOptions,
                        asmOptions: asmOptions,
                        selectedMrId: _selectedMrId,
                        selectedAsmId: _selectedAsmId,
                        onMrChanged: (v) => setState(() {
                          _selectedMrId = v;
                          if (v != null) _selectedAsmId = null;
                        }),
                        onAsmChanged: (v) => setState(() {
                          _selectedAsmId = v;
                          if (v != null) _selectedMrId = null;
                        }),
                      ),
                      const SizedBox(height: 14),
                      Expanded(
                        child: (items.isEmpty)
                            ? _EmptyCard(theme: theme)
                            : (filtered.isEmpty)
                            ? _EmptyCard(
                                theme: theme,
                                message:
                                    'No doctors found. Try a different search or filter.',
                              )
                            : ListView.separated(
                                itemCount: filtered.length,
                                separatorBuilder: (_, _) =>
                                    const SizedBox(height: 12),
                                itemBuilder: (context, index) {
                                  final d = filtered[index];
                                  return DoctorCard(
                                    photoPath: d.photoPath,
                                    photoBytes: d.photoBytes,
                                    doctorName: d.name,
                                    specialization: d.specialization,
                                    onTap: () => context.goNamed(
                                      AppRoutes.doctorDetails,
                                      pathParameters: {'doctorId': d.id},
                                    ),
                                  );
                                },
                              ),
                      ),
                    ],
                  );
                },
                loading: () => _LoadingCard(theme: theme),
                error: (e, _) =>
                    const _ErrorCard(message: 'Failed to load doctor list.'),
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
          message ?? 'No doctors found.',
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
            Text('Loading doctors...'),
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
