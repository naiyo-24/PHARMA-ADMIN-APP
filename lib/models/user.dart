
class User {
	const User({
		required this.companyName,
		required this.phoneNumber,
		required this.email,
		required this.cinNumber,
		this.gstNumber,
	});

	final String companyName;
	final String phoneNumber;
	final String email;
	final String cinNumber;
	final String? gstNumber;

	User copyWith({
		String? companyName,
		String? phoneNumber,
		String? email,
		String? cinNumber,
		String? gstNumber,
	}) {
		return User(
			companyName: companyName ?? this.companyName,
			phoneNumber: phoneNumber ?? this.phoneNumber,
			email: email ?? this.email,
			cinNumber: cinNumber ?? this.cinNumber,
			gstNumber: gstNumber ?? this.gstNumber,
		);
	}

	Map<String, Object?> toJson() {
		return {
			'companyName': companyName,
			'phoneNumber': phoneNumber,
			'email': email,
			'cinNumber': cinNumber,
			'gstNumber': gstNumber,
		};
	}

	static User fromJson(Map<String, Object?> json) {
		return User(
			companyName: (json['companyName'] as String?) ?? '',
			phoneNumber: (json['phoneNumber'] as String?) ?? '',
			email: (json['email'] as String?) ?? '',
			cinNumber: (json['cinNumber'] as String?) ?? '',
			gstNumber: json['gstNumber'] as String?,
		);
	}

	@override
	String toString() {
		return 'User(companyName: $companyName, phoneNumber: $phoneNumber, email: $email, cinNumber: $cinNumber, gstNumber: $gstNumber)';
	}

	@override
	bool operator ==(Object other) {
		return other is User &&
				other.companyName == companyName &&
				other.phoneNumber == phoneNumber &&
				other.email == email &&
				other.cinNumber == cinNumber &&
				other.gstNumber == gstNumber;
	}

	@override
	int get hashCode => Object.hash(
				companyName,
				phoneNumber,
				email,
				cinNumber,
				gstNumber,
			);
}

