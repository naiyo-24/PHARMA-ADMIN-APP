import 'package:flutter/material.dart';

class ChemistShopHeaderCard extends StatelessWidget {
  const ChemistShopHeaderCard({
    super.key,
    required this.photoPath,
    required this.shopName,
    required this.addedByLabel,
  });

  final String photoPath;
  final String shopName;
  final String addedByLabel;

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
      child: ClipRRect(
        borderRadius: BorderRadius.circular(24),
        child: AspectRatio(
          aspectRatio: 16 / 7,
          child: Stack(
            fit: StackFit.expand,
            children: [
              _Background(photoPath: photoPath),
              DecoratedBox(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.bottomCenter,
                    end: Alignment.topCenter,
                    colors: [
                      theme.colorScheme.surface.withAlpha(235),
                      theme.colorScheme.surface.withAlpha(140),
                      Colors.transparent,
                    ],
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(16),
                child: Align(
                  alignment: Alignment.bottomLeft,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        shopName,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: theme.textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.w900,
                          letterSpacing: -0.3,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        addedByLabel,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: theme.textTheme.bodyMedium?.copyWith(
                          color: theme.colorScheme.onSurface.withAlpha(166),
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _Background extends StatelessWidget {
  const _Background({required this.photoPath});

  final String photoPath;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    if (photoPath.trim().isEmpty) {
      return DecoratedBox(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              theme.colorScheme.primary.withAlpha(18),
              theme.colorScheme.surfaceContainerHighest,
            ],
          ),
        ),
        child: Center(
          child: Icon(
            Icons.storefront_rounded,
            size: 44,
            color: theme.colorScheme.primary.withAlpha(191),
          ),
        ),
      );
    }

    if (photoPath.trim().startsWith('assets/')) {
      return Image.asset(photoPath.trim(), fit: BoxFit.cover);
    }

    return Image.network(
      photoPath.trim(),
      fit: BoxFit.cover,
      errorBuilder: (_, __, ___) {
        return DecoratedBox(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                theme.colorScheme.primary.withAlpha(18),
                theme.colorScheme.surfaceContainerHighest,
              ],
            ),
          ),
          child: Center(
            child: Icon(
              Icons.storefront_rounded,
              size: 44,
              color: theme.colorScheme.primary.withAlpha(191),
            ),
          ),
        );
      },
    );
  }
}
