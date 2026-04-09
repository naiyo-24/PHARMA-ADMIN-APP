import 'package:flutter/material.dart';

class DoctorExperienceCard extends StatelessWidget {
	const DoctorExperienceCard({
		super.key,
		required this.degrees,
		required this.experience,
	});

	final List<String> degrees;
	final String experience;

	@override
	Widget build(BuildContext context) {
		final theme = Theme.of(context);
		final outline = theme.colorScheme.outline.withAlpha(102);

		final cleanDegrees = degrees.map((e) => e.trim()).where((e) => e.isNotEmpty).toList();
		final cleanExp = experience.trim().isEmpty ? '-' : experience.trim();

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
								Icon(Icons.work_history_rounded, color: theme.colorScheme.primary),
								const SizedBox(width: 10),
								Text(
									'Experience',
									style: theme.textTheme.titleMedium?.copyWith(
										fontWeight: FontWeight.w900,
										letterSpacing: -0.2,
									),
								),
							],
						),
						const SizedBox(height: 12),
						Text(
							'Qualifications',
							style: theme.textTheme.bodySmall?.copyWith(
								color: theme.colorScheme.onSurface.withAlpha(166),
								fontWeight: FontWeight.w800,
							),
						),
						const SizedBox(height: 6),
						Text(
							cleanDegrees.isEmpty ? '-' : cleanDegrees.join(' • '),
							style: theme.textTheme.bodyMedium?.copyWith(
								fontWeight: FontWeight.w800,
							),
						),
						const SizedBox(height: 12),
						Text(
							cleanExp,
							style: theme.textTheme.bodyMedium?.copyWith(
								fontWeight: FontWeight.w700,
								color: theme.colorScheme.onSurface.withAlpha(191),
								height: 1.25,
							),
						),
					],
				),
			),
		);
	}
}

