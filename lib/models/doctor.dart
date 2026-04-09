import 'dart:typed_data';

enum DoctorAddedByType { mr, asm }

extension DoctorAddedByTypeX on DoctorAddedByType {
	String get label {
		switch (this) {
			case DoctorAddedByType.mr:
				return 'MR';
			case DoctorAddedByType.asm:
				return 'ASM';
		}
	}
}

class DoctorChamber {
	const DoctorChamber({
		required this.name,
		required this.phoneNumber,
		required this.address,
	});

	final String name;
	final String phoneNumber;
	final String address;
}

class Doctor {
	const Doctor({
		required this.id,
		required this.name,
		required this.specialization,
		required this.photoPath,
		this.photoBytes,
		required this.addedByType,
		required this.addedById,
		required this.addedByName,
		required this.description,
		required this.degrees,
		required this.experience,
		required this.chambers,
		required this.phoneNumber,
		required this.email,
		required this.address,
	});

	final String id;

	final String name;
	final String specialization;

	/// Can be an asset path (e.g. `assets/...`) or a network URL.
	final String photoPath;

	/// Used when the admin picks a local photo (camera/gallery/files).
	final Uint8List? photoBytes;

	final DoctorAddedByType addedByType;
	final String addedById;
	final String addedByName;

	final String description;
	final List<String> degrees;
	final String experience;
	final List<DoctorChamber> chambers;

	final String phoneNumber;
	final String email;
	final String address;

	Doctor copyWith({
		String? id,
		String? name,
		String? specialization,
		String? photoPath,
		Uint8List? photoBytes,
		DoctorAddedByType? addedByType,
		String? addedById,
		String? addedByName,
		String? description,
		List<String>? degrees,
		String? experience,
		List<DoctorChamber>? chambers,
		String? phoneNumber,
		String? email,
		String? address,
	}) {
		return Doctor(
			id: id ?? this.id,
			name: name ?? this.name,
			specialization: specialization ?? this.specialization,
			photoPath: photoPath ?? this.photoPath,
			photoBytes: photoBytes ?? this.photoBytes,
			addedByType: addedByType ?? this.addedByType,
			addedById: addedById ?? this.addedById,
			addedByName: addedByName ?? this.addedByName,
			description: description ?? this.description,
			degrees: degrees ?? this.degrees,
			experience: experience ?? this.experience,
			chambers: chambers ?? this.chambers,
			phoneNumber: phoneNumber ?? this.phoneNumber,
			email: email ?? this.email,
			address: address ?? this.address,
		);
	}
}

