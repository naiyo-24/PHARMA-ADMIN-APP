import 'package:flutter/material.dart';

import '../../models/doctor.dart';

class DoctorChamberCard extends StatelessWidget {
	const DoctorChamberCard({super.key, required this.chambers});

	final List<DoctorChamber> chambers;

	@override
	Widget build(BuildContext context) {
		final theme = Theme.of(context);
		final outline = theme.colorScheme.outline.withAlpha(102);
		final normalized = chambers
				.map((c) => DoctorChamber(
					name: c.name.trim(),
					phoneNumber: c.phoneNumber.trim(),
					address: c.address.trim(),
				))
				.where((c) => c.name.isNotEmpty || c.phoneNumber.isNotEmpty || c.address.isNotEmpty)
				.toList(growable: false);

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
				child: Column(
					crossAxisAlignment: CrossAxisAlignment.start,
					children: [
						Row(
							children: [
								Icon(Icons.apartment_rounded, color: theme.colorScheme.primary),
								const SizedBox(width: 10),
								Text(
									'Chambers',
									style: theme.textTheme.titleMedium?.copyWith(
										fontWeight: FontWeight.w900,
										letterSpacing: -0.2,
									),
								),
							],
						),
						const SizedBox(height: 12),
						if (normalized.isEmpty)
							Text(
								'-',
								style: theme.textTheme.bodyMedium?.copyWith(
									fontWeight: FontWeight.w800,
								),
							)
						else
							Column(
								crossAxisAlignment: CrossAxisAlignment.stretch,
								children: [
									for (final c in normalized) ...[
										_Entry(chamber: c),
										const SizedBox(height: 10),
									],
								],
							),
					],
				),
			),
		);
	}
}

class _Entry extends StatelessWidget {
	const _Entry({required this.chamber});

	final DoctorChamber chamber;

	@override
	Widget build(BuildContext context) {
		final theme = Theme.of(context);
		final outline = theme.colorScheme.outline.withAlpha(90);

		String normalize(String v) => v.trim().isEmpty ? '-' : v.trim();

		return Container(
			padding: const EdgeInsets.all(14),
			decoration: BoxDecoration(
				borderRadius: BorderRadius.circular(18),
				border: Border.all(color: outline),
				color: theme.colorScheme.surface,
			),
			child: Column(
				crossAxisAlignment: CrossAxisAlignment.start,
				children: [
					Text(
						normalize(chamber.name),
						style: theme.textTheme.titleSmall?.copyWith(
							fontWeight: FontWeight.w900,
							letterSpacing: -0.2,
						),
					),
					const SizedBox(height: 6),
					Row(
						children: [
							Icon(
								Icons.phone_rounded,
								size: 18,
								color: theme.colorScheme.onSurface.withAlpha(166),
							),
							const SizedBox(width: 8),
							Expanded(
								child: Text(
									normalize(chamber.phoneNumber),
									style: theme.textTheme.bodyMedium?.copyWith(
										fontWeight: FontWeight.w800,
									),
								),
							),
						],
					),
					const SizedBox(height: 6),
					Row(
						children: [
							Icon(
								Icons.location_on_rounded,
								size: 18,
								color: theme.colorScheme.onSurface.withAlpha(166),
							),
							const SizedBox(width: 8),
							Expanded(
								child: Text(
									normalize(chamber.address),
									style: theme.textTheme.bodyMedium?.copyWith(
										fontWeight: FontWeight.w800,
									),
								),
							),
						],
					),
				],
			),
		);
	}
}

