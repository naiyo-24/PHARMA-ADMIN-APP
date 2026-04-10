import 'package:flutter/material.dart';

import '../../models/order.dart';

class OrderCard extends StatelessWidget {
  const OrderCard({super.key, required this.order, required this.onTap});

  final Order order;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final outline = theme.colorScheme.outline.withAlpha(102);

    final productSummary = _productSummary(order.products);

    return Card(
      elevation: 0,
      surfaceTintColor: Colors.transparent,
      color: theme.colorScheme.surface,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(24),
        side: BorderSide(color: outline),
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(24),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(14),
          child: Row(
            children: [
              Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16),
                  color: theme.colorScheme.primary.withAlpha(10),
                  border: Border.all(color: outline),
                ),
                child: Icon(
                  Icons.shopping_bag_rounded,
                  color: theme.colorScheme.primary,
                  size: 22,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            '${order.pickedByType.label}: ${order.pickedByName}',
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: theme.textTheme.titleMedium?.copyWith(
                              fontWeight: FontWeight.w900,
                              letterSpacing: -0.2,
                            ),
                          ),
                        ),
                        const SizedBox(width: 10),
                        _StatusChip(status: order.status),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Order ID: ${order.id}',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: theme.colorScheme.onSurface.withAlpha(180),
                        fontWeight: FontWeight.w800,
                        height: 1.15,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      productSummary,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: theme.textTheme.bodyMedium?.copyWith(
                        fontWeight: FontWeight.w700,
                        color: theme.colorScheme.onSurface.withAlpha(204),
                        height: 1.2,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 10),
              Icon(
                Icons.keyboard_arrow_up_rounded,
                size: 18,
                color: theme.colorScheme.onSurface.withAlpha(166),
              ),
            ],
          ),
        ),
      ),
    );
  }

  String _productSummary(List<OrderLineItem> items) {
    if (items.isEmpty) return 'No products';
    final parts = items
        .map((e) => '${e.productName} x${e.quantity}')
        .toList(growable: false);
    if (parts.length <= 2) return parts.join(', ');
    final firstTwo = parts.take(2).join(', ');
    return '$firstTwo, +${parts.length - 2} more';
  }
}

class _StatusChip extends StatelessWidget {
  const _StatusChip({required this.status});

  final OrderStatus status;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    final (bg, fg) = switch (status) {
      OrderStatus.delivered => (
        theme.colorScheme.tertiary.withAlpha(18),
        theme.colorScheme.tertiary,
      ),
      OrderStatus.cancelled => (
        theme.colorScheme.error.withAlpha(18),
        theme.colorScheme.error,
      ),
      OrderStatus.outForDelivery => (
        theme.colorScheme.primary.withAlpha(18),
        theme.colorScheme.primary,
      ),
      OrderStatus.packed => (
        theme.colorScheme.secondary.withAlpha(18),
        theme.colorScheme.secondary,
      ),
      OrderStatus.pending => (
        theme.colorScheme.outline.withAlpha(18),
        theme.colorScheme.onSurface.withAlpha(166),
      ),
    };

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(999),
        border: Border.all(color: fg.withAlpha(76)),
      ),
      child: Text(
        status.label,
        style: theme.textTheme.bodySmall?.copyWith(
          fontWeight: FontWeight.w900,
          letterSpacing: 0.15,
          color: fg,
        ),
      ),
    );
  }
}
