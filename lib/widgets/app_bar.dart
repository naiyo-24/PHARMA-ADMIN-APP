import 'package:flutter/material.dart';

class AppAppBar extends StatelessWidget implements PreferredSizeWidget {
  const AppAppBar({
    super.key,
    this.title,
    this.subtitle,
    this.showLogo = true,
    this.logoAssetPath = 'assets/logo/naiyo24_logo.png',
    this.showBackIfPossible = true,
    this.showMenuIfNoBack = true,
    this.onMenuPressed,
    this.actions,
    this.bottom,
    this.height = 72,
  });

  final String? title;
  final String? subtitle;

  final bool showLogo;
  final String? logoAssetPath;

  final bool showBackIfPossible;
  final bool showMenuIfNoBack;
  final VoidCallback? onMenuPressed;

  final List<Widget>? actions;
  final PreferredSizeWidget? bottom;
  final double height;

  @override
  Size get preferredSize {
    final bottomHeight = bottom?.preferredSize.height ?? 0;
    return Size.fromHeight(height + bottomHeight);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final canPop = Navigator.of(context).canPop();
    final outline = theme.colorScheme.outline.withAlpha(102);

    final resolvedTitle = (title == null || title!.trim().isEmpty)
        ? 'Naiyo24'
        : title!.trim();
    final resolvedSubtitle = (subtitle == null || subtitle!.trim().isEmpty)
        ? 'MR Management App'
        : subtitle!.trim();

    return AppBar(
      toolbarHeight: height,
      backgroundColor: theme.colorScheme.surface,
      surfaceTintColor: Colors.transparent,
      elevation: 0,
      scrolledUnderElevation: 0,
      shadowColor: Colors.transparent,
      centerTitle: false,
      titleSpacing: 8,
      leadingWidth: 64,
      actionsIconTheme: IconThemeData(
        color: theme.colorScheme.onSurface.withAlpha(230),
        size: 22,
      ),
      leading: _Leading(
        showLogo: showLogo,
        logoAssetPath: logoAssetPath,
        showBackIfPossible: showBackIfPossible,
        canPop: canPop,
        showMenuIfNoBack: showMenuIfNoBack,
        onMenuPressed: onMenuPressed,
        outline: outline,
      ),
      title: _Title(title: resolvedTitle, subtitle: resolvedSubtitle),
      actions: actions,
      bottom: bottom ?? _AppBarDivider(theme: theme),
    );
  }
}

class _Leading extends StatelessWidget {
  const _Leading({
    required this.showLogo,
    required this.logoAssetPath,
    required this.showBackIfPossible,
    required this.canPop,
    required this.showMenuIfNoBack,
    required this.onMenuPressed,
    required this.outline,
  });

  final bool showLogo;
  final String? logoAssetPath;
  final bool showBackIfPossible;
  final bool canPop;
  final bool showMenuIfNoBack;
  final VoidCallback? onMenuPressed;
  final Color outline;

  @override
  Widget build(BuildContext context) {
    if (showLogo && logoAssetPath != null && logoAssetPath!.trim().isNotEmpty) {
      return Padding(
        padding: const EdgeInsets.only(left: 12),
        child: _LeadingContainer(
          outline: outline,
          child: Image.asset(
            logoAssetPath!,
            width: 34,
            height: 34,
            fit: BoxFit.contain,
            errorBuilder: (context, error, stack) {
              return _fallbackLeading(context);
            },
          ),
        ),
      );
    }

    return _fallbackLeading(context);
  }

  Widget _fallbackLeading(BuildContext context) {
    if (showBackIfPossible && canPop) {
      return Padding(
        padding: const EdgeInsets.only(left: 12),
        child: _LeadingContainer(
          outline: outline,
          child: IconButton(
            tooltip: 'Back',
            constraints: const BoxConstraints.tightFor(width: 44, height: 44),
            padding: EdgeInsets.zero,
            onPressed: () => Navigator.of(context).maybePop(),
            icon: const Icon(Icons.arrow_back_rounded),
          ),
        ),
      );
    }

    if (showMenuIfNoBack) {
      return Padding(
        padding: const EdgeInsets.only(left: 12),
        child: _LeadingContainer(
          outline: outline,
          child: Builder(
            builder: (innerContext) {
              return IconButton(
                tooltip: 'Menu',
                constraints: const BoxConstraints.tightFor(
                  width: 44,
                  height: 44,
                ),
                padding: EdgeInsets.zero,
                onPressed:
                    onMenuPressed ?? () => _openDrawerIfAny(innerContext),
                icon: const Icon(Icons.menu_rounded),
              );
            },
          ),
        ),
      );
    }

    return const SizedBox.shrink();
  }

  void _openDrawerIfAny(BuildContext context) {
    final scaffold = Scaffold.maybeOf(context);
    if (scaffold == null) return;
    if (scaffold.hasDrawer) {
      scaffold.openDrawer();
    }
  }
}

class _LeadingContainer extends StatelessWidget {
  const _LeadingContainer({required this.child, required this.outline});

  final Widget child;
  final Color outline;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Align(
      alignment: Alignment.centerLeft,
      child: Container(
        width: 44,
        height: 44,
        decoration: BoxDecoration(
          color: theme.colorScheme.surfaceContainerHighest,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: outline),
        ),
        child: Center(child: child),
      ),
    );
  }
}

class _Title extends StatelessWidget {
  const _Title({required this.title, required this.subtitle});

  final String title;
  final String subtitle;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    final titleStyle = theme.textTheme.titleLarge?.copyWith(
      fontWeight: FontWeight.w900,
      letterSpacing: -0.2,
    );
    final subtitleStyle = theme.textTheme.bodySmall?.copyWith(
      color: theme.colorScheme.onSurface.withAlpha(166),
      fontWeight: FontWeight.w800,
      letterSpacing: 0.15,
    );

    return Padding(
      padding: const EdgeInsets.only(right: 6),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: titleStyle,
          ),
          const SizedBox(height: 2),
          Text(
            subtitle,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: subtitleStyle,
          ),
        ],
      ),
    );
  }
}

class _AppBarDivider extends StatelessWidget implements PreferredSizeWidget {
  const _AppBarDivider({required this.theme});

  final ThemeData theme;

  @override
  Size get preferredSize => const Size.fromHeight(1);

  @override
  Widget build(BuildContext context) {
    return PreferredSize(
      preferredSize: preferredSize,
      child: Container(
        height: 1,
        color: theme.colorScheme.outline.withAlpha(76),
      ),
    );
  }
}
