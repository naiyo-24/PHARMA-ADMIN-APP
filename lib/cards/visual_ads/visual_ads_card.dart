import 'dart:typed_data';

import 'package:flutter/material.dart';

class VisualAdsCard extends StatelessWidget {
  const VisualAdsCard({
    super.key,
    required this.imageBytes,
    required this.name,
    required this.onTap,
    required this.onEdit,
    required this.onDelete,
  });

  final Uint8List? imageBytes;
  final String name;
  final VoidCallback onTap;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

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
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(24),
        child: Padding(
          padding: const EdgeInsets.all(14),
          child: Row(
            children: [
              _Thumb(imageBytes: imageBytes),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  name,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: theme.textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.w900,
                    letterSpacing: -0.15,
                  ),
                ),
              ),
              const SizedBox(width: 10),
              IconButton(
                tooltip: 'Edit visual ad',
                onPressed: onEdit,
                icon: Icon(
                  Icons.edit_rounded,
                  color: theme.colorScheme.primary,
                ),
              ),
              IconButton(
                tooltip: 'Delete visual ad',
                onPressed: onDelete,
                icon: Icon(
                  Icons.delete_outline_rounded,
                  color: theme.colorScheme.error,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _Thumb extends StatelessWidget {
  const _Thumb({required this.imageBytes});

  final Uint8List? imageBytes;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final outline = theme.colorScheme.outline.withAlpha(102);

    return Container(
      width: 96,
      height: 64,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: outline),
      ),
      clipBehavior: Clip.antiAlias,
      child: (imageBytes == null)
          ? Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    theme.colorScheme.primary.withAlpha(45),
                    theme.colorScheme.surface,
                  ],
                ),
              ),
              child: Center(
                child: Icon(
                  Icons.image_rounded,
                  color: theme.colorScheme.primary,
                ),
              ),
            )
          : Image.memory(imageBytes!, fit: BoxFit.cover),
    );
  }
}
