import 'package:hive/hive.dart';

part 'transaction_model.g.dart';

@HiveType(typeId: 1)
class LoanTransaction extends HiveObject {
  @HiveField(0)
  late String id;

  @HiveField(1)
  late String contactId;

  @HiveField(2)
  late String contactName;

  @HiveField(3)
  late double amount;

  @HiveField(4)
  late String type; // 'given' or 'taken'

  @HiveField(5)
  late double interestRate;

  @HiveField(6)
  late DateTime startDate;

  @HiveField(7)
  DateTime? dueDate;

  @HiveField(8)
  late String status; // 'active', 'partial', 'settled'

  @HiveField(9)
  double paidAmount;

  @HiveField(10)
  String? notes;

  @HiveField(11)
  late String interestType; // 'monthly' or 'yearly'

  LoanTransaction({
    required this.id,
    required this.contactId,
    required this.contactName,
    required this.amount,
    required this.type,
    required this.interestRate,
    required this.startDate,
    this.dueDate,
    this.status = 'active',
    this.paidAmount = 0,
    this.notes,
    this.interestType = 'monthly',
  });
}