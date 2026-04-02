import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/mr_management.dart';
import '../providers/mr_management_provider.dart';

class MrManagementNotifier extends AsyncNotifier<List<MrManagement>> {
	@override
	Future<List<MrManagement>> build() async {
		final repo = ref.read(mrManagementRepositoryProvider);
		return repo.list();
	}

	Future<void> refreshList() async {
		state = const AsyncLoading();
		final repo = ref.read(mrManagementRepositoryProvider);
		state = AsyncData(await repo.list());
	}

	Future<void> upsert(MrManagement mr) async {
		final repo = ref.read(mrManagementRepositoryProvider);
		await repo.upsert(mr);
		await refreshList();
	}

	Future<void> delete(String id) async {
		final repo = ref.read(mrManagementRepositoryProvider);
		await repo.delete(id);
		await refreshList();
	}
}

final mrManagementNotifierProvider = AsyncNotifierProvider<MrManagementNotifier,
		List<MrManagement>>(MrManagementNotifier.new);

