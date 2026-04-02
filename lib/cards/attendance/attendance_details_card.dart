
import 'dart:typed_data';

import 'package:flutter/material.dart';

import '../../models/attendance.dart';

class AttendanceDetailsCard extends StatelessWidget {
	const AttendanceDetailsCard({
		super.key,
		required this.subject,
		required this.day,
		required this.record,
	});

	final AttendanceSubject? subject;
	final DateTime? day;
	final AttendanceRecord? record;

	@override
	Widget build(BuildContext context) {
		final theme = Theme.of(context);
		final outline = theme.colorScheme.outline.withAlpha(102);
		final onSurface = theme.colorScheme.onSurface;
		final loc = MaterialLocalizations.of(context);

		final title = (subject == null)
				? 'Attendance details'
				: 'Attendance details • ${subject!.label}';

		String? dateLabel;
		if (day != null) {
			dateLabel = '${day!.day.toString().padLeft(2, '0')}/'
					'${day!.month.toString().padLeft(2, '0')}/'
					'${day!.year}';
		}

		return Card(
			color: theme.colorScheme.surface,
			shape: RoundedRectangleBorder(
				borderRadius: BorderRadius.circular(24),
				side: BorderSide(color: outline),
			),
			child: Padding(
				padding: const EdgeInsets.all(16),
				child: Column(
					crossAxisAlignment: CrossAxisAlignment.stretch,
					children: [
						Row(
							children: [
								Icon(Icons.fact_check_rounded, color: theme.colorScheme.primary),
								const SizedBox(width: 10),
								Expanded(
									child: Text(
										title,
										style: theme.textTheme.titleMedium?.copyWith(
											fontWeight: FontWeight.w900,
											letterSpacing: -0.2,
										),
									),
								),
							],
						),
						const SizedBox(height: 10),
						if (subject == null)
							Text(
								'Select an MR/ASM to view attendance.',
								style: theme.textTheme.bodySmall?.copyWith(
									color: onSurface.withAlpha(170),
									fontWeight: FontWeight.w800,
								),
							)
						else if (record == null)
							Text(
								(dateLabel == null)
										? 'Tap a dotted date to view details.'
										: 'No attendance details for $dateLabel.',
								style: theme.textTheme.bodySmall?.copyWith(
									color: onSurface.withAlpha(170),
									fontWeight: FontWeight.w800,
								),
							)
						else ...[
							Text(
								'${record!.subjectName}${dateLabel == null ? '' : ' • $dateLabel'}',
								style: theme.textTheme.titleSmall?.copyWith(
									fontWeight: FontWeight.w900,
									letterSpacing: -0.1,
								),
							),
							const SizedBox(height: 14),
							_CheckpointSection(
								header: 'Check-in',
								checkpoint: record!.checkIn,
								loc: loc,
							),
							const SizedBox(height: 12),
							_CheckpointSection(
								header: 'Check-out',
								checkpoint: record!.checkOut,
								loc: loc,
							),
						],
					],
				),
			),
		);
	}
}

class _CheckpointSection extends StatelessWidget {
	const _CheckpointSection({
		required this.header,
		required this.checkpoint,
		required this.loc,
	});

	final String header;
	final AttendanceCheckpoint? checkpoint;
	final MaterialLocalizations loc;

	@override
	Widget build(BuildContext context) {
		final theme = Theme.of(context);
		final outline = theme.colorScheme.outline.withAlpha(102);
		final onSurface = theme.colorScheme.onSurface;

		final timeText = (checkpoint == null)
				? '—'
				: loc.formatTimeOfDay(
						TimeOfDay.fromDateTime(checkpoint!.at),
						alwaysUse24HourFormat: false,
					);

		final lat = checkpoint?.location.latitude;
		final lng = checkpoint?.location.longitude;

		return Container(
			padding: const EdgeInsets.all(12),
			decoration: BoxDecoration(
				color: theme.colorScheme.surfaceContainerHighest,
				borderRadius: BorderRadius.circular(18),
				border: Border.all(color: outline),
			),
			child: Column(
				crossAxisAlignment: CrossAxisAlignment.stretch,
				children: [
					Row(
						children: [
							Expanded(
								child: Text(
									header,
									style: theme.textTheme.titleSmall?.copyWith(
										fontWeight: FontWeight.w900,
										letterSpacing: -0.1,
									),
								),
							),
							Text(
								timeText,
								style: theme.textTheme.titleSmall?.copyWith(
									fontWeight: FontWeight.w900,
								),
							),
						],
					),
					const SizedBox(height: 10),
					Row(
						crossAxisAlignment: CrossAxisAlignment.start,
						children: [
							Expanded(
								child: _InfoLine(
									label: 'Latitude',
									value: lat == null ? '—' : lat.toStringAsFixed(6),
								),
							),
							const SizedBox(width: 10),
							Expanded(
								child: _InfoLine(
									label: 'Longitude',
									value: lng == null ? '—' : lng.toStringAsFixed(6),
								),
							),
						],
					),
					const SizedBox(height: 12),
					Text(
						'Selfie',
						style: theme.textTheme.bodySmall?.copyWith(
							color: onSurface.withAlpha(180),
							fontWeight: FontWeight.w900,
						),
					),
					const SizedBox(height: 8),
					_IdentityImage(bytes: checkpoint?.selfieBytes),
				],
			),
		);
	}
}

class _InfoLine extends StatelessWidget {
	const _InfoLine({required this.label, required this.value});

	final String label;
	final String value;

	@override
	Widget build(BuildContext context) {
		final theme = Theme.of(context);
		return Column(
			crossAxisAlignment: CrossAxisAlignment.start,
			children: [
				Text(
					label,
					style: theme.textTheme.bodySmall?.copyWith(
						color: theme.colorScheme.onSurface.withAlpha(180),
						fontWeight: FontWeight.w900,
					),
				),
				const SizedBox(height: 2),
				Text(
					value,
					style: theme.textTheme.bodyMedium?.copyWith(
						fontWeight: FontWeight.w800,
					),
				),
			],
		);
	}
}

class _IdentityImage extends StatelessWidget {
	const _IdentityImage({required this.bytes});

	final Uint8List? bytes;

	@override
	Widget build(BuildContext context) {
		final theme = Theme.of(context);
		final outline = theme.colorScheme.outline.withAlpha(102);

		if (bytes == null || bytes!.isEmpty) {
			return Container(
				height: 160,
				decoration: BoxDecoration(
					color: theme.colorScheme.surface,
					borderRadius: BorderRadius.circular(18),
					border: Border.all(color: outline),
				),
				child: Center(
					child: Text(
						'Selfie not available',
						style: theme.textTheme.bodySmall?.copyWith(
							fontWeight: FontWeight.w800,
							color: theme.colorScheme.onSurface.withAlpha(170),
						),
					),
				),
			);
		}

		return ClipRRect(
			borderRadius: BorderRadius.circular(18),
			child: AspectRatio(
				aspectRatio: 4 / 3,
				child: Image.memory(bytes!, fit: BoxFit.cover),
			),
		);
	}
}

