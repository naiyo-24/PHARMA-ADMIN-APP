import 'dart:typed_data';

import 'package:flutter/material.dart';

class MrHeaderCard extends StatelessWidget {
	const MrHeaderCard({
		super.key,
		required this.photoBytes,
		required this.name,
		required this.password,
	});

	final Uint8List? photoBytes;
	final String name;
	final String password;

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
			child: ClipRRect(
				borderRadius: BorderRadius.circular(24),
				child: Stack(
					children: [
						SizedBox(
							height: 180,
							width: double.infinity,
							child: (photoBytes == null)
									? Container(
											decoration: BoxDecoration(
												gradient: LinearGradient(
													begin: Alignment.topLeft,
													end: Alignment.bottomRight,
													colors: [
														theme.colorScheme.primary.withAlpha(50),
														theme.colorScheme.surface,
													],
												),
											),
										)
									: Image.memory(
											photoBytes!,
											fit: BoxFit.cover,
										),
						),
						Positioned.fill(
							child: DecoratedBox(
								decoration: BoxDecoration(
									gradient: LinearGradient(
										begin: Alignment.topCenter,
										end: Alignment.bottomCenter,
										colors: [
											Colors.black.withAlpha(0),
											Colors.black.withAlpha(170),
										],
									),
								),
							),
						),
						Positioned(
							left: 16,
							right: 16,
							bottom: 16,
							child: Column(
								crossAxisAlignment: CrossAxisAlignment.start,
								children: [
									Container(
										padding:
												const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
										decoration: BoxDecoration(
											borderRadius: BorderRadius.circular(999),
											color: theme.colorScheme.primary.withAlpha(200),
										),
										child: Text(
											'MR',
											style: theme.textTheme.bodySmall?.copyWith(
												color: theme.colorScheme.onPrimary,
												fontWeight: FontWeight.w900,
												letterSpacing: 0.6,
											),
										),
									),
									const SizedBox(height: 10),
									Text(
										name,
										maxLines: 1,
										overflow: TextOverflow.ellipsis,
										style: theme.textTheme.titleLarge?.copyWith(
											color: Colors.white,
											fontWeight: FontWeight.w900,
											letterSpacing: -0.2,
										),
									),
									const SizedBox(height: 6),
									Text(
										'Password: $password',
										maxLines: 1,
										overflow: TextOverflow.ellipsis,
										style: theme.textTheme.bodyMedium?.copyWith(
											color: Colors.white.withAlpha(230),
											fontWeight: FontWeight.w800,
										),
									),
								],
							),
						),
					],
				),
			),
		);
	}
}

