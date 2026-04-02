import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';

import '../../models/visual_ads.dart';
import '../../notifiers/visual_ads_notifier.dart';
import '../../routes/app_router.dart';
import '../../theme/app_theme.dart';
import '../../widgets/app_bar.dart';

class CreateEditVisualAdsScreen extends ConsumerStatefulWidget {
  const CreateEditVisualAdsScreen({super.key, this.adId});

  final String? adId;

  @override
  ConsumerState<CreateEditVisualAdsScreen> createState() =>
      _CreateEditVisualAdsScreenState();
}

class _CreateEditVisualAdsScreenState
    extends ConsumerState<CreateEditVisualAdsScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameCtrl = TextEditingController();

  Uint8List? _imageBytes;
  bool _initialized = false;

  @override
  void dispose() {
    _nameCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final padding = AppLayout.pagePadding(context);
    final adsAsync = ref.watch(visualAdsNotifierProvider);
    final isEdit = widget.adId != null;

    final existing = adsAsync.maybeWhen(
      data: (items) => (widget.adId == null)
          ? null
          : items.where((e) => e.id == widget.adId).firstOrNull,
      orElse: () => null,
    );

    if (!_initialized && existing != null) {
      _initialized = true;
      _nameCtrl.text = existing.name;
      _imageBytes = existing.imageBytes;
    }

    return Scaffold(
      appBar: AppAppBar(
        showLogo: false,
        showBackIfPossible: true,
        showMenuIfNoBack: false,
        title: isEdit ? 'Edit Visual Ad' : 'Create Visual Ad',
        subtitle: isEdit ? 'Update ad content' : 'Add a new visual ad',
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
                    _ImagePickerCard(
                      imageBytes: _imageBytes,
                      onPick: _pickImage,
                    ),
                    const SizedBox(height: 14),
                    _CardSection(
                      title: 'Ad details',
                      icon: Icons.campaign_rounded,
                      child: TextFormField(
                        controller: _nameCtrl,
                        validator: (v) {
                          if (v == null || v.trim().isEmpty) {
                            return 'Visual ad name is required.';
                          }
                          return null;
                        },
                        decoration: const InputDecoration(
                          labelText: 'Visual ad name',
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    Align(
                      alignment: Alignment.centerRight,
                      child: FilledButton.icon(
                        onPressed: adsAsync.isLoading ? null : _save,
                        icon: const Icon(Icons.save_rounded),
                        label: Text(isEdit ? 'Save changes' : 'Create ad'),
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

  Future<void> _pickImage() async {
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
                  leading: Icon(
                    Icons.camera_alt_rounded,
                    color: theme.colorScheme.primary,
                  ),
                  title: const Text('Camera'),
                  onTap: () => Navigator.of(context).pop(ImageSource.camera),
                ),
                ListTile(
                  leading: Icon(
                    Icons.photo_library_rounded,
                    color: theme.colorScheme.primary,
                  ),
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
    final file = await picker.pickImage(source: source, imageQuality: 90);
    if (file == null) return;
    final bytes = await file.readAsBytes();
    if (!mounted) return;
    setState(() => _imageBytes = bytes);
  }

  Future<void> _save() async {
    final ok = _formKey.currentState?.validate() ?? false;
    if (!ok) return;
    if (_imageBytes == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please upload a visual ad image.')),
      );
      return;
    }

    final id =
        widget.adId ?? 'va_${DateTime.now().millisecondsSinceEpoch.toString()}';
    final ad = VisualAd(
      id: id,
      name: _nameCtrl.text.trim(),
      imageBytes: _imageBytes,
    );

    await ref.read(visualAdsNotifierProvider.notifier).upsert(ad);
    if (!mounted) return;
    context.goNamed(AppRoutes.visualAdsManagement);
  }
}

class _ImagePickerCard extends StatelessWidget {
  const _ImagePickerCard({required this.imageBytes, required this.onPick});

  final Uint8List? imageBytes;
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
              width: 110,
              height: 74,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(18),
                border: Border.all(color: outline),
              ),
              clipBehavior: Clip.antiAlias,
              child: (imageBytes == null)
                  ? Container(
                      color: theme.colorScheme.primary.withAlpha(10),
                      child: Icon(
                        Icons.image_rounded,
                        color: theme.colorScheme.primary,
                      ),
                    )
                  : Image.memory(imageBytes!, fit: BoxFit.cover),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Ad image',
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
            child,
          ],
        ),
      ),
    );
  }
}

extension FirstOrNullX<T> on Iterable<T> {
  T? get firstOrNull => isEmpty ? null : first;
}
