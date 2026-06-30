import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';
import '../models/transaction_model.dart';
import '../services/hive_service.dart';
import '../services/firestore_service.dart';

class TransactionProvider extends ChangeNotifier {
  List<LoanTransaction> _transactions = [];
  final _uuid = const Uuid();

  List<LoanTransaction> get transactions => _transactions;

  List<LoanTransaction> get givenTransactions =>
      _transactions.where((t) => t.type == 'given').toList();

  List<LoanTransaction> get takenTransactions =>
      _transactions.where((t) => t.type == 'taken').toList();

  List<LoanTransaction> get activeTransactions =>
      _transactions.where((t) => t.status != 'settled').toList();

  TransactionProvider() {
    loadTransactions();
  }

  void loadTransactions() {
    _transactions = HiveService.transactions.values.toList();
    notifyListeners();
  }

  Future<void> addTransaction({
    required String contactId,
    required String contactName,
    required double amount,
    required String type,
    required double interestRate,
    required DateTime startDate,
    DateTime? dueDate,
    String? notes,
    String interestType = 'monthly',
  }) async {
    final transaction = LoanTransaction(
      id: _uuid.v4(),
      contactId: contactId,
      contactName: contactName,
      amount: amount,
      type: type,
      interestRate: interestRate,
      startDate: startDate,
      dueDate: dueDate,
      notes: notes,
      interestType: interestType,
    );
    await HiveService.addTransaction(transaction);
    loadTransactions();

    FirestoreService.syncTransaction(transaction);
  }

  Future<void> markAsSettled(String id) async {
    final t = _transactions.firstWhere((t) => t.id == id);
    t.status = 'settled';
    t.paidAmount = t.amount;
    await HiveService.updateTransaction(t);
    loadTransactions();

    FirestoreService.syncTransaction(t);
  }

  Future<void> recordPartialPayment(String id, double amount) async {
    final t = _transactions.firstWhere((t) => t.id == id);
    t.paidAmount += amount;
    t.status = t.paidAmount >= t.amount ? 'settled' : 'partial';
    await HiveService.updateTransaction(t);
    loadTransactions();

    FirestoreService.syncTransaction(t);
  }

  Future<void> deleteTransaction(String id) async {
    await HiveService.deleteTransaction(id);
    loadTransactions();

    FirestoreService.deleteTransaction(id);
  }

  List<LoanTransaction> getTransactionsForContact(String contactId) {
    return _transactions.where((t) => t.contactId == contactId).toList();
  }

  double get totalInterestEarned {
    return givenTransactions.fold(0, (sum, t) {
      final months = DateTime.now().difference(t.startDate).inDays / 30;
      return sum + (t.amount * t.interestRate / 100 * months);
    });
  }

  double get totalInterestPaid {
    return takenTransactions.fold(0, (sum, t) {
      final months = DateTime.now().difference(t.startDate).inDays / 30;
      return sum + (t.amount * t.interestRate / 100 * months);
    });
  }

  double get totalReceivable {
    return givenTransactions
        .where((t) => t.status != 'settled')
        .fold(0, (sum, t) => sum + (t.amount - t.paidAmount));
  }

  double get totalPayable {
    return takenTransactions
        .where((t) => t.status != 'settled')
        .fold(0, (sum, t) => sum + (t.amount - t.paidAmount));
  }
}