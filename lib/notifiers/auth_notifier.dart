
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/user.dart';
import '../providers/auth_provider.dart';

final authNotifierProvider = AsyncNotifierProvider<AuthNotifier, User?>(
	AuthNotifier.new,
);

class AuthNotifier extends AsyncNotifier<User?> {
	@override
	Future<User?> build() async {
		return null;
	}

	Future<User> signIn({required String email, required String password}) async {
		final trimmedEmail = email.trim();
		final trimmedPassword = password;

		_validateEmail(trimmedEmail);
		_validatePassword(trimmedPassword);

		state = const AsyncLoading();
		final repo = ref.read(authRepositoryProvider);

		try {
			final user = await repo.signIn(
				email: trimmedEmail,
				password: trimmedPassword,
			);
			state = AsyncData(user);
			return user;
		} catch (e, st) {
			state = AsyncError(e, st);
			rethrow;
		}
	}

	Future<User> signUp({
		required String companyName,
		required String phoneNumber,
		required String email,
		String? gstNumber,
		required String cinNumber,
		required String password,
	}) async {
		_validateNonEmpty(companyName, label: 'Company name');
		_validatePhone(phoneNumber);
		_validateEmail(email);
		_validateNonEmpty(cinNumber, label: 'CIN number');
		_validatePassword(password);

		state = const AsyncLoading();
		final repo = ref.read(authRepositoryProvider);

		try {
			final user = await repo.signUp(
				companyName: companyName,
				phoneNumber: phoneNumber,
				email: email,
				gstNumber: gstNumber,
				cinNumber: cinNumber,
				password: password,
			);
			state = AsyncData(user);
			return user;
		} catch (e, st) {
			state = AsyncError(e, st);
			rethrow;
		}
	}

	void signOut() {
		state = const AsyncData(null);
	}
}

void _validateNonEmpty(String value, {required String label}) {
	if (value.trim().isEmpty) {
		throw AuthException('$label is required.');
	}
}

void _validateEmail(String email) {
	final v = email.trim();
	if (v.isEmpty) throw AuthException('Email is required.');
	final ok = RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$').hasMatch(v);
	if (!ok) throw AuthException('Enter a valid email address.');
}

void _validatePhone(String phone) {
	final v = phone.trim();
	if (v.isEmpty) throw AuthException('Phone number is required.');
	final digits = v.replaceAll(RegExp(r'\D'), '');
	if (digits.length < 10) {
		throw AuthException('Enter a valid phone number.');
	}
}

void _validatePassword(String password) {
	if (password.isEmpty) throw AuthException('Password is required.');
	if (password.length < 6) {
		throw AuthException('Password must be at least 6 characters.');
	}
}

