import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/plans.dart';

abstract class PaymentRepository {
  Future<List<Plan>> getPlans();
  Future<List<PlanPurchase>> getPurchaseHistory();
  Future<PlanPurchase> buyPlan(Plan plan);
}

final paymentRepositoryProvider = Provider<PaymentRepository>((ref) {
  return InMemoryPaymentRepository();
});

class InMemoryPaymentRepository implements PaymentRepository {
  InMemoryPaymentRepository() {
    final now = DateTime.now();

    _plans = const <Plan>[
      Plan(
        id: 'plan_monthly',
        name: 'Monthly Plan',
        billingCycle: PlanBillingCycle.monthly,
        amount: 1999,
        maxUsers: 5,
        benefits: <String>[
          'Quick setup for small teams',
          'Order, DCR, doctor, and trip modules',
          'Basic analytics and reporting',
        ],
        advantages: <String>[
          'Best for trial and short-term needs',
          'Upgrade anytime',
        ],
      ),
      Plan(
        id: 'plan_quarterly',
        name: 'Quarterly Plan',
        billingCycle: PlanBillingCycle.quarterly,
        amount: 5499,
        maxUsers: 15,
        benefits: <String>[
          'Team access with higher user limit',
          'Priority support',
          'Enhanced reporting',
        ],
        advantages: <String>[
          'Lower effective monthly cost',
          'Good for growing teams',
        ],
      ),
      Plan(
        id: 'plan_annual',
        name: 'Annual Plan',
        billingCycle: PlanBillingCycle.annual,
        amount: 19999,
        maxUsers: 50,
        benefits: <String>[
          'Highest user limit',
          'Dedicated account support',
          'Full reporting suite',
        ],
        advantages: <String>['Best overall value', 'Stable long-term pricing'],
      ),
    ];

    _purchases = <PlanPurchase>[
      PlanPurchase(
        transactionId: 'txn_1700000000000',
        planId: 'plan_quarterly',
        planName: 'Quarterly Plan',
        amount: 5499,
        purchasedAt: now.subtract(const Duration(days: 140)),
        validUntil: now.subtract(const Duration(days: 50)),
        isActive: false,
      ),
      PlanPurchase(
        transactionId: 'txn_1710000000000',
        planId: 'plan_monthly',
        planName: 'Monthly Plan',
        amount: 1999,
        purchasedAt: now.subtract(const Duration(days: 25)),
        validUntil: now.add(const Duration(days: 5)),
        isActive: true,
      ),
    ];
  }

  late final List<Plan> _plans;
  late final List<PlanPurchase> _purchases;

  @override
  Future<List<Plan>> getPlans() async {
    await Future<void>.delayed(const Duration(milliseconds: 250));
    return List<Plan>.unmodifiable(_plans);
  }

  @override
  Future<List<PlanPurchase>> getPurchaseHistory() async {
    await Future<void>.delayed(const Duration(milliseconds: 250));
    final items = _purchases.toList(growable: false);
    items.sort((a, b) => b.purchasedAt.compareTo(a.purchasedAt));
    return List<PlanPurchase>.unmodifiable(items);
  }

  @override
  Future<PlanPurchase> buyPlan(Plan plan) async {
    await Future<void>.delayed(const Duration(milliseconds: 450));

    final now = DateTime.now();
    final txn = 'txn_${now.millisecondsSinceEpoch}';
    final validUntil = now.add(planDurationFor(plan.billingCycle));

    for (int i = 0; i < _purchases.length; i++) {
      final p = _purchases[i];
      if (!p.isActive) continue;
      _purchases[i] = PlanPurchase(
        transactionId: p.transactionId,
        planId: p.planId,
        planName: p.planName,
        amount: p.amount,
        purchasedAt: p.purchasedAt,
        validUntil: p.validUntil,
        isActive: false,
      );
    }

    final purchase = PlanPurchase(
      transactionId: txn,
      planId: plan.id,
      planName: plan.name,
      amount: plan.amount,
      purchasedAt: now,
      validUntil: validUntil,
      isActive: true,
    );

    _purchases.add(purchase);
    return purchase;
  }
}
