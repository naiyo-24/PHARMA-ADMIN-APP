import 'dart:typed_data';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';

import '../../models/doctor.dart';
import '../../models/mr_management.dart';
import '../../notifiers/asm_management_notifier.dart';
import '../../notifiers/doctor_notifier.dart';
import '../../notifiers/mr_management_notifier.dart';
import '../../routes/app_router.dart';
import '../../theme/app_theme.dart';
import '../../widgets/app_bar.dart';

class AddEditDoctorScreen extends ConsumerStatefulWidget {
  const AddEditDoctorScreen({super.key, this.doctorId});

  final String? doctorId;

  @override
  ConsumerState<AddEditDoctorScreen> createState() =>
      _AddEditDoctorScreenState();
}

class _AddEditDoctorScreenState extends ConsumerState<AddEditDoctorScreen> {
  final _formKey = GlobalKey<FormState>();

  final _nameCtrl = TextEditingController();
  final _specCtrl = TextEditingController();
  final _photoCtrl = TextEditingController();
  final _descCtrl = TextEditingController();
  final _degreesCtrl = TextEditingController();
  final _experienceCtrl = TextEditingController();
  final _chambersCtrl = TextEditingController();
  final _phoneCtrl = TextEditingController();
  final _emailCtrl = TextEditingController();
  final _addressCtrl = TextEditingController();

  Uint8List? _photoBytes;

  DoctorAddedByType _addedByType = DoctorAddedByType.mr;
  String? _addedById;

  bool _initialized = false;

  @override
  void dispose() {
    _nameCtrl.dispose();
    _specCtrl.dispose();
    _photoCtrl.dispose();
    _descCtrl.dispose();
    _degreesCtrl.dispose();
    _experienceCtrl.dispose();
    _chambersCtrl.dispose();
    _phoneCtrl.dispose();
    _emailCtrl.dispose();
    _addressCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final padding = AppLayout.pagePadding(context);
    final isEdit = widget.doctorId != null;
    final listAsync = ref.watch(doctorNotifierProvider);
    final mrAsync = ref.watch(mrManagementNotifierProvider);
    final asmAsync = ref.watch(asmManagementNotifierProvider);

    Doctor? existing;
    if (isEdit) {
      existing = listAsync.maybeWhen(
        data: (items) {
          try {
            return items.firstWhere((d) => d.id == widget.doctorId);
          } catch (_) {
            return null;
          }
        },
        orElse: () => null,
      );
    }

    if (!_initialized && existing != null) {
      _initialized = true;
      _nameCtrl.text = existing.name;
      _specCtrl.text = existing.specialization;
      _photoCtrl.text = existing.photoPath;
      _photoBytes = existing.photoBytes;
      _descCtrl.text = existing.description;
      _degreesCtrl.text = existing.degrees.join(', ');
      _experienceCtrl.text = existing.experience;
      _chambersCtrl.text = existing.chambers
          .map((c) => '${c.name} | ${c.phoneNumber} | ${c.address}')
          .join('\n');
      _phoneCtrl.text = existing.phoneNumber;
      _emailCtrl.text = existing.email;
      _addressCtrl.text = existing.address;
      _addedByType = existing.addedByType;
      _addedById = existing.addedById;
    }

    final mrItems = mrAsync.maybeWhen(
      data: (items) => items,
      orElse: () => const <MrManagement>[],
    );
    final asmItems = asmAsync.maybeWhen(
      data: (items) => items,
      orElse: () => const <MrManagement>[],
    );

    final addedByOptions = _addedByType == DoctorAddedByType.mr
        ? mrItems
        : asmItems;

    return Scaffold(
      appBar: AppAppBar(
        showLogo: false,
        title: isEdit ? 'Edit Doctor' : 'Add Doctor',
        subtitle: isEdit ? 'Update doctor details' : 'Create a new doctor',
        showMenuIfNoBack: false,
        showBackIfPossible: true,
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
                    _CardSection(
                      title: 'Doctor details',
                      icon: Icons.medical_services_rounded,
                      child: Column(
                        children: [
                          _PhotoPickerCard(
                            photoBytes: _photoBytes,
                            photoPath: _photoCtrl.text.trim(),
                            onPick: _pickPhoto,
                            onRemove: () => setState(() => _photoBytes = null),
                          ),
                          const SizedBox(height: 12),
                          TextFormField(
                            controller: _nameCtrl,
                            validator: (v) {
                              if (v == null || v.trim().isEmpty) {
                                return 'Name is required.';
                              }
                              return null;
                            },
                            decoration: const InputDecoration(
                              labelText: 'Doctor name',
                            ),
                          ),
                          const SizedBox(height: 12),
                          TextFormField(
                            controller: _specCtrl,
                            validator: (v) {
                              if (v == null || v.trim().isEmpty) {
                                return 'Specialization is required.';
                              }
                              return null;
                            },
                            decoration: const InputDecoration(
                              labelText: 'Specialization',
                            ),
                          ),
                          const SizedBox(height: 12),
                          TextFormField(
                            controller: _photoCtrl,
                            decoration: const InputDecoration(
                              labelText: 'Photo URL / asset path (optional)',
                            ),
                          ),
                          const SizedBox(height: 12),
                          DropdownButtonFormField<DoctorAddedByType>(
                            initialValue: _addedByType,
                            decoration: const InputDecoration(
                              labelText: 'Added by',
                            ),
                            items: const [
                              DropdownMenuItem(
                                value: DoctorAddedByType.mr,
                                child: Text('MR'),
                              ),
                              DropdownMenuItem(
                                value: DoctorAddedByType.asm,
                                child: Text('ASM'),
                              ),
                            ],
                            onChanged: (v) {
                              if (v == null) return;
                              setState(() {
                                _addedByType = v;
                                _addedById = null;
                              });
                            },
                          ),
                          const SizedBox(height: 12),
                          DropdownButtonFormField<String>(
                            initialValue: _addedById,
                            decoration: const InputDecoration(
                              labelText: 'Select person',
                            ),
                            items: [
                              for (final p in addedByOptions)
                                DropdownMenuItem<String>(
                                  value: p.id,
                                  child: Text(p.name),
                                ),
                            ],
                            onChanged: (v) => setState(() => _addedById = v),
                            validator: (v) {
                              if (v == null || v.trim().isEmpty) {
                                return 'Select a person.';
                              }
                              return null;
                            },
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 16),
                    _CardSection(
                      title: 'Education',
                      icon: Icons.school_rounded,
                      child: Column(
                        children: [
                          TextFormField(
                            controller: _descCtrl,
                            minLines: 3,
                            maxLines: 6,
                            validator: (v) {
                              if (v == null || v.trim().isEmpty) {
                                return 'Description is required.';
                              }
                              return null;
                            },
                            decoration: const InputDecoration(
                              labelText: 'Detailed description',
                            ),
                          ),
                          const SizedBox(height: 12),
                          TextFormField(
                            controller: _degreesCtrl,
                            validator: (v) {
                              final degrees = _parseCommaList(v ?? '');
                              if (degrees.isEmpty) {
                                return 'Enter at least one degree.';
                              }
                              return null;
                            },
                            decoration: const InputDecoration(
                              labelText: 'Degrees (comma separated)',
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 16),
                    _CardSection(
                      title: 'Experience',
                      icon: Icons.work_history_rounded,
                      child: TextFormField(
                        controller: _experienceCtrl,
                        minLines: 2,
                        maxLines: 5,
                        validator: (v) {
                          if (v == null || v.trim().isEmpty) {
                            return 'Experience is required.';
                          }
                          return null;
                        },
                        decoration: const InputDecoration(
                          labelText: 'Degrees and experience',
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    _CardSection(
                      title: 'Chambers',
                      icon: Icons.apartment_rounded,
                      child: TextFormField(
                        controller: _chambersCtrl,
                        minLines: 3,
                        maxLines: 8,
                        validator: (v) {
                          final chambers = _parseChambers(v ?? '');
                          if (chambers.isEmpty) {
                            return 'Enter at least one chamber.';
                          }
                          return null;
                        },
                        decoration: const InputDecoration(
                          labelText:
                              'Chambers (one per line as: Name | Phone | Address)',
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    _CardSection(
                      title: 'Contact',
                      icon: Icons.contact_phone_rounded,
                      child: Column(
                        children: [
                          TextFormField(
                            controller: _phoneCtrl,
                            validator: (v) {
                              if (v == null || v.trim().isEmpty) {
                                return 'Phone number is required.';
                              }
                              return null;
                            },
                            decoration: const InputDecoration(
                              labelText: 'Phone number',
                            ),
                          ),
                          const SizedBox(height: 12),
                          TextFormField(
                            controller: _emailCtrl,
                            validator: (v) {
                              if (v == null || v.trim().isEmpty) {
                                return 'Email is required.';
                              }
                              return null;
                            },
                            decoration: const InputDecoration(
                              labelText: 'Email',
                            ),
                          ),
                          const SizedBox(height: 12),
                          TextFormField(
                            controller: _addressCtrl,
                            validator: (v) {
                              if (v == null || v.trim().isEmpty) {
                                return 'Address is required.';
                              }
                              return null;
                            },
                            decoration: const InputDecoration(
                              labelText: 'Address',
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 16),
                    Align(
                      alignment: Alignment.centerRight,
                      child: FilledButton.icon(
                        onPressed: listAsync.isLoading ? null : _save,
                        icon: const Icon(Icons.save_rounded),
                        label: Text(isEdit ? 'Save changes' : 'Add doctor'),
                      ),
                    ),
                    const SizedBox(height: 80),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  List<String> _parseCommaList(String input) {
    return input
        .split(',')
        .map((e) => e.trim())
        .where((e) => e.isNotEmpty)
        .toList(growable: false);
  }

  List<DoctorChamber> _parseChambers(String input) {
    final lines = input
        .split('\n')
        .map((e) => e.trim())
        .where((e) => e.isNotEmpty)
        .toList(growable: false);

    DoctorChamber chamberFromLine(String line) {
      final parts = line.split('|').map((e) => e.trim()).toList();
      final name = parts.isNotEmpty ? parts[0] : '';
      final phone = parts.length >= 2 ? parts[1] : '';
      final address = parts.length >= 3 ? parts.sublist(2).join(' | ') : '';
      return DoctorChamber(name: name, phoneNumber: phone, address: address);
    }

    return lines
        .map(chamberFromLine)
        .where((c) => c.name.trim().isNotEmpty)
        .toList(growable: false);
  }

  Future<void> _save() async {
    final ok = _formKey.currentState?.validate() ?? false;
    if (!ok) return;

    final mrList = ref.read(mrManagementNotifierProvider).asData?.value ?? [];
    final asmList = ref.read(asmManagementNotifierProvider).asData?.value ?? [];

    final picked = _addedByType == DoctorAddedByType.mr
        ? mrList
              .where((e) => e.id == _addedById)
              .cast<MrManagement?>()
              .firstOrNull
        : asmList
              .where((e) => e.id == _addedById)
              .cast<MrManagement?>()
              .firstOrNull;

    final id =
        widget.doctorId ??
        'doc_${DateTime.now().millisecondsSinceEpoch.toString()}';

    final degrees = _parseCommaList(_degreesCtrl.text);
    final chambers = _parseChambers(_chambersCtrl.text);

    final doctor = Doctor(
      id: id,
      name: _nameCtrl.text.trim(),
      specialization: _specCtrl.text.trim(),
      photoPath: _photoCtrl.text.trim(),
      photoBytes: _photoBytes,
      addedByType: _addedByType,
      addedById: _addedById ?? '',
      addedByName: picked?.name ?? '',
      description: _descCtrl.text.trim(),
      degrees: degrees,
      experience: _experienceCtrl.text.trim(),
      chambers: chambers,
      phoneNumber: _phoneCtrl.text.trim(),
      email: _emailCtrl.text.trim(),
      address: _addressCtrl.text.trim(),
    );

    await ref.read(doctorNotifierProvider.notifier).upsert(doctor);
    if (!mounted) return;
    context.goNamed(AppRoutes.doctorManagement);
  }

  Future<void> _pickPhoto() async {
    final source = await showModalBottomSheet<_PhotoSource>(
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
                  leading: Icon(
                    Icons.camera_alt_rounded,
                    color: theme.colorScheme.primary,
                  ),
                  title: const Text('Camera'),
                  onTap: () => Navigator.of(context).pop(_PhotoSource.camera),
                ),
                ListTile(
                  leading: Icon(
                    Icons.photo_library_rounded,
                    color: theme.colorScheme.primary,
                  ),
                  title: const Text('Gallery'),
                  onTap: () => Navigator.of(context).pop(_PhotoSource.gallery),
                ),
                ListTile(
                  leading: Icon(
                    Icons.folder_open_rounded,
                    color: theme.colorScheme.primary,
                  ),
                  title: const Text('Files'),
                  onTap: () => Navigator.of(context).pop(_PhotoSource.files),
                ),
              ],
            ),
          ),
        );
      },
    );

    if (source == null) return;

    if (source == _PhotoSource.files) {
      final result = await FilePicker.platform.pickFiles(
        allowMultiple: false,
        type: FileType.image,
        withData: true,
        dialogTitle: 'Select doctor photo',
      );

      final file = result?.files.single;
      final bytes = file?.bytes;
      if (bytes == null) return;
      if (!mounted) return;
      setState(() {
        _photoBytes = bytes;
      });
      return;
    }

    final imageSource = (source == _PhotoSource.camera)
        ? ImageSource.camera
        : ImageSource.gallery;
    final picker = ImagePicker();
    final file = await picker.pickImage(source: imageSource, imageQuality: 88);
    if (file == null) return;
    final bytes = await file.readAsBytes();
    if (!mounted) return;
    setState(() {
      _photoBytes = bytes;
    });
  }
}

class _CardSection extends StatelessWidget {
  const _CardSection({
    required this.title,
    required this.icon,
    required this.child,
  });

  final String title;
  final IconData icon;
  final Widget child;

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
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              children: [
                Icon(icon, color: theme.colorScheme.primary),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    title,
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w900,
                      letterSpacing: -0.2,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            child,
          ],
        ),
      ),
    );
  }
}

extension _FirstOrNullX<T> on Iterable<T> {
  T? get firstOrNull => isEmpty ? null : first;
}

enum _PhotoSource { camera, gallery, files }

class _PhotoPickerCard extends StatelessWidget {
  const _PhotoPickerCard({
    required this.photoBytes,
    required this.photoPath,
    required this.onPick,
    required this.onRemove,
  });

  final Uint8List? photoBytes;
  final String photoPath;
  final VoidCallback onPick;
  final VoidCallback onRemove;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final outline = theme.colorScheme.outline.withAlpha(102);

    Widget preview;
    if (photoBytes != null) {
      preview = Image.memory(photoBytes!, fit: BoxFit.cover);
    } else if (photoPath.trim().isNotEmpty &&
        photoPath.trim().startsWith('assets/')) {
      preview = Image.asset(photoPath.trim(), fit: BoxFit.cover);
    } else if (photoPath.trim().isNotEmpty) {
      preview = Image.network(
        photoPath.trim(),
        fit: BoxFit.cover,
        errorBuilder: (_, _, _) {
          return Center(
            child: Icon(
              Icons.medical_services_rounded,
              color: theme.colorScheme.primary,
              size: 28,
            ),
          );
        },
      );
    } else {
      preview = Center(
        child: Icon(
          Icons.medical_services_rounded,
          color: theme.colorScheme.primary,
          size: 28,
        ),
      );
    }

    return Card(
      elevation: 0,
      surfaceTintColor: Colors.transparent,
      color: theme.colorScheme.surface,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(24),
        side: BorderSide(color: outline),
      ),
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Row(
          children: [
            Container(
              width: 84,
              height: 84,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(22),
                color: theme.colorScheme.primary.withAlpha(10),
                border: Border.all(color: outline),
              ),
              clipBehavior: Clip.antiAlias,
              child: preview,
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Doctor photo',
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w900,
                      letterSpacing: -0.2,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Wrap(
                    spacing: 10,
                    runSpacing: 10,
                    children: [
                      FilledButton.icon(
                        onPressed: onPick,
                        icon: const Icon(Icons.photo_camera_rounded),
                        label: const Text('Change'),
                      ),
                      OutlinedButton.icon(
                        onPressed:
                            (photoBytes == null && photoPath.trim().isEmpty)
                            ? null
                            : onRemove,
                        icon: const Icon(Icons.delete_outline_rounded),
                        label: const Text('Remove'),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
