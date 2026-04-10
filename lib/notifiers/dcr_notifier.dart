
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/dcr.dart';
import '../providers/dcr_provider.dart';

class DcrNotifier extends AsyncNotifier<List<Dcr>> {
	@override
	Future<List<Dcr>> build() async {
		final repo = ref.read(dcrRepositoryProvider);
		return repo.list();
	}

	Future<void> refreshList() async {
		state = const AsyncLoading();
		final repo = ref.read(dcrRepositoryProvider);
		state = AsyncData(await repo.list());
	}

	Future<Dcr?> findById(String id) {
		final repo = ref.read(dcrRepositoryProvider);
		return repo.findById(id);
	}

	Future<void> upsert(Dcr dcr) async {
		final repo = ref.read(dcrRepositoryProvider);
		await repo.upsert(dcr);
		await refreshList();
	}

	Future<void> delete(String id) async {
		final repo = ref.read(dcrRepositoryProvider);
		await repo.delete(id);
		await refreshList();
	}
}

final dcrNotifierProvider =
		AsyncNotifierProvider<DcrNotifier, List<Dcr>>(DcrNotifier.new);
