
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/user.dart';

abstract interface class AuthRepository {
	Future<User> signUp({
		required String companyName,
		required String phoneNumber,
		required String email,
		required String cinNumber,
		required String password,
		String? gstNumber,
	});

	Future<User> signIn({required String email, required String password});
}

class InMemoryAuthRepository implements AuthRepository {
	final Map<String, ({User user, String password})> _usersByEmail = {};

	@override
	Future<User> signUp({
		required String companyName,
		required String phoneNumber,
		required String email,
		required String cinNumber,
		required String password,
		String? gstNumber,
	}) async {
		await Future<void>.delayed(const Duration(milliseconds: 350));

		final normalizedEmail = email.trim().toLowerCase();
		if (_usersByEmail.containsKey(normalizedEmail)) {
			throw AuthException('An account already exists for this email.');
		}

		final user = User(
			companyName: companyName.trim(),
			phoneNumber: phoneNumber.trim(),
			email: normalizedEmail,
			cinNumber: cinNumber.trim(),
			gstNumber: (gstNumber == null || gstNumber.trim().isEmpty)
					? null
					: gstNumber.trim(),
		);

		_usersByEmail[normalizedEmail] = (user: user, password: password);
		return user;
	}

	@override
	Future<User> signIn({required String email, required String password}) async {
		await Future<void>.delayed(const Duration(milliseconds: 300));

		final normalizedEmail = email.trim().toLowerCase();
		final record = _usersByEmail[normalizedEmail];
		if (record == null) {
			throw AuthException('No account found for this email.');
		}
		if (record.password != password) {
			throw AuthException('Incorrect password.');
		}
		return record.user;
	}
}

final authRepositoryProvider = Provider<AuthRepository>((ref) {
	return InMemoryAuthRepository();
});

class AuthException implements Exception {
	AuthException(this.message);
	final String message;

	@override
	String toString() => 'AuthException: $message';
}

