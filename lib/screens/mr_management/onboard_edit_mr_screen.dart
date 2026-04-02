import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';

import '../../models/mr_management.dart';
import '../../notifiers/mr_management_notifier.dart';
import '../../routes/app_router.dart';
import '../../theme/app_theme.dart';
import '../../widgets/app_bar.dart';

class OnboardEditMrScreen extends ConsumerStatefulWidget {
	const OnboardEditMrScreen({super.key, this.mrId});

	final String? mrId;

	@override
	ConsumerState<OnboardEditMrScreen> createState() => _OnboardEditMrScreenState();
}

class _OnboardEditMrScreenState extends ConsumerState<OnboardEditMrScreen> {
	final _formKey = GlobalKey<FormState>();

	final _nameCtrl = TextEditingController();
	final _passwordCtrl = TextEditingController();
	final _phoneCtrl = TextEditingController();
	final _altPhoneCtrl = TextEditingController();
	final _emailCtrl = TextEditingController();
	final _addressCtrl = TextEditingController();
	final _headquarterCtrl = TextEditingController();
	final _territoriesCtrl = TextEditingController();

	final _bankNameCtrl = TextEditingController();
	final _bankAccCtrl = TextEditingController();
	final _ifscCtrl = TextEditingController();
	final _upiCtrl = TextEditingController();
	final _branchCtrl = TextEditingController();

	Uint8List? _photoBytes;
	bool _initialized = false;

	@override
	void dispose() {
		_nameCtrl.dispose();
		_passwordCtrl.dispose();
		_phoneCtrl.dispose();
		_altPhoneCtrl.dispose();
		_emailCtrl.dispose();
		_addressCtrl.dispose();
		_headquarterCtrl.dispose();
		_territoriesCtrl.dispose();
		_bankNameCtrl.dispose();
		_bankAccCtrl.dispose();
		_ifscCtrl.dispose();
		_upiCtrl.dispose();
		_branchCtrl.dispose();
		super.dispose();
	}

	@override
	Widget build(BuildContext context) {
		Theme.of(context);
		final padding = AppLayout.pagePadding(context);
		final listAsync = ref.watch(mrManagementNotifierProvider);
		final isEdit = widget.mrId != null;

		final existing = listAsync.maybeWhen(
			data: (items) => (widget.mrId == null)
					? null
					: items.where((e) => e.id == widget.mrId).firstOrNull,
			orElse: () => null,
		);

		if (!_initialized && existing != null) {
			_initialized = true;
			_photoBytes = existing.photoBytes;
			_nameCtrl.text = existing.name;
			_passwordCtrl.text = existing.password;
			_phoneCtrl.text = existing.phoneNumber;
			_altPhoneCtrl.text = existing.alternativePhoneNumber ?? '';
			_emailCtrl.text = existing.email ?? '';
			_addressCtrl.text = existing.address ?? '';
			_headquarterCtrl.text = existing.headquarter;
			_territoriesCtrl.text = existing.territories.join(', ');
			_bankNameCtrl.text = existing.bankName;
			_bankAccCtrl.text = existing.bankAccountNumber;
			_ifscCtrl.text = existing.ifscCode;
			_upiCtrl.text = existing.upiId;
			_branchCtrl.text = existing.branchName;
		}

		return Scaffold(
			appBar: AppAppBar(
				showLogo: false,
				showBackIfPossible: true,
				showMenuIfNoBack: false,
				title: isEdit ? 'Edit MR' : 'Onboard MR',
				subtitle: isEdit ? 'Update MR details' : 'Add a new MR',
			),
			body: SafeArea(
				child: SingleChildScrollView(
					padding: padding,
					child: Align(
						alignment: Alignment.topCenter,
						child: ConstrainedBox(
							constraints: const BoxConstraints(maxWidth: 1120),
							child: Form(
								key: _formKey,
								child: Column(
									crossAxisAlignment: CrossAxisAlignment.stretch,
									children: [
										_PhotoPicker(
											photoBytes: _photoBytes,
											onPick: _pickPhoto,
										),
										const SizedBox(height: 14),
										_SectionCard(
											title: 'MR details',
											icon: Icons.badge_rounded,
											children: [
												_field(
													controller: _nameCtrl,
													label: 'MR name',
													validator: _required('MR name'),
												),
												_field(
													controller: _passwordCtrl,
													label: 'Password',
													validator: _required('Password'),
												),
												_field(
													controller: _phoneCtrl,
													label: 'Phone number',
													keyboardType: TextInputType.phone,
													validator: _required('Phone number'),
												),
												_field(
													controller: _altPhoneCtrl,
													label: 'Alternative phone number',
													keyboardType: TextInputType.phone,
												),
												_field(
													controller: _emailCtrl,
													label: 'Email',
													keyboardType: TextInputType.emailAddress,
												),
												_field(
													controller: _addressCtrl,
													label: 'Address',
													maxLines: 2,
												),
											],
										),
										const SizedBox(height: 14),
										_SectionCard(
											title: 'Headquarter',
											icon: Icons.location_city_rounded,
											children: [
												_field(
													controller: _headquarterCtrl,
													label: 'Headquarter',
													validator: _required('Headquarter'),
												),
												_field(
													controller: _territoriesCtrl,
													label: 'Territories (comma-separated)',
													validator: _required('Territories'),
												),
											],
										),
										const SizedBox(height: 14),
										_SectionCard(
											title: 'Bank details',
											icon: Icons.account_balance_rounded,
											children: [
												_field(
													controller: _bankNameCtrl,
													label: 'Bank name',
													validator: _required('Bank name'),
												),
												_field(
													controller: _bankAccCtrl,
													label: 'Bank account number',
													validator: _required('Bank account number'),
												),
												_field(
													controller: _ifscCtrl,
													label: 'IFSC code',
													validator: _required('IFSC code'),
												),
												_field(
													controller: _upiCtrl,
													label: 'UPI ID',
													validator: _required('UPI ID'),
												),
												_field(
													controller: _branchCtrl,
													label: 'Branch name',
													validator: _required('Branch name'),
												),
											],
										),
										const SizedBox(height: 16),
										Align(
											alignment: Alignment.centerRight,
											child: FilledButton.icon(
												onPressed: listAsync.isLoading ? null : _save,
												icon: const Icon(Icons.save_rounded),
												label: Text(isEdit ? 'Save changes' : 'Create MR'),
											),
										),
									],
								),
							),
						),
					),
				),
			),
		);
	}

	FormFieldValidator<String> _required(String label) {
		return (value) {
			if (value == null || value.trim().isEmpty) {
				return '$label is required.';
			}
			return null;
		};
	}

	Widget _field({
		required TextEditingController controller,
		required String label,
		TextInputType? keyboardType,
		int maxLines = 1,
		FormFieldValidator<String>? validator,
	}) {
		return Padding(
			padding: const EdgeInsets.only(bottom: 12),
			child: TextFormField(
				controller: controller,
				keyboardType: keyboardType,
				maxLines: maxLines,
				validator: validator,
				decoration: InputDecoration(
					labelText: label,
				),
			),
		);
	}

	Future<void> _pickPhoto() async {
		final source = await showModalBottomSheet<ImageSource>(
			context: context,
			showDragHandle: true,
			builder: (context) {
				final theme = Theme.of(context);
				return SafeArea(
					child: Padding(
						padding: const EdgeInsets.fromLTRB(12, 6, 12, 12),
						child: Column(
							mainAxisSize: MainAxisSize.min,
							children: [
								ListTile(
									leading: Icon(Icons.camera_alt_rounded,
											color: theme.colorScheme.primary),
									title: const Text('Camera'),
									onTap: () => Navigator.of(context).pop(ImageSource.camera),
								),
								ListTile(
									leading: Icon(Icons.photo_library_rounded,
											color: theme.colorScheme.primary),
									title: const Text('Gallery'),
									onTap: () => Navigator.of(context).pop(ImageSource.gallery),
								),
							],
						),
					),
				);
			},
		);

		if (source == null) return;
		final picker = ImagePicker();
		final file = await picker.pickImage(source: source, imageQuality: 85);
		if (file == null) return;
		final bytes = await file.readAsBytes();
		if (!mounted) return;
		setState(() => _photoBytes = bytes);
	}

	Future<void> _save() async {
		final ok = _formKey.currentState?.validate() ?? false;
		if (!ok) return;

		final territories = _territoriesCtrl.text
				.split(',')
				.map((e) => e.trim())
				.where((e) => e.isNotEmpty)
				.toList();

		final id = widget.mrId ??
				'mr_${DateTime.now().millisecondsSinceEpoch.toString()}';

		final mr = MrManagement(
			id: id,
			name: _nameCtrl.text.trim(),
			password: _passwordCtrl.text.trim(),
			phoneNumber: _phoneCtrl.text.trim(),
			alternativePhoneNumber:
					_altPhoneCtrl.text.trim().isEmpty ? null : _altPhoneCtrl.text.trim(),
			email: _emailCtrl.text.trim().isEmpty ? null : _emailCtrl.text.trim(),
			address:
					_addressCtrl.text.trim().isEmpty ? null : _addressCtrl.text.trim(),
			headquarter: _headquarterCtrl.text.trim(),
			territories: territories,
			bankName: _bankNameCtrl.text.trim(),
			bankAccountNumber: _bankAccCtrl.text.trim(),
			ifscCode: _ifscCtrl.text.trim(),
			upiId: _upiCtrl.text.trim(),
			branchName: _branchCtrl.text.trim(),
			photoBytes: _photoBytes,
		);

		await ref.read(mrManagementNotifierProvider.notifier).upsert(mr);
		if (!mounted) return;
		context.goNamed(AppRoutes.mrManagement);
	}
}

class _PhotoPicker extends StatelessWidget {
	const _PhotoPicker({
		required this.photoBytes,
		required this.onPick,
	});

	final Uint8List? photoBytes;
	final VoidCallback onPick;

	@override
	Widget build(BuildContext context) {
		final theme = Theme.of(context);
		final outline = theme.colorScheme.outline.withAlpha(102);

		return Card(
			elevation: 0,
			surfaceTintColor: Colors.transparent,
			color: theme.colorScheme.surface,
			shape: RoundedRectangleBorder(
				borderRadius: BorderRadius.circular(24),
				side: BorderSide(color: outline),
			),
			child: Padding(
				padding: const EdgeInsets.all(18),
				child: Row(
					children: [
						Container(
							width: 72,
							height: 72,
							padding: const EdgeInsets.all(2),
							decoration: BoxDecoration(
								borderRadius: BorderRadius.circular(22),
								border: Border.all(color: outline),
							),
							child: ClipRRect(
								borderRadius: BorderRadius.circular(20),
								child: (photoBytes == null)
										? Container(
												color: theme.colorScheme.primary.withAlpha(14),
												child: Icon(
													Icons.person_rounded,
													color: theme.colorScheme.primary,
													size: 28,
												),
											)
										: Image.memory(photoBytes!, fit: BoxFit.cover),
							),
						),
						const SizedBox(width: 14),
						Expanded(
							child: Column(
								crossAxisAlignment: CrossAxisAlignment.start,
								children: [
									Text(
										'Profile photo',
										style: theme.textTheme.titleSmall?.copyWith(
											fontWeight: FontWeight.w900,
										),
									),
									const SizedBox(height: 4),
									Text(
										'Upload from camera or gallery',
										style: theme.textTheme.bodySmall?.copyWith(
											color: theme.colorScheme.onSurface.withAlpha(166),
											fontWeight: FontWeight.w800,
										),
									),
								],
							),
						),
						const SizedBox(width: 10),
						FilledButton.icon(
							onPressed: onPick,
							icon: const Icon(Icons.upload_rounded),
							label: const Text('Upload'),
						),
					],
				),
			),
		);
	}
}

class _SectionCard extends StatelessWidget {
	const _SectionCard({
		required this.title,
		required this.icon,
		required this.children,
	});

	final String title;
	final IconData icon;
	final List<Widget> children;

	@override
	Widget build(BuildContext context) {
		final theme = Theme.of(context);
		final outline = theme.colorScheme.outline.withAlpha(102);

		return Card(
			elevation: 0,
			surfaceTintColor: Colors.transparent,
			color: theme.colorScheme.surface,
			shape: RoundedRectangleBorder(
				borderRadius: BorderRadius.circular(24),
				side: BorderSide(color: outline),
			),
			child: Padding(
				padding: const EdgeInsets.all(18),
				child: Column(
					crossAxisAlignment: CrossAxisAlignment.start,
					children: [
						Row(
							children: [
								Icon(icon, color: theme.colorScheme.primary),
								const SizedBox(width: 10),
								Text(
									title,
									style: theme.textTheme.titleMedium?.copyWith(
										fontWeight: FontWeight.w900,
										letterSpacing: -0.2,
									),
								),
							],
						),
						const SizedBox(height: 14),
						...children,
					],
				),
			),
		);
	}
}

extension FirstOrNullX<T> on Iterable<T> {
	T? get firstOrNull => isEmpty ? null : first;
}

