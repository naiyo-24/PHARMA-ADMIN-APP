import 'package:flutter/material.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../models/order.dart';
import '../../notifiers/order_notifier.dart';
import '../../routes/app_router.dart';
import '../../theme/app_theme.dart';
import '../../widgets/app_bar.dart';

class CreateEditOrderScreen extends ConsumerStatefulWidget {
  const CreateEditOrderScreen({super.key, this.orderId});

  final String? orderId;

  @override
  ConsumerState<CreateEditOrderScreen> createState() =>
      _CreateEditOrderScreenState();
}

class _CreateEditOrderScreenState extends ConsumerState<CreateEditOrderScreen> {
  final _formKey = GlobalKey<FormState>();

  OrderPickedByType _pickedByType = OrderPickedByType.mr;
  OrderStatus _status = OrderStatus.pending;

  final _pickedByNameController = TextEditingController();
  final _pickedByIdController = TextEditingController();
  final _doctorController = TextEditingController();
  final _chemistShopController = TextEditingController();
  final _distributorController = TextEditingController();

  DateTime _expectedDelivery = DateTime.now().add(const Duration(days: 1));
  DateTime? _createdAtOverride;

  final List<_ProductRow> _products = <_ProductRow>[];

  bool _initializedFromExisting = false;

  @override
  void dispose() {
    _pickedByNameController.dispose();
    _pickedByIdController.dispose();
    _doctorController.dispose();
    _chemistShopController.dispose();
    _distributorController.dispose();
    for (final p in _products) {
      p.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final padding = AppLayout.pagePadding(context);
    final isEdit = widget.orderId != null && widget.orderId!.trim().isNotEmpty;
    final listAsync = ref.watch(orderNotifierProvider);
    final theme = Theme.of(context);
    final outline = theme.colorScheme.outline.withAlpha(102);

    return Scaffold(
      appBar: AppAppBar(
        showLogo: false,
        title: isEdit ? 'Edit Order' : 'Create Order',
        subtitle: isEdit
            ? 'Update order details and status'
            : 'Create a new order for delivery',
        showBackIfPossible: true,
        showMenuIfNoBack: false,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: padding,
          child: Align(
            alignment: Alignment.topCenter,
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 860),
              child: listAsync.when(
                data: (items) {
                  final existing = isEdit
                      ? items.firstWhere(
                          (o) => o.id == widget.orderId,
                          orElse: () => Order(
                            id: '',
                            pickedByType: OrderPickedByType.mr,
                            pickedById: '',
                            pickedByName: '',
                            interestedDoctorName: '',
                            products: const <OrderLineItem>[],
                            chemistShopName: '',
                            distributorName: '',
                            expectedDeliveryTime:
                                DateTime.fromMillisecondsSinceEpoch(0),
                            status: OrderStatus.pending,
                            createdAt: DateTime.fromMillisecondsSinceEpoch(0),
                          ),
                        )
                      : null;

                  if (isEdit && (existing == null || existing.id.isEmpty)) {
                    return _ErrorCard(
                      theme: theme,
                      message: 'Order not found.',
                    );
                  }

                  if (!_initializedFromExisting) {
                    _initializedFromExisting = true;
                    if (existing != null) {
                      _pickedByType = existing.pickedByType;
                      _status = existing.status;
                      _pickedByNameController.text = existing.pickedByName;
                      _pickedByIdController.text = existing.pickedById;
                      _doctorController.text = existing.interestedDoctorName;
                      _chemistShopController.text = existing.chemistShopName;
                      _distributorController.text = existing.distributorName;
                      _expectedDelivery = existing.expectedDeliveryTime;
                      _createdAtOverride = existing.createdAt;
                      _products
                        ..clear()
                        ..addAll(
                          existing.products.map(
                            (p) => _ProductRow(
                              name: p.productName,
                              quantity: p.quantity.toString(),
                            ),
                          ),
                        );
                    } else {
                      _products
                        ..clear()
                        ..add(_ProductRow());
                    }
                  }

                  final deliveryLabel = MaterialLocalizations.of(
                    context,
                  ).formatMediumDate(_expectedDelivery);
                  final deliveryTimeLabel = MaterialLocalizations.of(
                    context,
                  ).formatTimeOfDay(TimeOfDay.fromDateTime(_expectedDelivery));

                  return Form(
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
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
                                  'Order info',
                                  style: theme.textTheme.titleMedium?.copyWith(
                                    fontWeight: FontWeight.w900,
                                    letterSpacing: -0.2,
                                  ),
                                ),
                                if (isEdit) ...[
                                  const SizedBox(height: 8),
                                  Text(
                                    'Order ID: ${existing!.id}',
                                    style: theme.textTheme.bodyMedium?.copyWith(
                                      fontWeight: FontWeight.w800,
                                      color: theme.colorScheme.onSurface
                                          .withAlpha(180),
                                    ),
                                  ),
                                ],
                                const SizedBox(height: 12),
                                DropdownButtonFormField<OrderPickedByType>(
                                  initialValue: _pickedByType,
                                  decoration: const InputDecoration(
                                    labelText: 'Picked up by (type)',
                                  ),
                                  items: [
                                    for (final t in OrderPickedByType.values)
                                      DropdownMenuItem<OrderPickedByType>(
                                        value: t,
                                        child: Text(t.label),
                                      ),
                                  ],
                                  onChanged: (v) {
                                    if (v == null) return;
                                    setState(() => _pickedByType = v);
                                  },
                                ),
                                const SizedBox(height: 12),
                                TextFormField(
                                  controller: _pickedByNameController,
                                  decoration: const InputDecoration(
                                    labelText: 'MR/ASM name',
                                  ),
                                  validator: (v) {
                                    final s = (v ?? '').trim();
                                    if (s.isEmpty) return 'Enter a name';
                                    return null;
                                  },
                                ),
                                const SizedBox(height: 12),
                                TextFormField(
                                  controller: _pickedByIdController,
                                  decoration: const InputDecoration(
                                    labelText: 'MR/ASM id (optional)',
                                  ),
                                ),
                                const SizedBox(height: 12),
                                TextFormField(
                                  controller: _doctorController,
                                  decoration: const InputDecoration(
                                    labelText: 'Interested doctor',
                                  ),
                                  validator: (v) {
                                    final s = (v ?? '').trim();
                                    if (s.isEmpty) return 'Enter doctor name';
                                    return null;
                                  },
                                ),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(height: 14),
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
                                Row(
                                  children: [
                                    Expanded(
                                      child: Text(
                                        'Products',
                                        style: theme.textTheme.titleMedium
                                            ?.copyWith(
                                              fontWeight: FontWeight.w900,
                                              letterSpacing: -0.2,
                                            ),
                                      ),
                                    ),
                                    TextButton.icon(
                                      onPressed: () {
                                        setState(
                                          () => _products.add(_ProductRow()),
                                        );
                                      },
                                      icon: const Icon(
                                        Icons.add_rounded,
                                        size: 18,
                                      ),
                                      label: const Text('Add'),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 10),
                                if (_products.isEmpty)
                                  Text(
                                    'No products yet.',
                                    style: theme.textTheme.bodyMedium?.copyWith(
                                      fontWeight: FontWeight.w700,
                                      color: theme.colorScheme.onSurface
                                          .withAlpha(166),
                                    ),
                                  )
                                else
                                  Column(
                                    children: [
                                      for (
                                        int i = 0;
                                        i < _products.length;
                                        i++
                                      ) ...[
                                        _ProductFields(
                                          row: _products[i],
                                          onRemove: _products.length <= 1
                                              ? null
                                              : () {
                                                  final removed = _products
                                                      .removeAt(i);
                                                  removed.dispose();
                                                  setState(() {});
                                                },
                                        ),
                                        const SizedBox(height: 10),
                                      ],
                                    ],
                                  ),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(height: 14),
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
                                  'Delivery details',
                                  style: theme.textTheme.titleMedium?.copyWith(
                                    fontWeight: FontWeight.w900,
                                    letterSpacing: -0.2,
                                  ),
                                ),
                                const SizedBox(height: 12),
                                TextFormField(
                                  controller: _chemistShopController,
                                  decoration: const InputDecoration(
                                    labelText: 'Chemist shop',
                                  ),
                                  validator: (v) {
                                    final s = (v ?? '').trim();
                                    if (s.isEmpty)
                                      return 'Enter chemist shop name';
                                    return null;
                                  },
                                ),
                                const SizedBox(height: 12),
                                TextFormField(
                                  controller: _distributorController,
                                  decoration: const InputDecoration(
                                    labelText: 'Distributor in charge',
                                  ),
                                  validator: (v) {
                                    final s = (v ?? '').trim();
                                    if (s.isEmpty)
                                      return 'Enter distributor name';
                                    return null;
                                  },
                                ),
                                const SizedBox(height: 12),
                                InputDecorator(
                                  decoration: const InputDecoration(
                                    labelText: 'Expected delivery',
                                  ),
                                  child: Row(
                                    children: [
                                      Expanded(
                                        child: Text(
                                          '$deliveryLabel • $deliveryTimeLabel',
                                          style: theme.textTheme.bodyMedium
                                              ?.copyWith(
                                                fontWeight: FontWeight.w800,
                                              ),
                                        ),
                                      ),
                                      TextButton.icon(
                                        onPressed: _pickExpectedDate,
                                        icon: const Icon(
                                          Icons.calendar_month_rounded,
                                          size: 18,
                                        ),
                                        label: const Text('Date'),
                                      ),
                                      TextButton.icon(
                                        onPressed: _pickExpectedTime,
                                        icon: const Icon(
                                          Icons.access_time_rounded,
                                          size: 18,
                                        ),
                                        label: const Text('Time'),
                                      ),
                                    ],
                                  ),
                                ),
                                const SizedBox(height: 12),
                                DropdownButtonFormField<OrderStatus>(
                                  initialValue: _status,
                                  decoration: const InputDecoration(
                                    labelText: 'Status',
                                  ),
                                  items: [
                                    for (final s in OrderStatus.values)
                                      DropdownMenuItem<OrderStatus>(
                                        value: s,
                                        child: Text(s.label),
                                      ),
                                  ],
                                  onChanged: (v) {
                                    if (v == null) return;
                                    setState(() => _status = v);
                                  },
                                ),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(height: 14),
                        Row(
                          children: [
                            TextButton(
                              onPressed: () =>
                                  context.goNamed(AppRoutes.orderManagement),
                              child: const Text('Cancel'),
                            ),
                            const Spacer(),
                            FilledButton(
                              onPressed: _save,
                              child: Text(
                                isEdit ? 'Save changes' : 'Create order',
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 92),
                      ],
                    ),
                  );
                },
                loading: () => _LoadingCard(theme: theme),
                error: (e, _) =>
                    _ErrorCard(theme: theme, message: 'Failed to load orders.'),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _pickExpectedDate() async {
    final now = DateTime.now();
    final picked = await showDatePicker(
      context: context,
      initialDate: _expectedDelivery,
      firstDate: DateTime(now.year - 2, 1, 1),
      lastDate: DateTime(now.year + 5, 12, 31),
    );
    if (picked == null) return;
    setState(() {
      _expectedDelivery = DateTime(
        picked.year,
        picked.month,
        picked.day,
        _expectedDelivery.hour,
        _expectedDelivery.minute,
      );
    });
  }

  Future<void> _pickExpectedTime() async {
    final initial = TimeOfDay.fromDateTime(_expectedDelivery);
    final picked = await showTimePicker(context: context, initialTime: initial);
    if (picked == null) return;
    setState(() {
      _expectedDelivery = DateTime(
        _expectedDelivery.year,
        _expectedDelivery.month,
        _expectedDelivery.day,
        picked.hour,
        picked.minute,
      );
    });
  }

  Future<void> _save() async {
    final form = _formKey.currentState;
    if (form == null) return;
    if (!form.validate()) return;

    final products = _products
        .map((p) {
          final name = p.nameController.text.trim();
          final qty = int.tryParse(p.qtyController.text.trim()) ?? 0;
          if (name.isEmpty || qty <= 0) return null;
          return OrderLineItem(productName: name, quantity: qty);
        })
        .whereType<OrderLineItem>()
        .toList(growable: false);

    if (products.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Add at least one product with quantity.'),
        ),
      );
      return;
    }

    final isEdit = widget.orderId != null && widget.orderId!.trim().isNotEmpty;
    final id = isEdit ? widget.orderId!.trim() : _generateOrderId();

    final now = DateTime.now();
    final order = Order(
      id: id,
      pickedByType: _pickedByType,
      pickedById: _pickedByIdController.text.trim().isEmpty
          ? (_pickedByType == OrderPickedByType.mr ? 'mr_new' : 'asm_new')
          : _pickedByIdController.text.trim(),
      pickedByName: _pickedByNameController.text.trim(),
      interestedDoctorName: _doctorController.text.trim(),
      products: products,
      chemistShopName: _chemistShopController.text.trim(),
      distributorName: _distributorController.text.trim(),
      expectedDeliveryTime: _expectedDelivery,
      status: _status,
      createdAt: (isEdit ? _createdAtOverride : null) ?? now,
    );

    final notifier = ref.read(orderNotifierProvider.notifier);
    await notifier.upsert(order);
    if (!context.mounted) return;
    context.goNamed(AppRoutes.orderManagement);
  }

  String _generateOrderId() {
    final ms = DateTime.now().millisecondsSinceEpoch;
    return 'ord_$ms';
  }
}

class _ProductRow {
  _ProductRow({String? name, String? quantity})
    : nameController = TextEditingController(text: name ?? ''),
      qtyController = TextEditingController(text: quantity ?? '1');

  final TextEditingController nameController;
  final TextEditingController qtyController;

  void dispose() {
    nameController.dispose();
    qtyController.dispose();
  }
}

class _ProductFields extends StatelessWidget {
  const _ProductFields({required this.row, required this.onRemove});

  final _ProductRow row;
  final VoidCallback? onRemove;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          flex: 4,
          child: TextFormField(
            controller: row.nameController,
            decoration: const InputDecoration(labelText: 'Product name'),
            validator: (v) {
              final s = (v ?? '').trim();
              if (s.isEmpty) return 'Required';
              return null;
            },
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          flex: 2,
          child: TextFormField(
            controller: row.qtyController,
            keyboardType: TextInputType.number,
            decoration: const InputDecoration(labelText: 'Qty'),
            validator: (v) {
              final qty = int.tryParse((v ?? '').trim()) ?? 0;
              if (qty <= 0) return 'Invalid';
              return null;
            },
          ),
        ),
        const SizedBox(width: 8),
        IconButton(onPressed: onRemove, icon: const Icon(Icons.close_rounded)),
      ],
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
  const _ErrorCard({required this.theme, required this.message});

  final ThemeData theme;
  final String message;

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
