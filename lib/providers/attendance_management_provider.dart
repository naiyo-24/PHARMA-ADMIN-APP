
import 'dart:math' as math;

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/attendance.dart';

abstract class AttendanceRepository {
	Future<void> ensureSeeded({
		required List<AttendanceSubject> subjects,
	});

	Future<List<AttendanceRecord>> listAll();
	Future<List<AttendanceRecord>> listFor({
		required AttendanceSubjectType subjectType,
		required String subjectId,
	});
	Future<AttendanceRecord?> getForDay({
		required AttendanceSubjectType subjectType,
		required String subjectId,
		required DateTime day,
	});
	Future<void> upsert(AttendanceRecord record);
}

class InMemoryAttendanceRepository implements AttendanceRepository {
	InMemoryAttendanceRepository();

	bool _seeded = false;
	final List<AttendanceRecord> _items = <AttendanceRecord>[];

	@override
	Future<void> ensureSeeded({required List<AttendanceSubject> subjects}) async {
		if (_seeded) return;
		if (subjects.isEmpty) return;
		_seeded = true;

		final today = attendanceDayOnly(DateTime.now());
		final daysBack = 70;

		for (final s in subjects) {
			final rng = math.Random(s.id.hashCode);
			final numberOfMarkedDays = math.min(18, math.max(8, subjects.length));
			final chosen = <int>{};
			while (chosen.length < numberOfMarkedDays) {
				chosen.add(rng.nextInt(daysBack));
			}

			for (final offset in chosen) {
				final day = today.subtract(Duration(days: offset));
				final checkInAt = day.add(Duration(hours: 9, minutes: 10 + rng.nextInt(30)));
				final checkOutAt = day.add(Duration(hours: 17, minutes: 10 + rng.nextInt(40)));
				final baseLat = 22.5726 + (rng.nextDouble() - 0.5) * 0.12;
				final baseLng = 88.3639 + (rng.nextDouble() - 0.5) * 0.12;
				final record = AttendanceRecord(
					id: 'att_${s.type.name}_${s.id}_${day.toIso8601String()}',
					subjectType: s.type,
					subjectId: s.id,
					subjectName: s.name,
					day: attendanceDayOnly(day),
					checkIn: AttendanceCheckpoint(
						at: checkInAt,
						location: AttendanceGeoPoint(
							latitude: baseLat,
							longitude: baseLng,
						),
						selfieBytes: null,
					),
					checkOut: AttendanceCheckpoint(
						at: checkOutAt,
						location: AttendanceGeoPoint(
							latitude: baseLat + (rng.nextDouble() - 0.5) * 0.01,
							longitude: baseLng + (rng.nextDouble() - 0.5) * 0.01,
						),
						selfieBytes: null,
					),
				);
				_items.add(record);
			}
		}
	}

	@override
	Future<List<AttendanceRecord>> listAll() async {
		await Future<void>.delayed(const Duration(milliseconds: 220));
		return List<AttendanceRecord>.unmodifiable(_items);
	}

	@override
	Future<List<AttendanceRecord>> listFor({
		required AttendanceSubjectType subjectType,
		required String subjectId,
	}) async {
		await Future<void>.delayed(const Duration(milliseconds: 160));
		return List<AttendanceRecord>.unmodifiable(
			_items.where((r) => r.subjectType == subjectType && r.subjectId == subjectId),
		);
	}

	@override
	Future<AttendanceRecord?> getForDay({
		required AttendanceSubjectType subjectType,
		required String subjectId,
		required DateTime day,
	}) async {
		await Future<void>.delayed(const Duration(milliseconds: 120));
		final d = attendanceDayOnly(day);
		for (final r in _items) {
			if (r.subjectType == subjectType && r.subjectId == subjectId && attendanceDayOnly(r.day) == d) {
				return r;
			}
		}
		return null;
	}

	@override
	Future<void> upsert(AttendanceRecord record) async {
		await Future<void>.delayed(const Duration(milliseconds: 160));
		final index = _items.indexWhere((r) => r.id == record.id);
		if (index >= 0) {
			_items[index] = record;
		} else {
			_items.add(record);
		}
	}
}

final attendanceRepositoryProvider = Provider<AttendanceRepository>((ref) {
	return InMemoryAttendanceRepository();
});

