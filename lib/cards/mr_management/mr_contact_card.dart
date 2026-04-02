import 'package:flutter/material.dart';

class MrContactCard extends StatelessWidget {
	const MrContactCard({
		super.key,
		required this.phoneNumber,
		required this.alternativePhoneNumber,
		required this.email,
		required this.address,
	});

	final String phoneNumber;
	final String? alternativePhoneNumber;
	final String? email;
	final String? address;

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
									Icons.contact_page_rounded,
									color: theme.colorScheme.primary,
								),
								const SizedBox(width: 10),
								Text(
									'Contact',
									style: theme.textTheme.titleMedium?.copyWith(
										fontWeight: FontWeight.w900,
										letterSpacing: -0.2,
									),
								),
							],
						),
						const SizedBox(height: 12),
						_Item(label: 'Phone', value: phoneNumber),
						const SizedBox(height: 10),
						_Item(
							label: 'Alt. phone',
							value: (alternativePhoneNumber == null ||
											alternativePhoneNumber!.trim().isEmpty)
									? '-'
									: alternativePhoneNumber!,
						),
						const SizedBox(height: 10),
						_Item(
							label: 'Email',
							value: (email == null || email!.trim().isEmpty) ? '-' : email!,
						),
						const SizedBox(height: 10),
						_Item(
							label: 'Address',
							value:
									(address == null || address!.trim().isEmpty) ? '-' : address!,
						),
					],
				),
			),
		);
	}
}

class _Item extends StatelessWidget {
	const _Item({required this.label, required this.value});

	final String label;
	final String value;

	@override
	Widget build(BuildContext context) {
		final theme = Theme.of(context);

		return Row(
			crossAxisAlignment: CrossAxisAlignment.start,
			children: [
				Expanded(
					flex: 4,
					child: Text(
						label,
						style: theme.textTheme.bodySmall?.copyWith(
							color: theme.colorScheme.onSurface.withAlpha(166),
							fontWeight: FontWeight.w800,
						),
					),
				),
				Expanded(
					flex: 7,
					child: Text(
						value,
						textAlign: TextAlign.right,
						style: theme.textTheme.bodyMedium?.copyWith(
							fontWeight: FontWeight.w800,
						),
					),
				),
			],
		);
	}
}

