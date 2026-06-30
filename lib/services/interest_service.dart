class InterestService {
  // Simple Interest = P * R * T / 100
  // For monthly: T = number of months
  // For yearly: T = number of years

  static double calculateInterest({
    required double principal,
    required double rate,
    required DateTime startDate,
    required String interestType,
    DateTime? tillDate,
  }) {
    final endDate = tillDate ?? DateTime.now();
    final days = endDate.difference(startDate).inDays;

    if (interestType == 'monthly') {
      final months = days / 30;
      return (principal * rate * months) / 100;
    } else {
      final years = days / 365;
      return (principal * rate * years) / 100;
    }
  }

  static double calculateTotalAmount({
    required double principal,
    required double rate,
    required DateTime startDate,
    required String interestType,
    DateTime? tillDate,
  }) {
    return principal +
        calculateInterest(
          principal: principal,
          rate: rate,
          startDate: startDate,
          interestType: interestType,
          tillDate: tillDate,
        );
  }

  static double interestTillToday({
    required double principal,
    required double rate,
    required DateTime startDate,
    required String interestType,
  }) {
    return calculateInterest(
      principal: principal,
      rate: rate,
      startDate: startDate,
      interestType: interestType,
    );
  }

  static double? interestTillDueDate({
    required double principal,
    required double rate,
    required DateTime startDate,
    required String interestType,
    required DateTime? dueDate,
  }) {
    if (dueDate == null) return null;
    return calculateInterest(
      principal: principal,
      rate: rate,
      startDate: startDate,
      interestType: interestType,
      tillDate: dueDate,
    );
  }
}