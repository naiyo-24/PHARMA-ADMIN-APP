import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/mr_management.dart';

abstract class MrManagementRepository {
	Future<List<MrManagement>> list();
	Future<void> upsert(MrManagement mr);
	Future<void> delete(String id);
}

class InMemoryMrManagementRepository implements MrManagementRepository {
	InMemoryMrManagementRepository();

	final List<MrManagement> _items = [
		const MrManagement(
			id: 'mr_1',
			name: 'Rahul Sharma',
			password: 'mr@1234',
			phoneNumber: '+91 90000 11111',
			alternativePhoneNumber: '+91 90000 11112',
			email: 'rahul.sharma@example.com',
			address: '12, MG Road, Mumbai',
			headquarter: 'Mumbai HQ',
			territories: ['Andheri', 'Bandra', 'Dadar'],
			bankName: 'State Bank',
			bankAccountNumber: '1234567890',
			ifscCode: 'SBIN0000123',
			upiId: 'rahul@upi',
			branchName: 'Andheri West',
			photoBytes: null,
		),
		const MrManagement(
			id: 'mr_2',
			name: 'Neha Verma',
			password: 'mr@1234',
			phoneNumber: '+91 90000 22222',
			alternativePhoneNumber: null,
			email: 'neha.verma@example.com',
			address: '45, Park Street, Kolkata',
			headquarter: 'Kolkata HQ',
			territories: ['Park Street', 'Salt Lake'],
			bankName: 'HDFC Bank',
			bankAccountNumber: '5566778899',
			ifscCode: 'HDFC0000456',
			upiId: 'neha@upi',
			branchName: 'Salt Lake',
			photoBytes: null,
		),
	];

	@override
	Future<List<MrManagement>> list() async {
		await Future<void>.delayed(const Duration(milliseconds: 250));
		return List<MrManagement>.unmodifiable(_items);
	}

	@override
	Future<void> upsert(MrManagement mr) async {
		await Future<void>.delayed(const Duration(milliseconds: 180));
		final index = _items.indexWhere((e) => e.id == mr.id);
		if (index >= 0) {
			_items[index] = mr;
		} else {
			_items.insert(0, mr);
		}
	}

	@override
	Future<void> delete(String id) async {
		await Future<void>.delayed(const Duration(milliseconds: 150));
		_items.removeWhere((e) => e.id == id);
	}
}

final mrManagementRepositoryProvider = Provider<MrManagementRepository>((ref) {
	return InMemoryMrManagementRepository();
});

