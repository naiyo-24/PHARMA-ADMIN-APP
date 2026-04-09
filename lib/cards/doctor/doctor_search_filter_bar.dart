import 'package:flutter/material.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';

class DoctorSearchFilterBar extends StatelessWidget {
	const DoctorSearchFilterBar({
		super.key,
		required this.onQueryChanged,
		required this.mrOptions,
		required this.asmOptions,
		required this.selectedMrId,
		required this.selectedAsmId,
		required this.onMrChanged,
		required this.onAsmChanged,
	});

	final ValueChanged<String> onQueryChanged;

	/// Entries are `(id, label)`.
	final List<({String id, String label})> mrOptions;
	final List<({String id, String label})> asmOptions;

	final String? selectedMrId;
	final String? selectedAsmId;

	final ValueChanged<String?> onMrChanged;
	final ValueChanged<String?> onAsmChanged;

	@override
	Widget build(BuildContext context) {
		final theme = Theme.of(context);
		final outline = theme.colorScheme.outline.withAlpha(102);

		DropdownMenuItem<String?> item(String? id, String label) {
			return DropdownMenuItem<String?>(
				value: id,
				child: Text(
					label,
					overflow: TextOverflow.ellipsis,
					style: theme.textTheme.bodyMedium?.copyWith(
						fontWeight: FontWeight.w800,
					),
				),
			);
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
											hintText: 'Search doctors by name or specialization',
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

								final mrDropdown = DropdownButtonFormField<String?>(
									initialValue: selectedMrId,
									decoration: const InputDecoration(
										labelText: 'Filter by MR',
									),
									isExpanded: true,
									items: [
										item(null, 'All MRs'),
										...mrOptions.map((o) => item(o.id, o.label)),
									],
									onChanged: onMrChanged,
								);

								final asmDropdown = DropdownButtonFormField<String?>(
									initialValue: selectedAsmId,
									decoration: const InputDecoration(
										labelText: 'Filter by ASM',
									),
									isExpanded: true,
									items: [
										item(null, 'All ASMs'),
										...asmOptions.map((o) => item(o.id, o.label)),
									],
									onChanged: onAsmChanged,
								);

								if (isNarrow) {
									return Column(
										crossAxisAlignment: CrossAxisAlignment.stretch,
										children: [
											mrDropdown,
											const SizedBox(height: 12),
											asmDropdown,
										],
									);
								}

								return Row(
									children: [
										Expanded(child: mrDropdown),
										const SizedBox(width: 12),
										Expanded(child: asmDropdown),
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

