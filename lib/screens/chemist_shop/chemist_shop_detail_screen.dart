import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../cards/chemist_shop/chemist_shop_contact_card.dart';
import '../../cards/chemist_shop/chemist_shop_description_card.dart';
import '../../cards/chemist_shop/chemist_shop_header_card.dart';
import '../../models/chemist_shop.dart';
import '../../notifiers/chemist_shop_notifier.dart';
import '../../theme/app_theme.dart';
import '../../widgets/app_bar.dart';

class ChemistShopDetailScreen extends ConsumerWidget {
  const ChemistShopDetailScreen({super.key, required this.shopId});

  final String shopId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final padding = AppLayout.pagePadding(context);
    final listAsync = ref.watch(chemistShopNotifierProvider);

    return Scaffold(
      appBar: const AppAppBar(
        showLogo: false,
        title: 'Chemist Shop',
        subtitle: 'Details',
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
                  ChemistShop? shop;
                  try {
                    shop = items.firstWhere((s) => s.id == shopId);
                  } catch (_) {
                    shop = null;
                  }

                  if (shop == null) {
                    return const _ErrorCard(message: 'Chemist shop not found.');
                  }

                  final addedBy =
                      'Added by ${shop.addedByType.label}: ${shop.addedByName}';

                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      ChemistShopHeaderCard(
                        photoPath: shop.photoPath,
                        shopName: shop.name,
                        addedByLabel: addedBy,
                      ),
                      const SizedBox(height: 12),
                      ChemistShopDescriptionCard(description: shop.description),
                      const SizedBox(height: 12),
                      ChemistShopContactCard(
                        phoneNumber: shop.phoneNumber,
                        email: shop.email,
                        address: shop.address,
                      ),
                      const SizedBox(height: 92),
                    ],
                  );
                },
                loading: () => _LoadingCard(theme: theme),
                error: (e, _) => const _ErrorCard(
                  message: 'Failed to load chemist shop details.',
                ),
              ),
            ),
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
            Text('Loading details...'),
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
            color: theme.colorScheme.error,
            fontWeight: FontWeight.w800,
          ),
        ),
      ),
    );
  }
}
