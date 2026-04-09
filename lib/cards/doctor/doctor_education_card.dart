import 'package:flutter/material.dart';

class DoctorEducationCard extends StatelessWidget {
	const DoctorEducationCard({
		super.key,
		required this.description,
		required this.degrees,
	});

	final String description;
	final List<String> degrees;

	@override
	Widget build(BuildContext context) {
		final theme = Theme.of(context);
		final outline = theme.colorScheme.outline.withAlpha(102);

		final cleanDegrees = degrees.map((e) => e.trim()).where((e) => e.isNotEmpty).toList();

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
								Icon(Icons.school_rounded, color: theme.colorScheme.primary),
								const SizedBox(width: 10),
								Text(
									'Education',
									style: theme.textTheme.titleMedium?.copyWith(
										fontWeight: FontWeight.w900,
										letterSpacing: -0.2,
									),
								),
							],
						),
						const SizedBox(height: 12),
						Text(
							description.trim().isEmpty ? '-' : description.trim(),
							style: theme.textTheme.bodyMedium?.copyWith(
								fontWeight: FontWeight.w700,
								color: theme.colorScheme.onSurface.withAlpha(191),
								height: 1.25,
							),
						),
						const SizedBox(height: 12),
						Text(
							'Degrees',
							style: theme.textTheme.bodySmall?.copyWith(
								color: theme.colorScheme.onSurface.withAlpha(166),
								fontWeight: FontWeight.w800,
							),
						),
						const SizedBox(height: 6),
						if (cleanDegrees.isEmpty)
							Text(
								'-',
								style: theme.textTheme.bodyMedium?.copyWith(
									fontWeight: FontWeight.w800,
								),
							)
						else
							Wrap(
								spacing: 8,
								runSpacing: 8,
								children: [
									for (final d in cleanDegrees)
										Chip(
											label: Text(
												d,
												style: theme.textTheme.bodySmall?.copyWith(
													fontWeight: FontWeight.w800,
												),
											),
										),
								],
							),
					],
				),
			),
		);
	}
}

