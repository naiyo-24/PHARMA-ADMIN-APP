enum PlanBillingCycle { monthly, quarterly, annual }

extension PlanBillingCycleLabel on PlanBillingCycle {
  String get label {
    switch (this) {
      case PlanBillingCycle.monthly:
        return 'Monthly';
      case PlanBillingCycle.quarterly:
        return 'Quarterly';
      case PlanBillingCycle.annual:
        return 'Annual';
    }
  }
}

class Plan {
  const Plan({
    required this.id,
    required this.name,
    required this.billingCycle,
    required this.amount,
    required this.maxUsers,
    required this.benefits,
    required this.advantages,
  });

  final String id;
  final String name;
  final PlanBillingCycle billingCycle;
  final int amount;
  final int maxUsers;
  final List<String> benefits;
  final List<String> advantages;
}

class PlanPurchase {
  const PlanPurchase({
    required this.transactionId,
    required this.planId,
    required this.planName,
    required this.amount,
    required this.purchasedAt,
    required this.validUntil,
    required this.isActive,
  });

  final String transactionId;
  final String planId;
  final String planName;
  final int amount;
  final DateTime purchasedAt;
  final DateTime validUntil;
  final bool isActive;
}

Duration planDurationFor(PlanBillingCycle cycle) {
  switch (cycle) {
    case PlanBillingCycle.monthly:
      return const Duration(days: 30);
    case PlanBillingCycle.quarterly:
      return const Duration(days: 90);
    case PlanBillingCycle.annual:
      return const Duration(days: 365);
  }
}
