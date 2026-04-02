import 'package:flutter/material.dart';

class AboutUsHeaderCard extends StatelessWidget {
  const AboutUsHeaderCard({
    super.key,
    required this.companyName,
    required this.tagline,
    this.logoAssetPath,
  });

  final String companyName;
  final String tagline;
  final String? logoAssetPath;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final outline = theme.colorScheme.outline.withAlpha(102);
    final brand = theme.colorScheme.primary;

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
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            _HeaderLogo(logoAssetPath: logoAssetPath),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    companyName,
                    style: theme.textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.w900,
                      letterSpacing: -0.2,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(999),
                      border: Border.all(color: brand.withAlpha(90)),
                      color: brand.withAlpha(18),
                    ),
                    child: Text(
                      tagline,
                      style: theme.textTheme.bodySmall?.copyWith(
                        fontWeight: FontWeight.w800,
                        color: theme.colorScheme.onSurface.withAlpha(204),
                      ),
                    ),
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

class _HeaderLogo extends StatelessWidget {
  const _HeaderLogo({required this.logoAssetPath});

  final String? logoAssetPath;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final outline = theme.colorScheme.outline.withAlpha(102);

    Widget child;
    if (logoAssetPath != null && logoAssetPath!.trim().isNotEmpty) {
      child = Image.asset(
        logoAssetPath!,
        width: 34,
        height: 34,
        fit: BoxFit.contain,
        errorBuilder: (_, _, _) => Icon(
          Icons.local_pharmacy_rounded,
          color: theme.colorScheme.primary,
          size: 26,
        ),
      );
    } else {
      child = Icon(
        Icons.local_pharmacy_rounded,
        color: theme.colorScheme.primary,
        size: 26,
      );
    }

    return Container(
      width: 52,
      height: 52,
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: outline),
      ),
      child: Center(child: child),
    );
  }
}
