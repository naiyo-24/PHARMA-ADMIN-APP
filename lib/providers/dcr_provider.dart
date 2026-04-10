
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/dcr.dart';

abstract class DcrRepository {
	Future<List<Dcr>> list();

	Future<Dcr?> findById(String id);

	Future<void> upsert(Dcr dcr);

	Future<void> delete(String id);
}

class InMemoryDcrRepository implements DcrRepository {
	InMemoryDcrRepository();

	final List<Dcr> _items = List<Dcr>.of(<Dcr>[
		Dcr(
			id: 'dcr_1001',
			createdByType: DcrCreatedByType.mr,
			createdById: 'mr_1',
			createdByName: 'Rahul Sharma',
			doctorName: 'Dr. Ananya Bose',
			date: DateTime.now().subtract(const Duration(days: 1, hours: 2)),
			status: DcrStatus.submitted,
			notes: 'Discussed new product launch and dosage guidance. Follow-up requested next week.',
			visualAdsPresented: const ['CardioPlus Poster', 'Seasonal Offer Flyer'],
		),
		Dcr(
			id: 'dcr_1002',
			createdByType: DcrCreatedByType.asm,
			createdById: 'asm_1',
			createdByName: 'Amit Singh',
			doctorName: 'Dr. Rakesh Mehta',
			date: DateTime.now().subtract(const Duration(days: 3, hours: 4)),
			status: DcrStatus.approved,
			notes: 'Reviewed prescription trends and ensured availability with distributor. Positive feedback received.',
			visualAdsPresented: const ['Antibiotic Awareness Deck'],
		),
		Dcr(
			id: 'dcr_1003',
			createdByType: DcrCreatedByType.mr,
			createdById: 'mr_2',
			createdByName: 'Sneha Das',
			doctorName: 'Dr. Priyanka Sen',
			date: DateTime.now().subtract(const Duration(days: 7, hours: 1)),
			status: DcrStatus.draft,
			notes: 'Draft report pending submission. Discussed patient adherence and side-effects management.',
			visualAdsPresented: const [],
		),
		Dcr(
			id: 'dcr_1004',
			createdByType: DcrCreatedByType.asm,
			createdById: 'asm_2',
			createdByName: 'Priya Nair',
			doctorName: 'Dr. Kunal Roy',
			date: DateTime.now().subtract(const Duration(days: 10, hours: 6)),
			status: DcrStatus.rejected,
			notes: 'Insufficient details in the report. Please add more specifics about discussion points.',
			visualAdsPresented: const ['Diabetes Care Leaflet'],
		),
	], growable: true);

	@override
	Future<List<Dcr>> list() async {
		await Future<void>.delayed(const Duration(milliseconds: 220));
		final items = [..._items]
			..sort((a, b) => b.date.compareTo(a.date));
		return List<Dcr>.unmodifiable(items);
	}

	@override
	Future<Dcr?> findById(String id) async {
		await Future<void>.delayed(const Duration(milliseconds: 120));
		try {
			return _items.firstWhere((e) => e.id == id);
		} catch (_) {
			return null;
		}
	}

	@override
	Future<void> upsert(Dcr dcr) async {
		await Future<void>.delayed(const Duration(milliseconds: 180));
		final index = _items.indexWhere((e) => e.id == dcr.id);
		if (index >= 0) {
			_items[index] = dcr;
		} else {
			_items.insert(0, dcr);
		}
	}

	@override
	Future<void> delete(String id) async {
		await Future<void>.delayed(const Duration(milliseconds: 150));
		_items.removeWhere((e) => e.id == id);
	}
}

final dcrRepositoryProvider = Provider<DcrRepository>((ref) {
	return InMemoryDcrRepository();
});
