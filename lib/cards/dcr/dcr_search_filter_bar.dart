
import 'package:flutter/material.dart';

import 'package:iconsax_flutter/iconsax_flutter.dart';

import '../../models/dcr.dart';

class DcrSearchFilterBar extends StatelessWidget {
	const DcrSearchFilterBar({
		super.key,
		required this.onQueryChanged,
		required this.selectedCreatedByType,
		required this.onCreatedByTypeChanged,
		required this.selectedDay,
		required this.onDayChanged,
	});

	final ValueChanged<String> onQueryChanged;

	/// Null means "All".
	final DcrCreatedByType? selectedCreatedByType;
	final ValueChanged<DcrCreatedByType?> onCreatedByTypeChanged;

	/// Filter by calendar day; null means no date filter.
	final DateTime? selectedDay;
	final ValueChanged<DateTime?> onDayChanged;

	@override
	Widget build(BuildContext context) {
		final theme = Theme.of(context);
		final outline = theme.colorScheme.outline.withAlpha(102);

		DropdownMenuItem<DcrCreatedByType?> item(DcrCreatedByType? value, String label) {
			return DropdownMenuItem<DcrCreatedByType?>(
				value: value,
				child: Text(
					label,
					overflow: TextOverflow.ellipsis,
					style: theme.textTheme.bodyMedium?.copyWith(
						fontWeight: FontWeight.w800,
					),
				),
			);
		}

		final dateLabel = selectedDay == null
				? 'Any date'
				: MaterialLocalizations.of(context).formatMediumDate(selectedDay!);

		Future<void> pickDay() async {
			final now = DateTime.now();
			final initial = selectedDay ?? now;
			final picked = await showDatePicker(
				context: context,
				initialDate: initial,
				firstDate: DateTime(now.year - 5, 1, 1),
				lastDate: DateTime(now.year + 5, 12, 31),
			);
			if (picked == null) return;
			onDayChanged(picked);
		}

		return Card(
			elevation: 0,
			surfaceTintColor: Colors.transparent,
			color: theme.colorScheme.surface,
			shape: RoundedRectangleBorder(
				borderRadius: BorderRadius.circular(24),
				side: BorderSide(color: outline),
			),
			child: Padding(
				padding: const EdgeInsets.fromLTRB(14, 10, 14, 12),
				child: Column(
					children: [
						Row(
							children: [
								Container(
									width: 40,
									height: 40,
									decoration: BoxDecoration(
										borderRadius: BorderRadius.circular(16),
										color: theme.colorScheme.primary.withAlpha(12),
										border: Border.all(color: outline),
									),
									child: Icon(
										Iconsax.search_normal_1,
										color: theme.colorScheme.primary,
										size: 20,
									),
								),
								const SizedBox(width: 12),
								Expanded(
									child: TextField(
										onChanged: onQueryChanged,
										style: theme.textTheme.bodyMedium?.copyWith(
											fontWeight: FontWeight.w700,
										),
										decoration: const InputDecoration(
											isDense: true,
											hintText: 'Search by MR/ASM, doctor name, or DCR id',
											border: InputBorder.none,
											focusedBorder: InputBorder.none,
											enabledBorder: InputBorder.none,
											fillColor: Colors.transparent,
											filled: false,
										),
									),
								),
							],
						),
						const SizedBox(height: 12),
						LayoutBuilder(
							builder: (context, constraints) {
								final isNarrow = constraints.maxWidth < 720;

								final typeDropdown = DropdownButtonFormField<DcrCreatedByType?>(
									initialValue: selectedCreatedByType,
									decoration: const InputDecoration(
										labelText: 'Created by',
									),
									isExpanded: true,
									items: [
										item(null, 'All'),
										item(DcrCreatedByType.mr, 'MR'),
										item(DcrCreatedByType.asm, 'ASM'),
									],
									onChanged: onCreatedByTypeChanged,
								);

								final dateField = InputDecorator(
									decoration: const InputDecoration(
										labelText: 'Date',
									),
									child: Row(
										children: [
											Expanded(
												child: Text(
													dateLabel,
													maxLines: 1,
													overflow: TextOverflow.ellipsis,
													style: theme.textTheme.bodyMedium?.copyWith(
														fontWeight: FontWeight.w800,
													),
												),
											),
											TextButton.icon(
												onPressed: pickDay,
												icon: const Icon(Icons.calendar_month_rounded, size: 18),
												label: const Text('Pick'),
											),
											if (selectedDay != null)
												TextButton(
													onPressed: () => onDayChanged(null),
													child: const Text('Clear'),
												),
										],
									),
								);

								if (isNarrow) {
									return Column(
										crossAxisAlignment: CrossAxisAlignment.stretch,
										children: [
											typeDropdown,
											const SizedBox(height: 12),
											dateField,
										],
									);
								}

								return Row(
									children: [
										Expanded(child: typeDropdown),
										const SizedBox(width: 12),
										Expanded(child: dateField),
									],
								);
							},
						),
					],
				),
			),
		);
	}
}
