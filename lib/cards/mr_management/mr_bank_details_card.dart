import 'package:flutter/material.dart';

class MrBankDetailsCard extends StatelessWidget {
	const MrBankDetailsCard({
		super.key,
		required this.bankName,
		required this.bankAccountNumber,
		required this.ifscCode,
		required this.upiId,
		required this.branchName,
	});

	final String bankName;
	final String bankAccountNumber;
	final String ifscCode;
	final String upiId;
	final String branchName;

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
									Icons.account_balance_rounded,
									color: theme.colorScheme.primary,
								),
								const SizedBox(width: 10),
								Text(
									'Bank details',
									style: theme.textTheme.titleMedium?.copyWith(
										fontWeight: FontWeight.w900,
										letterSpacing: -0.2,
									),
								),
							],
						),
						const SizedBox(height: 12),
						_RowItem(label: 'Bank name', value: bankName),
						const SizedBox(height: 10),
						_RowItem(label: 'Account no', value: bankAccountNumber),
						const SizedBox(height: 10),
						_RowItem(label: 'IFSC code', value: ifscCode),
						const SizedBox(height: 10),
						_RowItem(label: 'UPI ID', value: upiId),
						const SizedBox(height: 10),
						_RowItem(label: 'Branch name', value: branchName),
					],
				),
			),
		);
	}
}

class _RowItem extends StatelessWidget {
	const _RowItem({required this.label, required this.value});

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

