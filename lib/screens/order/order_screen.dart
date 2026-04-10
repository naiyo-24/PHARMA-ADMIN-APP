import 'package:flutter/material.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../cards/order/order_card.dart';
import '../../cards/order/order_details_bottomsheet.dart';
import '../../cards/order/order_search_filter_bar.dart';
import '../../models/order.dart';
import '../../notifiers/order_notifier.dart';
import '../../routes/app_router.dart';
import '../../theme/app_theme.dart';
import '../../widgets/app_bar.dart';
import '../../widgets/side_nav_bar.dart';

class OrderScreen extends ConsumerStatefulWidget {
  const OrderScreen({super.key});

  @override
  ConsumerState<OrderScreen> createState() => _OrderScreenState();
}

class _OrderScreenState extends ConsumerState<OrderScreen> {
  String _query = '';
  DateTime? _selectedDay;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final padding = AppLayout.pagePadding(context);
    final listAsync = ref.watch(orderNotifierProvider);

    return Scaffold(
      appBar: const AppAppBar(
        showLogo: false,
        showBackIfPossible: false,
        title: 'Order Management',
        subtitle: 'Search, view, and update orders',
        showMenuIfNoBack: true,
      ),
      drawer: SideNavBarDrawer(
        companyName: 'Naiyo24',
        tagline: 'Admin console',
        selectedIndex: SideNavBarDrawer.destinations.indexOf(
          SideNavDestination.orderManagement,
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => context.goNamed(AppRoutes.createOrder),
        icon: const Icon(Icons.add_rounded),
        label: const Text('Create order'),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: padding,
          child: Align(
            alignment: Alignment.topCenter,
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 1120),
              child: listAsync.when(
                data: (items) {
                  final q = _query.trim().toLowerCase();
                  final filtered = items
                      .where((o) {
                        final matchesQuery = q.isEmpty
                            ? true
                            : o.id.toLowerCase().contains(q) ||
                                  o.pickedByName.toLowerCase().contains(q);
                        final matchesDay = _selectedDay == null
                            ? true
                            : _isSameDay(o.createdAt, _selectedDay!);
                        return matchesQuery && matchesDay;
                      })
                      .toList(growable: false);

                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      OrderSearchFilterBar(
                        onQueryChanged: (v) => setState(() => _query = v),
                        selectedDay: _selectedDay,
                        onDayChanged: (v) => setState(() => _selectedDay = v),
                      ),
                      const SizedBox(height: 14),
                      if (items.isEmpty)
                        _EmptyCard(theme: theme)
                      else if (filtered.isEmpty)
                        _EmptyCard(
                          theme: theme,
                          message:
                              'No orders found. Try a different search or date filter.',
                        )
                      else
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            for (final o in filtered) ...[
                              OrderCard(order: o, onTap: () => _openDetails(o)),
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
                    const _ErrorCard(message: 'Failed to load orders.'),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _openDetails(Order order) async {
    await showModalBottomSheet<void>(
      context: context,
      showDragHandle: true,
      isScrollControlled: true,
      builder: (context) => SingleChildScrollView(
        child: OrderDetailsBottomSheet(
          order: order,
          onEdit: () => context.goNamed(
            AppRoutes.editOrder,
            pathParameters: {'orderId': order.id},
          ),
        ),
      ),
    );
  }

  bool _isSameDay(DateTime a, DateTime b) {
    return a.year == b.year && a.month == b.month && a.day == b.day;
  }
}

class _EmptyCard extends StatelessWidget {
  const _EmptyCard({required this.theme, this.message});

  final ThemeData theme;
  final String? message;

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
          message ?? 'No orders found.',
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
            Text('Loading orders...'),
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
