import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/plans.dart';
import '../providers/payment_provider.dart';

class PaymentState {
  const PaymentState({required this.plans, required this.purchases});

  final List<Plan> plans;
  final List<PlanPurchase> purchases;
}

final paymentNotifierProvider =
    AsyncNotifierProvider<PaymentNotifier, PaymentState>(PaymentNotifier.new);

class PaymentNotifier extends AsyncNotifier<PaymentState> {
  @override
  Future<PaymentState> build() async {
    final repo = ref.watch(paymentRepositoryProvider);
    final plans = await repo.getPlans();
    final history = await repo.getPurchaseHistory();
    return PaymentState(plans: plans, purchases: history);
  }

  Future<void> refresh() async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(build);
  }

  Future<void> buyPlan(Plan plan) async {
    final repo = ref.read(paymentRepositoryProvider);
    final existingPlans = state.asData?.value.plans;

    state = const AsyncLoading();
    state = await AsyncValue.guard(() async {
      await repo.buyPlan(plan);
      final plans = existingPlans ?? await repo.getPlans();
      final history = await repo.getPurchaseHistory();
      return PaymentState(plans: plans, purchases: history);
    });
  }
}
