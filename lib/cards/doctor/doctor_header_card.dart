import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';

class DoctorHeaderCard extends StatelessWidget {
	const DoctorHeaderCard({
		super.key,
		required this.photoPath,
		required this.photoBytes,
		required this.doctorName,
		required this.addedByLabel,
		required this.onEdit,
		required this.onDelete,
	});

	final String photoPath;
	final Uint8List? photoBytes;
	final String doctorName;
	final String addedByLabel;
	final VoidCallback onEdit;
	final VoidCallback onDelete;

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
				child: AspectRatio(
					aspectRatio: 16 / 7,
					child: Stack(
						fit: StackFit.expand,
						children: [
							_Background(photoPath: photoPath, photoBytes: photoBytes),
							DecoratedBox(
								decoration: BoxDecoration(
									gradient: LinearGradient(
										begin: Alignment.bottomCenter,
										end: Alignment.topCenter,
										colors: [
											theme.colorScheme.surface.withAlpha(242),
											theme.colorScheme.surface.withAlpha(150),
											Colors.transparent,
										],
									),
								),
							),
							Positioned(
								top: 12,
								right: 12,
								child: Row(
									children: [
										_IconPillButton(
											icon: Iconsax.edit_2,
											tooltip: 'Edit doctor',
											onTap: onEdit,
										),
										const SizedBox(width: 10),
										_IconPillButton(
											icon: Iconsax.trash,
											tooltip: 'Delete doctor',
											onTap: onDelete,
											isDestructive: true,
										),
									],
								),
							),
							Padding(
								padding: const EdgeInsets.all(16),
								child: Align(
									alignment: Alignment.bottomLeft,
									child: Column(
										mainAxisSize: MainAxisSize.min,
										crossAxisAlignment: CrossAxisAlignment.start,
										children: [
											Text(
												doctorName,
												maxLines: 1,
												overflow: TextOverflow.ellipsis,
												style: theme.textTheme.titleLarge?.copyWith(
													fontWeight: FontWeight.w900,
													letterSpacing: -0.3,
												),
											),
											const SizedBox(height: 6),
											Text(
												addedByLabel,
												maxLines: 1,
												overflow: TextOverflow.ellipsis,
												style: theme.textTheme.bodyMedium?.copyWith(
													color: theme.colorScheme.onSurface.withAlpha(166),
													fontWeight: FontWeight.w800,
												),
											),
										],
									),
								),
							),
						],
					),
				),
			),
		);
	}
}

class _IconPillButton extends StatelessWidget {
	const _IconPillButton({
		required this.icon,
		required this.tooltip,
		required this.onTap,
		this.isDestructive = false,
	});

	final IconData icon;
	final String tooltip;
	final VoidCallback onTap;
	final bool isDestructive;

	@override
	Widget build(BuildContext context) {
		final theme = Theme.of(context);
		final outline = theme.colorScheme.outline.withAlpha(120);
		final color = isDestructive
				? theme.colorScheme.error
				: theme.colorScheme.onSurface.withAlpha(217);

		return Material(
			color: theme.colorScheme.surface.withAlpha(235),
			borderRadius: BorderRadius.circular(16),
			child: InkWell(
				onTap: onTap,
				borderRadius: BorderRadius.circular(16),
				child: Tooltip(
					message: tooltip,
					child: Container(
						width: 42,
						height: 42,
						decoration: BoxDecoration(
							borderRadius: BorderRadius.circular(16),
							border: Border.all(color: outline),
						),
						child: Icon(icon, size: 20, color: color),
					),
				),
			),
		);
	}
}

class _Background extends StatelessWidget {
	const _Background({required this.photoPath, required this.photoBytes});

	final String photoPath;
	final Uint8List? photoBytes;

	@override
	Widget build(BuildContext context) {
		final theme = Theme.of(context);

		if (photoBytes != null) {
			return Image.memory(photoBytes!, fit: BoxFit.cover);
		}

		if (photoPath.trim().isEmpty) {
			return DecoratedBox(
				decoration: BoxDecoration(
					gradient: LinearGradient(
						begin: Alignment.topLeft,
						end: Alignment.bottomRight,
						colors: [
							theme.colorScheme.primary.withAlpha(18),
							theme.colorScheme.surfaceContainerHighest,
						],
					),
				),
				child: Center(
					child: Icon(
						Icons.medical_services_rounded,
						size: 44,
						color: theme.colorScheme.primary.withAlpha(191),
					),
				),
			);
		}

		if (photoPath.trim().startsWith('assets/')) {
			return Image.asset(photoPath.trim(), fit: BoxFit.cover);
		}

		return Image.network(
			photoPath.trim(),
			fit: BoxFit.cover,
			errorBuilder: (_, _, _) {
				return DecoratedBox(
					decoration: BoxDecoration(
						gradient: LinearGradient(
							begin: Alignment.topLeft,
							end: Alignment.bottomRight,
							colors: [
								theme.colorScheme.primary.withAlpha(18),
								theme.colorScheme.surfaceContainerHighest,
							],
						),
					),
					child: Center(
						child: Icon(
							Icons.medical_services_rounded,
							size: 44,
							color: theme.colorScheme.primary.withAlpha(191),
						),
					),
				);
			},
		);
	}
}

