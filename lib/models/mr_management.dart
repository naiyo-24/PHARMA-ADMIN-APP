import 'dart:typed_data';

class MrManagement {
	const MrManagement({
		required this.id,
		required this.name,
		required this.password,
		required this.phoneNumber,
		this.alternativePhoneNumber,
		this.email,
		this.address,
		required this.headquarter,
		required this.territories,
		required this.bankName,
		required this.bankAccountNumber,
		required this.ifscCode,
		required this.upiId,
		required this.branchName,
		this.photoBytes,
	});

	final String id;

	final String name;
	final String password;

	final String phoneNumber;
	final String? alternativePhoneNumber;
	final String? email;
	final String? address;

	final String headquarter;
	final List<String> territories;

	final String bankName;
	final String bankAccountNumber;
	final String ifscCode;
	final String upiId;
	final String branchName;

	final Uint8List? photoBytes;

	MrManagement copyWith({
		String? id,
		String? name,
		String? password,
		String? phoneNumber,
		String? alternativePhoneNumber,
		String? email,
		String? address,
		String? headquarter,
		List<String>? territories,
		String? bankName,
		String? bankAccountNumber,
		String? ifscCode,
		String? upiId,
		String? branchName,
		Uint8List? photoBytes,
	}) {
		return MrManagement(
			id: id ?? this.id,
			name: name ?? this.name,
			password: password ?? this.password,
			phoneNumber: phoneNumber ?? this.phoneNumber,
			alternativePhoneNumber:
					alternativePhoneNumber ?? this.alternativePhoneNumber,
			email: email ?? this.email,
			address: address ?? this.address,
			headquarter: headquarter ?? this.headquarter,
			territories: territories ?? this.territories,
			bankName: bankName ?? this.bankName,
			bankAccountNumber: bankAccountNumber ?? this.bankAccountNumber,
			ifscCode: ifscCode ?? this.ifscCode,
			upiId: upiId ?? this.upiId,
			branchName: branchName ?? this.branchName,
			photoBytes: photoBytes ?? this.photoBytes,
		);
	}
}

