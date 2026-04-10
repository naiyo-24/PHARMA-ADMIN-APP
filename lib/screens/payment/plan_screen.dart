import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../cards/payment/plan_card.dart';
import '../../models/plans.dart';
import '../../notifiers/payment_notifier.dart';
import '../../routes/app_router.dart';
import '../../theme/app_theme.dart';
import '../../widgets/app_bar.dart';

class PlanScreen extends ConsumerWidget {
  const PlanScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final padding = AppLayout.pagePadding(context);
    final asyncState = ref.watch(paymentNotifierProvider);
    final isBusy = asyncState.isLoading;

    return Scaffold(
      appBar: const AppAppBar(
        showLogo: false,
        title: 'Choose a Plan',
        subtitle: 'Monthly, quarterly, and annual options',
        showBackIfPossible: true,
        showMenuIfNoBack: false,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: padding,
          child: Align(
            alignment: Alignment.topCenter,
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 1120),
              child: asyncState.when(
                data: (data) {
                  final plans = data.plans;
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      if (plans.isEmpty)
                        _EmptyCard(theme: theme)
                      else
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            for (final p in plans) ...[
                              PlanCard(
                                plan: p,
                                isBusy: isBusy,
                                onBuy: () => _buy(context, ref, p),
                              ),
                              const SizedBox(height: 12),
                            ],
                          ],
                        ),
                      const SizedBox(height: 92),
                    ],
                  );
                },
                loading: () => _LoadingCard(theme: theme),
                error: (e, _) =>
                    const _ErrorCard(message: 'Failed to load plans.'),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _buy(BuildContext context, WidgetRef ref, Plan plan) async {
    final notifier = ref.read(paymentNotifierProvider.notifier);
    await notifier.buyPlan(plan);
    if (!context.mounted) return;

    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text('Plan purchased: ${plan.name}')));

    final canPop = Navigator.of(context).canPop();
    if (canPop) {
      context.pop();
    } else {
      context.goNamed(AppRoutes.planHistory);
    }
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
          'No plans available right now.',
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
            Text('Loading plans...'),
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
