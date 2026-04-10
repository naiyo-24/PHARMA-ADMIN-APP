
import 'package:flutter/material.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../cards/dcr/dcr_card.dart';
import '../../cards/dcr/dcr_details_bottomsheet.dart';
import '../../cards/dcr/dcr_search_filter_bar.dart';
import '../../models/dcr.dart';
import '../../notifiers/dcr_notifier.dart';
import '../../theme/app_theme.dart';
import '../../widgets/app_bar.dart';
import '../../widgets/side_nav_bar.dart';

class DcrScreen extends ConsumerStatefulWidget {
	const DcrScreen({super.key});

	@override
	ConsumerState<DcrScreen> createState() => _DcrScreenState();
}

class _DcrScreenState extends ConsumerState<DcrScreen> {
	String _query = '';
	DcrCreatedByType? _createdByType;
	DateTime? _selectedDay;

	@override
	Widget build(BuildContext context) {
		final theme = Theme.of(context);
		final padding = AppLayout.pagePadding(context);
		final listAsync = ref.watch(dcrNotifierProvider);

		return Scaffold(
			appBar: const AppAppBar(
				showLogo: false,
				showBackIfPossible: false,
				title: 'DCR Management',
				subtitle: 'Search and view doctor call reports',
				showMenuIfNoBack: true,
			),
			drawer: SideNavBarDrawer(
				companyName: 'Naiyo24',
				tagline: 'Admin console',
				selectedIndex: SideNavBarDrawer.destinations.indexOf(
					SideNavDestination.dcr,
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
									final filtered = items.where((d) {
										final matchesType = _createdByType == null
												? true
												: d.createdByType == _createdByType;
										final matchesQuery = q.isEmpty
												? true
												: d.id.toLowerCase().contains(q) ||
													d.createdByName.toLowerCase().contains(q) ||
													d.doctorName.toLowerCase().contains(q);
										final matchesDay = _selectedDay == null
												? true
												: _isSameDay(d.date, _selectedDay!);
										return matchesType && matchesQuery && matchesDay;
									}).toList(growable: false);

									return Column(
										crossAxisAlignment: CrossAxisAlignment.stretch,
										children: [
											DcrSearchFilterBar(
												onQueryChanged: (v) => setState(() => _query = v),
												selectedCreatedByType: _createdByType,
												onCreatedByTypeChanged: (v) => setState(() => _createdByType = v),
												selectedDay: _selectedDay,
												onDayChanged: (v) => setState(() => _selectedDay = v),
											),
											const SizedBox(height: 14),
											if (items.isEmpty)
												_EmptyCard(theme: theme)
											else if (filtered.isEmpty)
												_EmptyCard(
													theme: theme,
													message: 'No DCR reports found. Try a different search or filter.',
												)
											else
												Column(
													crossAxisAlignment: CrossAxisAlignment.stretch,
													children: [
														for (final d in filtered) ...[
															DcrCard(
																dcr: d,
																onTap: () => _openDetails(d),
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
									message: 'Failed to load DCR reports.',
								),
							),
						),
					),
				),
			),
		);
	}

	Future<void> _openDetails(Dcr dcr) async {
		await showModalBottomSheet<void>(
			context: context,
			showDragHandle: true,
			isScrollControlled: true,
			builder: (context) => SingleChildScrollView(
				child: DcrDetailsBottomSheet(dcr: dcr),
			),
		);
	}

	bool _isSameDay(DateTime a, DateTime b) {
		return a.year == b.year && a.month == b.month && a.day == b.day;
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
					message ?? 'No DCR reports found.',
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
						Text('Loading DCR reports...'),
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
						fontWeight: FontWeight.w800,
						color: theme.colorScheme.error,
					),
				),
			),
		);
	}
}
