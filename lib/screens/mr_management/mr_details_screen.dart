import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../cards/mr_management/mr_bank_details_card.dart';
import '../../cards/mr_management/mr_contact_card.dart';
import '../../cards/mr_management/mr_header_card.dart';
import '../../cards/mr_management/mr_headquarter_card.dart';
import '../../notifiers/mr_management_notifier.dart';
import '../../theme/app_theme.dart';
import '../../widgets/app_bar.dart';

class MrDetailsScreen extends ConsumerWidget {
	const MrDetailsScreen({super.key, required this.mrId});

	final String mrId;

	@override
	Widget build(BuildContext context, WidgetRef ref) {
		final theme = Theme.of(context);
		final padding = AppLayout.pagePadding(context);
		final listAsync = ref.watch(mrManagementNotifierProvider);

		return Scaffold(
			appBar: const AppAppBar(
				showLogo: false,
				showBackIfPossible: true,
				showMenuIfNoBack: false,
				title: 'MR Details',
				subtitle: 'Profile & information',
			),
			body: SafeArea(
				child: SingleChildScrollView(
					padding: padding,
					child: Align(
						alignment: Alignment.topCenter,
						child: ConstrainedBox(
							constraints: const BoxConstraints(maxWidth: 1120),
							child: listAsync.when(
								data: (items) {
									final mr = items.where((e) => e.id == mrId).firstOrNull;
									if (mr == null) {
										return const _ErrorCard(message: 'MR not found.');
									}

									return Column(
										crossAxisAlignment: CrossAxisAlignment.stretch,
										children: [
											MrHeaderCard(
												photoBytes: mr.photoBytes,
												name: mr.name,
												password: mr.password,
											),
											const SizedBox(height: 14),
											MrHeadquarterCard(
												headquarter: mr.headquarter,
												territories: mr.territories,
											),
											const SizedBox(height: 14),
											MrBankDetailsCard(
												bankName: mr.bankName,
												bankAccountNumber: mr.bankAccountNumber,
												ifscCode: mr.ifscCode,
												upiId: mr.upiId,
												branchName: mr.branchName,
											),
											const SizedBox(height: 14),
											MrContactCard(
												phoneNumber: mr.phoneNumber,
												alternativePhoneNumber: mr.alternativePhoneNumber,
												email: mr.email,
												address: mr.address,
											),
										],
									);
								},
								loading: () => _LoadingCard(theme: theme),
								error: (e, _) => const _ErrorCard(
									message: 'Failed to load MR details.',
								),
							),
						),
					),
				),
			),
		);
	}
}

class _LoadingCard extends StatelessWidget {
	const _LoadingCard({required this.theme});

	final ThemeData theme;

	@override
	Widget build(BuildContext context) {
		final outline = theme.colorScheme.outline.withAlpha(204);

		return Card(
			elevation: 0,
			surfaceTintColor: Colors.transparent,
			color: theme.colorScheme.surface,
			shape: RoundedRectangleBorder(
				borderRadius: BorderRadius.circular(24),
				side: BorderSide(color: outline),
			),
			child: const Padding(
				padding: EdgeInsets.all(18),
				child: Row(
					children: [
						SizedBox(
							width: 18,
							height: 18,
							child: CircularProgressIndicator(strokeWidth: 2),
						),
						SizedBox(width: 12),
						Text('Loading MR...'),
					],
				),
			),
		);
	}
}

class _ErrorCard extends StatelessWidget {
	const _ErrorCard({required this.message});

	final String message;

	@override
	Widget build(BuildContext context) {
		final theme = Theme.of(context);
		final outline = theme.colorScheme.outline.withAlpha(204);

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
				child: Text(
					message,
					style: theme.textTheme.bodyMedium?.copyWith(
						color: theme.colorScheme.error,
						fontWeight: FontWeight.w700,
					),
				),
			),
		);
	}
}

extension FirstOrNullX<T> on Iterable<T> {
	T? get firstOrNull => isEmpty ? null : first;
}

