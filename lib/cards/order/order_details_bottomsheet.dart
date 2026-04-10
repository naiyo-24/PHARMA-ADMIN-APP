import 'package:flutter/material.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../models/order.dart';
import '../../notifiers/order_notifier.dart';

class OrderDetailsBottomSheet extends ConsumerStatefulWidget {
  const OrderDetailsBottomSheet({super.key, required this.order, this.onEdit});

  final Order order;
  final VoidCallback? onEdit;

  @override
  ConsumerState<OrderDetailsBottomSheet> createState() =>
      _OrderDetailsBottomSheetState();
}

class _OrderDetailsBottomSheetState
    extends ConsumerState<OrderDetailsBottomSheet> {
  late OrderStatus _selectedStatus;

  @override
  void initState() {
    super.initState();
    _selectedStatus = widget.order.status;
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final outline = theme.colorScheme.outline.withAlpha(102);

    final localizations = MaterialLocalizations.of(context);
    final expectedDate = localizations.formatFullDate(
      widget.order.expectedDeliveryTime,
    );
    final expectedTime = localizations.formatTimeOfDay(
      TimeOfDay.fromDateTime(widget.order.expectedDeliveryTime),
    );

    return SafeArea(
      child: Padding(
        padding: EdgeInsets.only(
          left: 16,
          right: 16,
          top: 12,
          bottom: 16 + MediaQuery.of(context).viewInsets.bottom,
        ),
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 820),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Text(
                      'Order Details',
                      style: theme.textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.w900,
                        letterSpacing: -0.2,
                      ),
                    ),
                  ),
                  _StatusChip(status: widget.order.status),
                ],
              ),
              const SizedBox(height: 12),
              Card(
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
                      _LabeledRow(label: 'Order ID', value: widget.order.id),
                      const SizedBox(height: 10),
                      _LabeledRow(
                        label: 'Picked up by',
                        value:
                            '${widget.order.pickedByType.label}: ${widget.order.pickedByName}',
                      ),
                      const SizedBox(height: 10),
                      _LabeledRow(
                        label: 'Interested doctor',
                        value: widget.order.interestedDoctorName,
                      ),
                      const SizedBox(height: 10),
                      _LabeledRow(
                        label: 'Chemist shop',
                        value: widget.order.chemistShopName,
                      ),
                      const SizedBox(height: 10),
                      _LabeledRow(
                        label: 'Distributor',
                        value: widget.order.distributorName,
                      ),
                      const SizedBox(height: 10),
                      _LabeledRow(
                        label: 'Expected delivery',
                        value: '$expectedDate • $expectedTime',
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 12),
              Card(
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
                      Text(
                        'Products ordered',
                        style: theme.textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.w900,
                          letterSpacing: -0.2,
                        ),
                      ),
                      const SizedBox(height: 8),
                      if (widget.order.products.isEmpty)
                        Text(
                          'No products recorded.',
                          style: theme.textTheme.bodyMedium?.copyWith(
                            fontWeight: FontWeight.w700,
                            color: theme.colorScheme.onSurface.withAlpha(166),
                          ),
                        )
                      else
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            for (final p in widget.order.products) ...[
                              Row(
                                children: [
                                  Expanded(
                                    child: Text(
                                      p.productName,
                                      style: theme.textTheme.bodyMedium
                                          ?.copyWith(
                                            fontWeight: FontWeight.w800,
                                            height: 1.2,
                                          ),
                                    ),
                                  ),
                                  Text(
                                    'x${p.quantity}',
                                    style: theme.textTheme.bodyMedium?.copyWith(
                                      fontWeight: FontWeight.w900,
                                      color: theme.colorScheme.onSurface
                                          .withAlpha(190),
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 8),
                            ],
                          ],
                        ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 12),
              Card(
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
                      Text(
                        'Update status',
                        style: theme.textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.w900,
                          letterSpacing: -0.2,
                        ),
                      ),
                      const SizedBox(height: 10),
                      DropdownButtonFormField<OrderStatus>(
                        initialValue: _selectedStatus,
                        decoration: const InputDecoration(labelText: 'Status'),
                        isExpanded: true,
                        items: [
                          for (final s in OrderStatus.values)
                            DropdownMenuItem<OrderStatus>(
                              value: s,
                              child: Text(
                                s.label,
                                style: theme.textTheme.bodyMedium?.copyWith(
                                  fontWeight: FontWeight.w800,
                                ),
                              ),
                            ),
                        ],
                        onChanged: (v) {
                          if (v == null) return;
                          setState(() => _selectedStatus = v);
                        },
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  TextButton(
                    onPressed: () => Navigator.of(context).maybePop(),
                    child: const Text('Close'),
                  ),
                  if (widget.onEdit != null) ...[
                    const SizedBox(width: 8),
                    TextButton.icon(
                      onPressed: () {
                        Navigator.of(context).maybePop();
                        widget.onEdit?.call();
                      },
                      icon: const Icon(Icons.edit_rounded, size: 18),
                      label: const Text('Edit'),
                    ),
                  ],
                  const Spacer(),
                  FilledButton(
                    onPressed: () async {
                      final notifier = ref.read(orderNotifierProvider.notifier);
                      await notifier.updateStatus(
                        orderId: widget.order.id,
                        status: _selectedStatus,
                      );
                      if (!context.mounted) return;
                      Navigator.of(context).maybePop();
                    },
                    child: const Text('Save'),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _LabeledRow extends StatelessWidget {
  const _LabeledRow({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: 140,
          child: Text(
            label,
            style: theme.textTheme.bodyMedium?.copyWith(
              fontWeight: FontWeight.w900,
              color: theme.colorScheme.onSurface.withAlpha(166),
            ),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Text(
            value,
            style: theme.textTheme.bodyMedium?.copyWith(
              fontWeight: FontWeight.w800,
              color: theme.colorScheme.onSurface.withAlpha(230),
            ),
          ),
        ),
      ],
    );
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
