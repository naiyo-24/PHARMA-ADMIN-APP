
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/attendance.dart';
import '../models/mr_management.dart';
import '../providers/attendance_management_provider.dart';
import 'asm_management_notifier.dart';
import 'mr_management_notifier.dart';

final attendanceManagementNotifierProvider =
		AsyncNotifierProvider<AttendanceManagementNotifier, List<AttendanceRecord>>(
			AttendanceManagementNotifier.new,
		);

class AttendanceManagementNotifier extends AsyncNotifier<List<AttendanceRecord>> {
	late final AttendanceRepository _repo = ref.read(attendanceRepositoryProvider);

	@override
	Future<List<AttendanceRecord>> build() async {
		final mrsAsync = ref.watch(mrManagementNotifierProvider);
		final asmsAsync = ref.watch(asmManagementNotifierProvider);
		final mrs = mrsAsync.asData?.value ?? const <MrManagement>[];
		final asms = asmsAsync.asData?.value ?? const <MrManagement>[];
		final subjects = <AttendanceSubject>[
			for (final m in mrs)
				AttendanceSubject(id: m.id, name: m.name, type: AttendanceSubjectType.mr),
			for (final a in asms)
				AttendanceSubject(id: a.id, name: a.name, type: AttendanceSubjectType.asm),
		];
		await _repo.ensureSeeded(subjects: subjects);
		final all = await _repo.listAll();
		return all..sort((a, b) => b.day.compareTo(a.day));
	}

	Future<void> refresh() async {
		state = const AsyncLoading();
		state = await AsyncValue.guard(build);
	}

	Future<List<AttendanceRecord>> listFor({
		required AttendanceSubjectType subjectType,
		required String subjectId,
	}) {
		return _repo.listFor(subjectType: subjectType, subjectId: subjectId);
	}

	Future<AttendanceRecord?> getForDay({
		required AttendanceSubjectType subjectType,
		required String subjectId,
		required DateTime day,
	}) {
		return _repo.getForDay(
			subjectType: subjectType,
			subjectId: subjectId,
			day: day,
		);
	}

	Future<void> upsert(AttendanceRecord record) async {
		await _repo.upsert(record);
		final current = state.asData?.value ?? const <AttendanceRecord>[];
		final updated = <AttendanceRecord>[...current];
		final index = updated.indexWhere((r) => r.id == record.id);
		if (index >= 0) {
			updated[index] = record;
		} else {
			updated.add(record);
		}
		updated.sort((a, b) => b.day.compareTo(a.day));
		state = AsyncData(List<AttendanceRecord>.unmodifiable(updated));
	}
}

