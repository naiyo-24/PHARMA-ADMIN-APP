import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class DoctorContactCard extends StatelessWidget {
	const DoctorContactCard({
		super.key,
		required this.phoneNumber,
		required this.email,
		required this.address,
	});

	final String phoneNumber;
	final String email;
	final String address;

	@override
	Widget build(BuildContext context) {
		final theme = Theme.of(context);
		final outline = theme.colorScheme.outline.withAlpha(102);

		String normalize(String v) {
			final t = v.trim();
			return t.isEmpty ? '-' : t;
		}

		final normalizedPhone = normalize(phoneNumber);
		final normalizedEmail = normalize(email);
		final normalizedAddress = normalize(address);

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
								Icon(Icons.contact_phone_rounded, color: theme.colorScheme.primary),
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
						_ContactRow(
							icon: Icons.phone_rounded,
							label: 'Phone',
							value: normalizedPhone,
							enabled: normalizedPhone != '-',
							onTap: () => _dial(phoneNumber),
						),
						const SizedBox(height: 8),
						_ContactRow(
							icon: Icons.email_rounded,
							label: 'Email',
							value: normalizedEmail,
							enabled: normalizedEmail != '-',
							onTap: () => _email(email),
						),
						const SizedBox(height: 8),
						_ContactRow(
							icon: Icons.location_on_rounded,
							label: 'Address',
							value: normalizedAddress,
							enabled: normalizedAddress != '-',
							onTap: () => _openMaps(address),
						),
					],
				),
			),
		);
	}

	Future<void> _openMaps(String address) async {
		final uri = Uri.parse(
			'https://www.google.com/maps/search/?api=1&query=${Uri.encodeComponent(address)}',
		);
		await _launch(uri);
	}

	Future<void> _dial(String phoneNumber) async {
		final uri = Uri(scheme: 'tel', path: phoneNumber);
		await _launch(uri);
	}

	Future<void> _email(String email) async {
		final uri = Uri(scheme: 'mailto', path: email);
		await _launch(uri);
	}

	Future<void> _launch(Uri uri) async {
		await launchUrl(uri, mode: LaunchMode.externalApplication);
	}
}

class _ContactRow extends StatelessWidget {
	const _ContactRow({
		required this.icon,
		required this.label,
		required this.value,
		required this.onTap,
		required this.enabled,
	});

	final IconData icon;
	final String label;
	final String value;
	final VoidCallback onTap;
	final bool enabled;

	@override
	Widget build(BuildContext context) {
		final theme = Theme.of(context);
		final outline = theme.colorScheme.outline.withAlpha(90);

		return InkWell(
			onTap: enabled ? onTap : null,
			borderRadius: BorderRadius.circular(18),
			child: Opacity(
				opacity: enabled ? 1 : 0.6,
				child: Container(
					padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
					decoration: BoxDecoration(
						borderRadius: BorderRadius.circular(18),
						border: Border.all(color: outline),
						color: theme.colorScheme.surface,
					),
					child: Row(
						children: [
							Container(
								width: 36,
								height: 36,
								decoration: BoxDecoration(
									borderRadius: BorderRadius.circular(14),
									color: theme.colorScheme.primary.withAlpha(18),
									border: Border.all(
										color: theme.colorScheme.primary.withAlpha(70),
									),
								),
								child: Icon(icon, color: theme.colorScheme.primary, size: 20),
							),
							const SizedBox(width: 12),
							Expanded(
								child: Column(
									crossAxisAlignment: CrossAxisAlignment.start,
									children: [
										Text(
											label,
											style: theme.textTheme.bodySmall?.copyWith(
												color: theme.colorScheme.onSurface.withAlpha(166),
												fontWeight: FontWeight.w800,
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
								),
							),
							const SizedBox(width: 10),
							Icon(
								Icons.open_in_new_rounded,
								size: 18,
								color: theme.colorScheme.onSurface.withAlpha(166),
							),
						],
					),
				),
			),
		);
	}
}

