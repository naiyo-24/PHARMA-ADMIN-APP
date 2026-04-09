import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/doctor.dart';
import '../providers/doctor_provider.dart';

class DoctorNotifier extends AsyncNotifier<List<Doctor>> {
	@override
	Future<List<Doctor>> build() async {
		final repo = ref.read(doctorRepositoryProvider);
		return repo.list();
	}

	Future<void> refreshList() async {
		state = const AsyncLoading();
		final repo = ref.read(doctorRepositoryProvider);
		state = AsyncData(await repo.list());
	}

	Future<Doctor?> findById(String id) {
		final repo = ref.read(doctorRepositoryProvider);
		return repo.findById(id);
	}

	Future<void> upsert(Doctor doctor) async {
		final repo = ref.read(doctorRepositoryProvider);
		await repo.upsert(doctor);
		await refreshList();
	}

	Future<void> delete(String id) async {
		final repo = ref.read(doctorRepositoryProvider);
		await repo.delete(id);
		await refreshList();
	}
}

final doctorNotifierProvider =
		AsyncNotifierProvider<DoctorNotifier, List<Doctor>>(
			DoctorNotifier.new,
		);

