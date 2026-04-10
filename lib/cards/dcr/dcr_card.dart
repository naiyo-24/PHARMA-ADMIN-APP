
import 'package:flutter/material.dart';

import '../../models/dcr.dart';

class DcrCard extends StatelessWidget {
	const DcrCard({
		super.key,
		required this.dcr,
		required this.onTap,
	});

	final Dcr dcr;
	final VoidCallback onTap;

	@override
	Widget build(BuildContext context) {
		final theme = Theme.of(context);
		final outline = theme.colorScheme.outline.withAlpha(102);
		final dateLabel = MaterialLocalizations.of(context).formatMediumDate(dcr.date);

		return Card(
			elevation: 0,
			surfaceTintColor: Colors.transparent,
			color: theme.colorScheme.surface,
			shape: RoundedRectangleBorder(
				borderRadius: BorderRadius.circular(24),
				side: BorderSide(color: outline),
			),
			child: InkWell(
				borderRadius: BorderRadius.circular(24),
				onTap: onTap,
				child: Padding(
					padding: const EdgeInsets.all(14),
					child: Row(
						children: [
							Container(
								width: 44,
								height: 44,
								decoration: BoxDecoration(
									borderRadius: BorderRadius.circular(16),
									color: theme.colorScheme.primary.withAlpha(10),
									border: Border.all(color: outline),
								),
								child: Icon(
									Icons.description_rounded,
									color: theme.colorScheme.primary,
									size: 22,
								),
							),
							const SizedBox(width: 12),
							Expanded(
								child: Column(
									crossAxisAlignment: CrossAxisAlignment.start,
									children: [
										Row(
											children: [
												Expanded(
													child: Text(
														'${dcr.createdByType.label}: ${dcr.createdByName}',
														maxLines: 1,
														overflow: TextOverflow.ellipsis,
														style: theme.textTheme.titleMedium?.copyWith(
															fontWeight: FontWeight.w900,
															letterSpacing: -0.2,
														),
													),
												),
												const SizedBox(width: 10),
												_StatusChip(status: dcr.status),
											],
										),
										const SizedBox(height: 4),
										Text(
											dcr.doctorName,
											maxLines: 1,
											overflow: TextOverflow.ellipsis,
											style: theme.textTheme.bodyMedium?.copyWith(
												color: theme.colorScheme.onSurface.withAlpha(180),
												fontWeight: FontWeight.w800,
												height: 1.15,
											),
										),
										const SizedBox(height: 6),
										Wrap(
											spacing: 10,
											runSpacing: 6,
											children: [
												_TextPill(label: 'ID: ${dcr.id}'),
												_TextPill(label: dateLabel),
											],
										),
									],
								),
							),
							const SizedBox(width: 10),
							Icon(
								Icons.keyboard_arrow_up_rounded,
								size: 18,
								color: theme.colorScheme.onSurface.withAlpha(166),
							),
						],
					),
				),
			),
		);
	}
}

class _StatusChip extends StatelessWidget {
	const _StatusChip({required this.status});

	final DcrStatus status;

	@override
	Widget build(BuildContext context) {
		final theme = Theme.of(context);

		final (bg, fg) = switch (status) {
			DcrStatus.approved => (
				theme.colorScheme.tertiary.withAlpha(18),
				theme.colorScheme.tertiary,
			),
			DcrStatus.rejected => (
				theme.colorScheme.error.withAlpha(18),
				theme.colorScheme.error,
			),
			DcrStatus.submitted => (
				theme.colorScheme.primary.withAlpha(18),
				theme.colorScheme.primary,
			),
			DcrStatus.draft => (
				theme.colorScheme.outline.withAlpha(18),
				theme.colorScheme.onSurface.withAlpha(166),
			),
		};

		return Container(
			padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
			decoration: BoxDecoration(
				color: bg,
				borderRadius: BorderRadius.circular(999),
				border: Border.all(color: fg.withAlpha(76)),
			),
			child: Text(
				status.label,
				style: theme.textTheme.bodySmall?.copyWith(
					fontWeight: FontWeight.w900,
					letterSpacing: 0.15,
					color: fg,
				),
			),
		);
	}
}

class _TextPill extends StatelessWidget {
	const _TextPill({required this.label});

	final String label;

	@override
	Widget build(BuildContext context) {
		final theme = Theme.of(context);
		final outline = theme.colorScheme.outline.withAlpha(102);
		return Container(
			padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
			decoration: BoxDecoration(
				color: theme.colorScheme.surfaceContainerHighest,
				borderRadius: BorderRadius.circular(999),
				border: Border.all(color: outline),
			),
			child: Text(
				label,
				style: theme.textTheme.bodySmall?.copyWith(
					fontWeight: FontWeight.w900,
					letterSpacing: 0.15,
					color: theme.colorScheme.onSurface.withAlpha(190),
				),
			),
		);
	}
}
