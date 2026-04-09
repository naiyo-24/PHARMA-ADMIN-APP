import 'dart:typed_data';

import 'package:flutter/material.dart';

class DoctorCard extends StatelessWidget {
	const DoctorCard({
		super.key,
		required this.photoPath,
		required this.photoBytes,
		required this.doctorName,
		required this.specialization,
		required this.onTap,
	});

	final String photoPath;
	final Uint8List? photoBytes;
	final String doctorName;
	final String specialization;
	final VoidCallback onTap;

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
			child: InkWell(
				borderRadius: BorderRadius.circular(24),
				onTap: onTap,
				child: Padding(
					padding: const EdgeInsets.all(14),
					child: Row(
						children: [
							_Photo(
								photoPath: photoPath,
								photoBytes: photoBytes,
								outline: outline,
							),
							const SizedBox(width: 12),
							Expanded(
								child: Column(
									crossAxisAlignment: CrossAxisAlignment.start,
									children: [
										Text(
											doctorName,
											maxLines: 1,
											overflow: TextOverflow.ellipsis,
											style: theme.textTheme.titleMedium?.copyWith(
												fontWeight: FontWeight.w900,
												letterSpacing: -0.2,
											),
										),
										const SizedBox(height: 4),
										Text(
											specialization,
											maxLines: 2,
											overflow: TextOverflow.ellipsis,
											style: theme.textTheme.bodyMedium?.copyWith(
												color: theme.colorScheme.onSurface.withAlpha(166),
												fontWeight: FontWeight.w800,
												height: 1.15,
											),
										),
									],
								),
							),
							const SizedBox(width: 10),
							Icon(
								Icons.arrow_forward_ios_rounded,
								size: 16,
								color: theme.colorScheme.onSurface.withAlpha(166),
							),
						],
					),
				),
			),
		);
	}
}

class _Photo extends StatelessWidget {
	const _Photo({
		required this.photoPath,
		required this.photoBytes,
		required this.outline,
	});

	final String photoPath;
	final Uint8List? photoBytes;
	final Color outline;

	@override
	Widget build(BuildContext context) {
		final theme = Theme.of(context);

		Widget child;
		if (photoBytes != null) {
			child = Image.memory(photoBytes!, fit: BoxFit.cover);
		} else if (photoPath.trim().isEmpty) {
			child = Center(
				child: Icon(
					Icons.medical_services_rounded,
					color: theme.colorScheme.primary,
					size: 26,
				),
			);
		} else if (photoPath.trim().startsWith('assets/')) {
			child = Image.asset(
				photoPath.trim(),
				fit: BoxFit.cover,
				errorBuilder: (_, _, _) {
					return Center(
						child: Icon(
							Icons.medical_services_rounded,
							color: theme.colorScheme.primary,
							size: 26,
						),
					);
				},
			);
		} else {
			child = Image.network(
				photoPath.trim(),
				fit: BoxFit.cover,
				errorBuilder: (_, _, _) {
					return Center(
						child: Icon(
							Icons.medical_services_rounded,
							color: theme.colorScheme.primary,
							size: 26,
						),
					);
				},
			);
		}

		return Container(
			width: 64,
			height: 64,
			decoration: BoxDecoration(
				borderRadius: BorderRadius.circular(20),
				color: theme.colorScheme.primary.withAlpha(10),
				border: Border.all(color: outline),
			),
			clipBehavior: Clip.antiAlias,
			child: child,
		);
	}
}

