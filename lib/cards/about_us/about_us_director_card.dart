import 'package:flutter/material.dart';

class AboutUsDirectorCard extends StatelessWidget {
  const AboutUsDirectorCard({
    super.key,
    required this.directorName,
    required this.directorMessage,
    this.directorImageAssetPath,
  });

  final String directorName;
  final String directorMessage;
  final String? directorImageAssetPath;

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
                Icon(Icons.verified_rounded, color: theme.colorScheme.primary),
                const SizedBox(width: 10),
                Text(
                  "Director's message",
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w900,
                    letterSpacing: -0.2,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _DirectorAvatar(assetPath: directorImageAssetPath),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        directorName,
                        style: theme.textTheme.titleSmall?.copyWith(
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        directorMessage,
                        style: theme.textTheme.bodyMedium?.copyWith(
                          color: theme.colorScheme.onSurface.withAlpha(204),
                          height: 1.45,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _DirectorAvatar extends StatelessWidget {
  const _DirectorAvatar({required this.assetPath});

  final String? assetPath;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final outline = theme.colorScheme.outline.withAlpha(102);

    Widget child;
    if (assetPath != null && assetPath!.trim().isNotEmpty) {
      child = ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: Image.asset(
          assetPath!,
          width: 72,
          height: 72,
          fit: BoxFit.cover,
          errorBuilder: (_, _, _) => _fallback(theme),
        ),
      );
    } else {
      child = _fallback(theme);
    }

    return Container(
      width: 78,
      height: 78,
      padding: const EdgeInsets.all(3),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: outline),
      ),
      child: child,
    );
  }

  Widget _fallback(ThemeData theme) {
    return Container(
      color: theme.colorScheme.surfaceContainerHighest.withAlpha(120),
      child: Center(
        child: Icon(
          Icons.person_rounded,
          color: theme.colorScheme.primary,
          size: 28,
        ),
      ),
    );
  }
}
