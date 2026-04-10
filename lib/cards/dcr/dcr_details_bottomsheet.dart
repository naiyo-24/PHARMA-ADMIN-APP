
import 'package:flutter/material.dart';

import '../../models/dcr.dart';

class DcrDetailsBottomSheet extends StatelessWidget {
	const DcrDetailsBottomSheet({super.key, required this.dcr});

	final Dcr dcr;

	@override
	Widget build(BuildContext context) {
		final theme = Theme.of(context);
		final outline = theme.colorScheme.outline.withAlpha(102);
		final dateLabel = MaterialLocalizations.of(context).formatFullDate(dcr.date);

		return SafeArea(
			child: Padding(
				padding: EdgeInsets.only(
					left: 16,
					right: 16,
					top: 12,
					bottom: 16 + MediaQuery.of(context).viewInsets.bottom,
				),
				child: ConstrainedBox(
					constraints: const BoxConstraints(maxWidth: 820),
					child: Column(
						mainAxisSize: MainAxisSize.min,
						crossAxisAlignment: CrossAxisAlignment.stretch,
						children: [
							Row(
								children: [
									Expanded(
										child: Text(
											'DCR Details',
											style: theme.textTheme.titleLarge?.copyWith(
												fontWeight: FontWeight.w900,
												letterSpacing: -0.2,
											),
										),
									),
									_StatusChip(status: dcr.status),
								],
							),
							const SizedBox(height: 12),
							Card(
								elevation: 0,
								surfaceTintColor: Colors.transparent,
								color: theme.colorScheme.surface,
								shape: RoundedRectangleBorder(
									borderRadius: BorderRadius.circular(24),
									side: BorderSide(color: outline),
								),
								child: Padding(
									padding: const EdgeInsets.all(14),
									child: Column(
										crossAxisAlignment: CrossAxisAlignment.stretch,
										children: [
											_LabeledRow(label: 'DCR ID', value: dcr.id),
											const SizedBox(height: 10),
											_LabeledRow(
												label: 'Created by',
												value: '${dcr.createdByType.label}: ${dcr.createdByName}',
											),
											const SizedBox(height: 10),
											_LabeledRow(label: 'Doctor', value: dcr.doctorName),
											const SizedBox(height: 10),
											_LabeledRow(label: 'Date', value: dateLabel),
										],
									),
								),
							),
							const SizedBox(height: 12),
							Card(
								elevation: 0,
								surfaceTintColor: Colors.transparent,
								color: theme.colorScheme.surface,
								shape: RoundedRectangleBorder(
									borderRadius: BorderRadius.circular(24),
									side: BorderSide(color: outline),
								),
								child: Padding(
									padding: const EdgeInsets.all(14),
									child: Column(
										crossAxisAlignment: CrossAxisAlignment.stretch,
										children: [
											Text(
												'Notes',
												style: theme.textTheme.titleMedium?.copyWith(
													fontWeight: FontWeight.w900,
													letterSpacing: -0.2,
												),
											),
											const SizedBox(height: 8),
											Text(
												dcr.notes.trim().isEmpty ? '—' : dcr.notes.trim(),
												style: theme.textTheme.bodyMedium?.copyWith(
													fontWeight: FontWeight.w700,
													height: 1.25,
													color: theme.colorScheme.onSurface.withAlpha(204),
												),
											),
										],
									),
								),
							),
							const SizedBox(height: 12),
							Card(
								elevation: 0,
								surfaceTintColor: Colors.transparent,
								color: theme.colorScheme.surface,
								shape: RoundedRectangleBorder(
									borderRadius: BorderRadius.circular(24),
									side: BorderSide(color: outline),
								),
								child: Padding(
									padding: const EdgeInsets.all(14),
									child: Column(
										crossAxisAlignment: CrossAxisAlignment.stretch,
										children: [
											Text(
												'Visual ads presented',
												style: theme.textTheme.titleMedium?.copyWith(
													fontWeight: FontWeight.w900,
													letterSpacing: -0.2,
												),
											),
											const SizedBox(height: 8),
											if (dcr.visualAdsPresented.isEmpty)
												Text(
													'No visual ads recorded.',
													style: theme.textTheme.bodyMedium?.copyWith(
														fontWeight: FontWeight.w700,
														color: theme.colorScheme.onSurface.withAlpha(166),
													),
												)
											else
												Wrap(
													spacing: 10,
													runSpacing: 10,
													children: [
														for (final v in dcr.visualAdsPresented)
															_Chip(text: v),
													],
												),
										],
									),
								),
							),
							const SizedBox(height: 12),
							Align(
								alignment: Alignment.centerRight,
								child: FilledButton(
									onPressed: () => Navigator.of(context).maybePop(),
									child: const Text('Close'),
								),
							),
						],
					),
				),
			),
		);
	}
}

class _LabeledRow extends StatelessWidget {
	const _LabeledRow({required this.label, required this.value});

	final String label;
	final String value;

	@override
	Widget build(BuildContext context) {
		final theme = Theme.of(context);
		return Row(
			crossAxisAlignment: CrossAxisAlignment.start,
			children: [
				SizedBox(
					width: 120,
					child: Text(
						label,
						style: theme.textTheme.bodyMedium?.copyWith(
							fontWeight: FontWeight.w900,
							color: theme.colorScheme.onSurface.withAlpha(166),
						),
					),
				),
				const SizedBox(width: 12),
				Expanded(
					child: Text(
						value,
						style: theme.textTheme.bodyMedium?.copyWith(
							fontWeight: FontWeight.w800,
							color: theme.colorScheme.onSurface.withAlpha(230),
						),
					),
				),
			],
		);
	}
}

class _Chip extends StatelessWidget {
	const _Chip({required this.text});

	final String text;

	@override
	Widget build(BuildContext context) {
		final theme = Theme.of(context);
		final outline = theme.colorScheme.outline.withAlpha(102);
		return Container(
			padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
			decoration: BoxDecoration(
				color: theme.colorScheme.surfaceContainerHighest,
				borderRadius: BorderRadius.circular(999),
				border: Border.all(color: outline),
			),
			child: Text(
				text,
				style: theme.textTheme.bodySmall?.copyWith(
					fontWeight: FontWeight.w900,
					letterSpacing: 0.15,
					color: theme.colorScheme.onSurface.withAlpha(204),
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
