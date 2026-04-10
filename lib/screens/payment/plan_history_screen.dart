import 'package:flutter/material.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../models/plans.dart';
import '../../notifiers/payment_notifier.dart';
import '../../routes/app_router.dart';
import '../../theme/app_theme.dart';
import '../../widgets/app_bar.dart';

class PlanHistoryScreen extends ConsumerWidget {
  const PlanHistoryScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final padding = AppLayout.pagePadding(context);
    final asyncState = ref.watch(paymentNotifierProvider);

    return Scaffold(
      appBar: const AppAppBar(
        showLogo: false,
        title: 'Plan History',
        subtitle: 'Your previous plan purchases',
        showBackIfPossible: true,
        showMenuIfNoBack: false,
      ),
      body: SafeArea(
        child: Stack(
          children: [
            SingleChildScrollView(
              padding: padding,
              child: Align(
                alignment: Alignment.topCenter,
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 1120),
                  child: asyncState.when(
                    data: (data) {
                      final purchases = data.purchases;
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          if (purchases.isEmpty)
                            _EmptyCard(theme: theme)
                          else
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: [
                                for (final p in purchases) ...[
                                  _PurchaseCard(theme: theme, purchase: p),
                                  const SizedBox(height: 12),
                                ],
                              ],
                            ),
                          const SizedBox(height: 120),
                        ],
                      );
                    },
                    loading: () => _LoadingCard(theme: theme),
                    error: (e, _) => const _ErrorCard(
                      message: 'Failed to load plan history.',
                    ),
                  ),
                ),
              ),
            ),
            Positioned(
              left: 16,
              right: 16,
              bottom: 16,
              child: SafeArea(
                top: false,
                child: Align(
                  alignment: Alignment.bottomRight,
                  child: FloatingActionButton.extended(
                    onPressed: () => context.pushNamed(AppRoutes.planCatalog),
                    icon: const Icon(Icons.add_rounded),
                    label: const Text('Buy a new plan'),
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

class _PurchaseCard extends StatelessWidget {
  const _PurchaseCard({required this.theme, required this.purchase});

  final ThemeData theme;
  final PlanPurchase purchase;

  @override
  Widget build(BuildContext context) {
    final outline = theme.colorScheme.outline.withAlpha(102);
    final localizations = MaterialLocalizations.of(context);
    final purchasedDate = localizations.formatFullDate(purchase.purchasedAt);
    final validDate = localizations.formatFullDate(purchase.validUntil);

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
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(
                    purchase.planName,
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w900,
                      letterSpacing: -0.2,
                    ),
                  ),
                ),
                _StatusChip(theme: theme, isActive: purchase.isActive),
              ],
            ),
            const SizedBox(height: 10),
            _LabeledRow(
              label: 'Plan amount',
              value: '₹${purchase.amount}',
              theme: theme,
            ),
            const SizedBox(height: 8),
            _LabeledRow(
              label: 'Transaction ID',
              value: purchase.transactionId,
              theme: theme,
            ),
            const SizedBox(height: 8),
            _LabeledRow(
              label: 'Purchased on',
              value: purchasedDate,
              theme: theme,
            ),
            const SizedBox(height: 8),
            _LabeledRow(label: 'Valid until', value: validDate, theme: theme),
          ],
        ),
      ),
    );
  }
}

class _StatusChip extends StatelessWidget {
  const _StatusChip({required this.theme, required this.isActive});

  final ThemeData theme;
  final bool isActive;

  @override
  Widget build(BuildContext context) {
    final bg = isActive
        ? theme.colorScheme.primary.withAlpha(18)
        : theme.colorScheme.surfaceContainerHighest;
    final fg = isActive
        ? theme.colorScheme.primary
        : theme.colorScheme.onSurface.withAlpha(166);
    final outline = isActive
        ? theme.colorScheme.primary.withAlpha(90)
        : theme.colorScheme.outline.withAlpha(102);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(999),
        border: Border.all(color: outline),
      ),
      child: Text(
        isActive ? 'Active' : 'Inactive',
        style: theme.textTheme.labelLarge?.copyWith(
          color: fg,
          fontWeight: FontWeight.w900,
          letterSpacing: 0.2,
        ),
      ),
    );
  }
}

class _LabeledRow extends StatelessWidget {
  const _LabeledRow({
    required this.label,
    required this.value,
    required this.theme,
  });

  final String label;
  final String value;
  final ThemeData theme;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          flex: 4,
          child: Text(
            label,
            style: theme.textTheme.bodyMedium?.copyWith(
              fontWeight: FontWeight.w800,
              color: theme.colorScheme.onSurface.withAlpha(166),
            ),
          ),
        ),
        Expanded(
          flex: 6,
          child: Text(
            value,
            textAlign: TextAlign.right,
            style: theme.textTheme.bodyMedium?.copyWith(
              fontWeight: FontWeight.w900,
            ),
          ),
        ),
      ],
    );
  }
}

class _EmptyCard extends StatelessWidget {
  const _EmptyCard({required this.theme});

  final ThemeData theme;

  @override
  Widget build(BuildContext context) {
    final outline = theme.colorScheme.outline.withAlpha(204);
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
        child: Text(
          'No plan purchases found.',
          style: theme.textTheme.bodyMedium?.copyWith(
            fontWeight: FontWeight.w800,
            color: theme.colorScheme.onSurface.withAlpha(180),
          ),
        ),
      ),
    );
  }
}

class _LoadingCard extends StatelessWidget {
  const _LoadingCard({required this.theme});

  final ThemeData theme;

  @override
  Widget build(BuildContext context) {
    final outline = theme.colorScheme.outline.withAlpha(204);
    return Card(
      elevation: 0,
      surfaceTintColor: Colors.transparent,
      color: theme.colorScheme.surface,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(24),
        side: BorderSide(color: outline),
      ),
      child: const Padding(
        padding: EdgeInsets.all(18),
        child: Row(
          children: [
            SizedBox(
              width: 18,
              height: 18,
              child: CircularProgressIndicator(strokeWidth: 2),
            ),
            SizedBox(width: 12),
            Text('Loading plan history...'),
          ],
        ),
      ),
    );
  }
}

class _ErrorCard extends StatelessWidget {
  const _ErrorCard({required this.message});

  final String message;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final outline = theme.colorScheme.outline.withAlpha(204);
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
        child: Text(
          message,
          style: theme.textTheme.bodyMedium?.copyWith(
            fontWeight: FontWeight.w800,
            color: theme.colorScheme.error,
          ),
        ),
      ),
    );
  }
}
