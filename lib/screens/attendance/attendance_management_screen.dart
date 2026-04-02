
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../cards/attendance/attendance_details_card.dart';
import '../../cards/attendance/calendar_card.dart';
import '../../cards/attendance/download_attendance_sheet_card.dart';
import '../../cards/attendance/filter_card.dart';
import '../../models/attendance.dart';
import '../../notifiers/asm_management_notifier.dart';
import '../../notifiers/attendance_management_notifier.dart';
import '../../notifiers/mr_management_notifier.dart';
import '../../theme/app_theme.dart';
import '../../utils/attendance_export.dart';
import '../../widgets/app_bar.dart';
import '../../widgets/side_nav_bar.dart';

class AttendanceManagementScreen extends ConsumerStatefulWidget {
	const AttendanceManagementScreen({super.key});

	@override
	ConsumerState<AttendanceManagementScreen> createState() =>
			_AttendanceManagementScreenState();
}

class _AttendanceManagementScreenState
		extends ConsumerState<AttendanceManagementScreen> {
	AttendanceSubject? _selectedSubject;
	DateTime _focusedDay = DateTime.now();
	DateTime? _selectedDay;

	@override
	Widget build(BuildContext context) {
		final theme = Theme.of(context);
		final padding = AppLayout.pagePadding(context);
		final mrsAsync = ref.watch(mrManagementNotifierProvider);
		final asmsAsync = ref.watch(asmManagementNotifierProvider);
		final attendanceAsync = ref.watch(attendanceManagementNotifierProvider);

		final mrs = mrsAsync.asData?.value ?? const [];
		final asms = asmsAsync.asData?.value ?? const [];
		final options = <AttendanceSubject>[
			for (final m in mrs)
				AttendanceSubject(id: m.id, name: m.name, type: AttendanceSubjectType.mr),
			for (final a in asms)
				AttendanceSubject(id: a.id, name: a.name, type: AttendanceSubjectType.asm),
		];

		final records = attendanceAsync.asData?.value ?? const <AttendanceRecord>[];
		final selected = _selectedSubject;
		final recordsForSelected = (selected == null)
				? const <AttendanceRecord>[]
				: records
						.where(
							(r) =>
								r.subjectType == selected.type &&
								r.subjectId == selected.id &&
								r.hasCompleteDay,
						)
						.toList();

		final markedDays = <DateTime>{
			for (final r in recordsForSelected) attendanceDayOnly(r.day),
		};

		AttendanceRecord? selectedRecord;
		if (selected != null && _selectedDay != null) {
			final d = attendanceDayOnly(_selectedDay!);
			selectedRecord = recordsForSelected.where((r) => attendanceDayOnly(r.day) == d).firstOrNull;
		}

		return Scaffold(
			appBar: const AppAppBar(
				showLogo: false,
				showBackIfPossible: false,
				title: 'Attendance Records',
				subtitle: 'Search and review daily attendance',
				showMenuIfNoBack: true,
			),
			drawer: SideNavBarDrawer(
				companyName: 'Naiyo24',
				tagline: 'Admin console',
				selectedIndex: SideNavBarDrawer.destinations.indexOf(
					SideNavDestination.attendanceRecords,
				),
			),
			floatingActionButton: _DownloadFab(
				onPressed: options.isEmpty ? null : () => _openDownloadSheet(options),
			),
			body: SafeArea(
				child: SingleChildScrollView(
					padding: padding,
					child: Align(
						alignment: Alignment.topCenter,
						child: ConstrainedBox(
							constraints: const BoxConstraints(maxWidth: 1120),
							child: Column(
								crossAxisAlignment: CrossAxisAlignment.stretch,
								children: [
									AttendanceFilterCard(
										options: options,
										selected: _selectedSubject,
										onSelected: (s) {
											setState(() {
												_selectedSubject = s;
												_selectedDay = null;
												_focusedDay = DateTime.now();
											});
										},
										onClear: () {
											setState(() {
												_selectedSubject = null;
												_selectedDay = null;
											});
										},
									),
									const SizedBox(height: 14),
									if (selected == null)
										_CalendarPlaceholderCard(theme: theme)
									else
										AttendanceCalendarCard(
											focusedDay: _focusedDay,
											selectedDay: _selectedDay,
											isMarked: (day) => markedDays.contains(attendanceDayOnly(day)),
											onDaySelected: (sel, foc) {
												setState(() {
													_selectedDay = sel;
													_focusedDay = foc;
												});
											},
										),
									const SizedBox(height: 14),
									AttendanceDetailsCard(
										subject: selected,
										day: _selectedDay,
										record: selectedRecord,
									),
									const SizedBox(height: 92),
								],
							),
						),
					),
				),
			),
		);
	}

	Future<void> _openDownloadSheet(List<AttendanceSubject> options) async {
		await showModalBottomSheet<void>(
			context: context,
			showDragHandle: true,
			isScrollControlled: true,
			builder: (context) {
				return DownloadAttendanceSheetCard(
					options: options,
					initialSelection: _selectedSubject,
					onDownload: ({required subject, required month, required year}) async {
						final all = ref.read(attendanceManagementNotifierProvider).asData?.value ?? const <AttendanceRecord>[];
						final filtered = all.where((r) {
							if (r.subjectType != subject.type || r.subjectId != subject.id) return false;
							return r.day.year == year && r.day.month == month;
						}).toList()
							..sort((a, b) => a.day.compareTo(b.day));

						final csv = _toCsv(subject: subject, records: filtered);
						final fileName = _exportFileName(subject: subject, month: month, year: year);
						final result = await exportAttendanceCsv(fileName: fileName, csv: csv);
						if (!mounted) return;
						final msg = (result.path == null)
								? 'Downloading $fileName'
								: 'Saved to ${result.path}';
						ScaffoldMessenger.of(this.context).showSnackBar(SnackBar(content: Text(msg)));
					},
				);
			},
		);
	}
}

class _DownloadFab extends StatelessWidget {
	const _DownloadFab({required this.onPressed});

	final VoidCallback? onPressed;

	@override
	Widget build(BuildContext context) {
		return FloatingActionButton.extended(
			onPressed: onPressed,
			icon: const Icon(Icons.download_rounded),
			label: const Column(
				mainAxisSize: MainAxisSize.min,
				crossAxisAlignment: CrossAxisAlignment.start,
				children: [
					Text('Download'),
					Text('Attendance Sheet'),
				],
			),
		);
	}
}

class _CalendarPlaceholderCard extends StatelessWidget {
	const _CalendarPlaceholderCard({required this.theme});

	final ThemeData theme;

	@override
	Widget build(BuildContext context) {
		final outline = theme.colorScheme.outline.withAlpha(102);
		return Card(
			color: theme.colorScheme.surface,
			shape: RoundedRectangleBorder(
				borderRadius: BorderRadius.circular(24),
				side: BorderSide(color: outline),
			),
			child: Padding(
				padding: const EdgeInsets.all(16),
				child: Text(
					'Select an MR/ASM to view the attendance calendar.',
					style: theme.textTheme.bodyMedium?.copyWith(
						fontWeight: FontWeight.w800,
						color: theme.colorScheme.onSurface.withAlpha(180),
					),
				),
			),
		);
	}
}

String _exportFileName({
	required AttendanceSubject subject,
	required int month,
	required int year,
}) {
	final safeName = subject.name
			.trim()
			.replaceAll(RegExp(r'[^A-Za-z0-9._-]'), '_')
			.replaceAll(RegExp(r'_+'), '_');
	return 'attendance_${subject.label.toLowerCase()}_${safeName}_${year}_${month.toString().padLeft(2, '0')}.csv';
}

String _toCsv({required AttendanceSubject subject, required List<AttendanceRecord> records}) {
	final buffer = StringBuffer();
	buffer.writeln('Role,Name,Date,CheckInTime,CheckInLat,CheckInLng,CheckOutTime,CheckOutLat,CheckOutLng');

	String esc(String v) {
		final needs = v.contains(',') || v.contains('"') || v.contains('\n') || v.contains('\r');
		if (!needs) return v;
		return '"${v.replaceAll('"', '""')}"';
	}

	String fmtDate(DateTime d) => '${d.year}-${d.month.toString().padLeft(2, '0')}-${d.day.toString().padLeft(2, '0')}';
	String fmtTime(DateTime? d) {
		if (d == null) return '';
		final hh = d.hour.toString().padLeft(2, '0');
		final mm = d.minute.toString().padLeft(2, '0');
		return '$hh:$mm';
	}

	for (final r in records) {
		final ci = r.checkIn;
		final co = r.checkOut;
		buffer.writeln([
			esc(subject.label),
			esc(subject.name),
			esc(fmtDate(r.day)),
			esc(fmtTime(ci?.at)),
			esc(ci == null ? '' : ci.location.latitude.toStringAsFixed(6)),
			esc(ci == null ? '' : ci.location.longitude.toStringAsFixed(6)),
			esc(fmtTime(co?.at)),
			esc(co == null ? '' : co.location.latitude.toStringAsFixed(6)),
			esc(co == null ? '' : co.location.longitude.toStringAsFixed(6)),
		].join(','));
	}

	if (records.isEmpty) {
		buffer.writeln('${subject.label},${esc(subject.name)},(no records),,,,,,');
	}

	return buffer.toString();
}

extension _FirstOrNullX<T> on Iterable<T> {
	T? get firstOrNull => isEmpty ? null : first;
}

