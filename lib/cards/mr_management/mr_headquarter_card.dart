import 'package:flutter/material.dart';

class MrHeadquarterCard extends StatelessWidget {
	const MrHeadquarterCard({
		super.key,
		required this.headquarter,
		required this.territories,
	});

	final String headquarter;
	final List<String> territories;

	@override
	Widget build(BuildContext context) {
		final theme = Theme.of(context);
		final outline = theme.colorScheme.outline.withAlpha(102);

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
								Icon(
									Icons.location_city_rounded,
									color: theme.colorScheme.primary,
								),
								const SizedBox(width: 10),
								Text(
									'Headquarter',
									style: theme.textTheme.titleMedium?.copyWith(
										fontWeight: FontWeight.w900,
										letterSpacing: -0.2,
									),
								),
							],
						),
						const SizedBox(height: 12),
						Text(
							headquarter,
							style: theme.textTheme.bodyLarge?.copyWith(
								fontWeight: FontWeight.w900,
							),
						),
						const SizedBox(height: 10),
						Wrap(
							spacing: 10,
							runSpacing: 10,
							children: [
								for (final t in territories)
									Container(
										padding:
												const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
										decoration: BoxDecoration(
											borderRadius: BorderRadius.circular(999),
											border: Border.all(
												color: theme.colorScheme.primary.withAlpha(70),
											),
											color: theme.colorScheme.primary.withAlpha(14),
										),
										child: Text(
											t,
											style: theme.textTheme.bodySmall?.copyWith(
												fontWeight: FontWeight.w800,
												color: theme.colorScheme.onSurface.withAlpha(204),
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

