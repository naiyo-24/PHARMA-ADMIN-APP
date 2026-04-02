
import 'package:flutter/material.dart';

import '../../models/attendance.dart';

class AttendanceFilterCard extends StatelessWidget {
	const AttendanceFilterCard({
		super.key,
		required this.options,
		required this.selected,
		required this.onSelected,
		this.onClear,
	});

	final List<AttendanceSubject> options;
	final AttendanceSubject? selected;
	final ValueChanged<AttendanceSubject> onSelected;
	final VoidCallback? onClear;

	@override
	Widget build(BuildContext context) {
		final theme = Theme.of(context);
		final outline = theme.colorScheme.outline.withAlpha(102);

		return Card(
			color: theme.colorScheme.surface,
			shape: RoundedRectangleBorder(
				borderRadius: BorderRadius.circular(24),
				side: BorderSide(color: outline),
			),
			child: Padding(
				padding: const EdgeInsets.all(16),
				child: Column(
					crossAxisAlignment: CrossAxisAlignment.stretch,
					children: [
						Row(
							children: [
								Icon(
									Icons.filter_alt_rounded,
									color: theme.colorScheme.primary,
								),
								const SizedBox(width: 10),
								Expanded(
									child: Text(
										'Select MR / ASM',
										style: theme.textTheme.titleMedium?.copyWith(
											fontWeight: FontWeight.w900,
											letterSpacing: -0.2,
										),
									),
								),
								if (selected != null && onClear != null)
									IconButton(
										onPressed: onClear,
										tooltip: 'Clear selection',
										icon: const Icon(Icons.close_rounded),
									),
							],
						),
						const SizedBox(height: 12),
						Autocomplete<AttendanceSubject>(
							initialValue: TextEditingValue(
								text: selected == null
										? ''
										: '${selected!.label} • ${selected!.name}',
							),
							displayStringForOption: (o) => '${o.label} • ${o.name}',
							optionsBuilder: (text) {
								final q = text.text.trim().toLowerCase();
								if (q.isEmpty) return const Iterable<AttendanceSubject>.empty();
								return options.where((o) {
									return o.name.toLowerCase().contains(q) ||
										o.label.toLowerCase().contains(q);
								}).take(12);
							},
							onSelected: onSelected,
							fieldViewBuilder: (context, controller, focusNode, onSubmit) {
								return TextField(
									controller: controller,
									focusNode: focusNode,
									decoration: InputDecoration(
										hintText: 'Search MR or ASM by name',
										prefixIcon: const Icon(Icons.search_rounded),
									),
									onSubmitted: (_) => onSubmit(),
								);
							},
							optionsViewBuilder: (context, onSelected, options) {
								return Align(
									alignment: Alignment.topLeft,
									child: Material(
										color: Colors.transparent,
										child: ConstrainedBox(
											constraints: const BoxConstraints(maxWidth: 520, maxHeight: 280),
											child: Card(
												margin: const EdgeInsets.only(top: 8),
												shape: RoundedRectangleBorder(
													borderRadius: BorderRadius.circular(18),
													side: BorderSide(color: outline),
												),
												child: ListView.builder(
													padding: const EdgeInsets.symmetric(vertical: 8),
													itemCount: options.length,
													itemBuilder: (context, index) {
														final o = options.elementAt(index);
														return ListTile(
															dense: true,
															leading: CircleAvatar(
																radius: 18,
																backgroundColor: theme.colorScheme.primary.withAlpha(28),
																child: Text(
																	o.label,
																	style: theme.textTheme.labelLarge?.copyWith(
																		fontWeight: FontWeight.w900,
																	),
																),
															),
															title: Text(
																o.name,
																maxLines: 1,
																overflow: TextOverflow.ellipsis,
															),
															onTap: () => onSelected(o),
														);
												},
											),
										),
									),
								),
                );
							},
						),
						if (selected != null) ...[
							const SizedBox(height: 12),
							Text(
								'Viewing attendance for: ${selected!.label} • ${selected!.name}',
								style: theme.textTheme.bodySmall?.copyWith(
									color: theme.colorScheme.onSurface.withAlpha(170),
									fontWeight: FontWeight.w800,
								),
							),
						],
					],
				),
			),
		);
	}
}

