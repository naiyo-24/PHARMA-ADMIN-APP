import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/doctor.dart';

abstract class DoctorRepository {
	Future<List<Doctor>> list();

	Future<Doctor?> findById(String id);

	Future<void> upsert(Doctor doctor);

	Future<void> delete(String id);
}

class InMemoryDoctorRepository implements DoctorRepository {
	InMemoryDoctorRepository();

	final List<Doctor> _items = List<Doctor>.of(<Doctor>[
		Doctor(
			id: 'doc_1',
			name: 'Dr. Ananya Sen',
			specialization: 'Cardiology',
			photoPath: '',
			addedByType: DoctorAddedByType.mr,
			addedById: 'mr_1',
			addedByName: 'Rahul Sharma',
			description:
					'Specializes in preventive cardiology and chronic heart failure management. Focus on patient education and lifestyle care.',
			degrees: const ['MBBS', 'MD (Cardiology)'],
			experience: '10+ years clinical experience in tertiary care.',
			chambers: const [
				DoctorChamber(
					name: 'City Heart Clinic',
					phoneNumber: '+91 98765 22220',
					address: 'Salt Lake, Kolkata, West Bengal',
				),
			],
			phoneNumber: '+91 98765 22220',
			email: 'dr.ananya.sen@example.com',
			address: 'Salt Lake, Kolkata, West Bengal',
		),
		Doctor(
			id: 'doc_2',
			name: 'Dr. Vikram Iyer',
			specialization: 'Orthopedics',
			photoPath: 'assets/images/director.jpeg',
			addedByType: DoctorAddedByType.asm,
			addedById: 'asm_2',
			addedByName: 'Priya Nair',
			description:
					'Orthopedic surgeon with interest in sports injuries, minimally invasive procedures, and rehabilitation planning.',
			degrees: const ['MBBS', 'MS (Orthopedics)'],
			experience: '12 years experience across hospitals and private practice.',
			chambers: const [
				DoctorChamber(
					name: 'Andheri Ortho Care',
					phoneNumber: '+91 90000 33331',
					address: 'Andheri West, Mumbai, Maharashtra',
				),
				DoctorChamber(
					name: 'Bandra Sports Rehab',
					phoneNumber: '+91 90000 33332',
					address: 'Bandra, Mumbai, Maharashtra',
				),
			],
			phoneNumber: '+91 90000 33331',
			email: 'dr.vikram.iyer@example.com',
			address: 'Andheri West, Mumbai, Maharashtra',
		),
		Doctor(
			id: 'doc_3',
			name: 'Dr. Meera Kulkarni',
			specialization: 'Dermatology',
			photoPath: '',
			addedByType: DoctorAddedByType.mr,
			addedById: 'mr_2',
			addedByName: 'Sneha Roy',
			description:
					'Dermatologist focusing on acne management, hair & scalp disorders, and patient-friendly treatment plans.',
			degrees: const ['MBBS', 'MD (Dermatology)'],
			experience: '8 years in dermatology clinics and hospital OPD.',
			chambers: const [
				DoctorChamber(
					name: 'Pune Skin Studio',
					phoneNumber: '+91 91234 56781',
					address: 'Hinjewadi, Pune, Maharashtra',
				),
			],
			phoneNumber: '+91 91234 56781',
			email: 'dr.meera.k@example.com',
			address: 'Hinjewadi, Pune, Maharashtra',
		),
	], growable: true);

	@override
	Future<List<Doctor>> list() async {
		await Future<void>.delayed(const Duration(milliseconds: 220));
		final items = [..._items]
			..sort((a, b) => a.name.toLowerCase().compareTo(b.name.toLowerCase()));
		return List<Doctor>.unmodifiable(items);
	}

	@override
	Future<Doctor?> findById(String id) async {
		await Future<void>.delayed(const Duration(milliseconds: 120));
		try {
			return _items.firstWhere((e) => e.id == id);
		} catch (_) {
			return null;
		}
	}

	@override
	Future<void> upsert(Doctor doctor) async {
		await Future<void>.delayed(const Duration(milliseconds: 180));
		final index = _items.indexWhere((e) => e.id == doctor.id);
		if (index >= 0) {
			_items[index] = doctor;
		} else {
			_items.insert(0, doctor);
		}
	}

	@override
	Future<void> delete(String id) async {
		await Future<void>.delayed(const Duration(milliseconds: 150));
		_items.removeWhere((e) => e.id == id);
	}
}

final doctorRepositoryProvider = Provider<DoctorRepository>((ref) {
	return InMemoryDoctorRepository();
});

