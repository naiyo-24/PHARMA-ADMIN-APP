import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../notifiers/visual_ads_notifier.dart';

class VisualAdPreviewScreen extends ConsumerStatefulWidget {
  const VisualAdPreviewScreen({super.key, required this.adId});

  final String adId;

  @override
  ConsumerState<VisualAdPreviewScreen> createState() =>
      _VisualAdPreviewScreenState();
}

class _VisualAdPreviewScreenState extends ConsumerState<VisualAdPreviewScreen> {
  @override
  void initState() {
    super.initState();
    unawaited(_enterLandscape());
  }

  @override
  void dispose() {
    unawaited(_restoreOrientation());
    super.dispose();
  }

  Future<void> _enterLandscape() async {
    await SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);
    await SystemChrome.setPreferredOrientations(const [
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.landscapeRight,
    ]);
  }

  Future<void> _restoreOrientation() async {
    await SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
    await SystemChrome.setPreferredOrientations(DeviceOrientation.values);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final adsAsync = ref.watch(visualAdsNotifierProvider);

    final imageBytes = adsAsync.maybeWhen(
      data: (items) {
        for (final ad in items) {
          if (ad.id == widget.adId) return ad.imageBytes;
        }
        return null;
      },
      orElse: () => null,
    );

    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Stack(
          children: [
            Positioned.fill(child: _PreviewBody(imageBytes: imageBytes)),
            Align(
              alignment: Alignment.topRight,
              child: Padding(
                padding: const EdgeInsets.all(10),
                child: IconButton(
                  onPressed: () => Navigator.of(context).maybePop(),
                  icon: const Icon(Icons.close_rounded),
                  color: theme.colorScheme.onSurface,
                  splashRadius: 22,
                  style: IconButton.styleFrom(
                    backgroundColor: Colors.white.withAlpha(26),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _PreviewBody extends StatelessWidget {
  const _PreviewBody({required this.imageBytes});

  final Uint8List? imageBytes;

  @override
  Widget build(BuildContext context) {
    if (imageBytes == null) {
      return const Center(
        child: Text('No image found', style: TextStyle(color: Colors.white)),
      );
    }

    return InteractiveViewer(
      minScale: 0.8,
      maxScale: 4,
      child: Center(child: Image.memory(imageBytes!, fit: BoxFit.contain)),
    );
  }
}
