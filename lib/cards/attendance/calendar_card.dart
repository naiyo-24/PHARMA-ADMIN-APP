
import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';

class AttendanceCalendarCard extends StatelessWidget {
	const AttendanceCalendarCard({
		super.key,
		required this.focusedDay,
		required this.selectedDay,
		required this.isMarked,
		required this.onDaySelected,
	});

	final DateTime focusedDay;
	final DateTime? selectedDay;
	final bool Function(DateTime day) isMarked;
	final void Function(DateTime selectedDay, DateTime focusedDay) onDaySelected;

	@override
	Widget build(BuildContext context) {
		final theme = Theme.of(context);
		final outline = theme.colorScheme.outline.withAlpha(102);
		final primary = theme.colorScheme.primary;
		final onSurface = theme.colorScheme.onSurface;

		DateTime dayOnly(DateTime d) => DateTime(d.year, d.month, d.day);
		final selected = selectedDay == null ? null : dayOnly(selectedDay!);

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
								Icon(Icons.calendar_month_rounded, color: primary),
								const SizedBox(width: 10),
								Expanded(
									child: Text(
										'Attendance Calendar',
										style: theme.textTheme.titleMedium?.copyWith(
											fontWeight: FontWeight.w900,
											letterSpacing: -0.2,
										),
									),
								),
							],
						),
						const SizedBox(height: 12),
						TableCalendar<void>(
							firstDay: DateTime.utc(2018, 1, 1),
							lastDay: DateTime.utc(2035, 12, 31),
							focusedDay: focusedDay,
							availableGestures: AvailableGestures.horizontalSwipe,
							headerStyle: HeaderStyle(
								titleCentered: true,
								formatButtonVisible: false,
								leftChevronIcon: Icon(
									Icons.chevron_left_rounded,
									color: onSurface.withAlpha(180),
								),
								rightChevronIcon: Icon(
									Icons.chevron_right_rounded,
									color: onSurface.withAlpha(180),
								),
								titleTextStyle: theme.textTheme.titleSmall?.copyWith(
									fontWeight: FontWeight.w900,
									letterSpacing: -0.1,
								) ??
									const TextStyle(fontWeight: FontWeight.w900),
							),
							selectedDayPredicate: (d) => selected != null && dayOnly(d) == selected,
							onDaySelected: onDaySelected,
							eventLoader: (d) => isMarked(d) ? const <void>[null] : const <void>[],
							calendarStyle: CalendarStyle(
								outsideDaysVisible: false,
								todayDecoration: BoxDecoration(
									color: primary.withAlpha(26),
									shape: BoxShape.circle,
								),
								selectedDecoration: BoxDecoration(
									color: primary,
									shape: BoxShape.circle,
								),
								markerDecoration: BoxDecoration(
									color: primary,
									shape: BoxShape.circle,
								),
							),
							calendarBuilders: CalendarBuilders<void>(
								markerBuilder: (context, day, events) {
									if (events.isEmpty) return null;
									return Align(
										alignment: Alignment.bottomCenter,
										child: Padding(
											padding: const EdgeInsets.only(bottom: 5),
											child: Container(
												width: 6,
												height: 6,
												decoration: BoxDecoration(
													color: primary,
													shape: BoxShape.circle,
												),
											),
										),
									);
								},
							),
						),
						const SizedBox(height: 10),
						Row(
							children: [
								Container(
									width: 8,
									height: 8,
									decoration: BoxDecoration(
										color: primary,
										shape: BoxShape.circle,
									),
								),
								const SizedBox(width: 8),
								Expanded(
									child: Text(
										'Dotted dates have both check-in and check-out.',
										style: theme.textTheme.bodySmall?.copyWith(
											color: onSurface.withAlpha(170),
											fontWeight: FontWeight.w800,
										),
									),
								),
							],
						),
					],
				),
			),
		);
	}
}

