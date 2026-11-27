import 'package:hive_flutter/hive_flutter.dart';
import '../models/contact_model.dart';
import '../models/transaction_model.dart';

class HiveService {
  static const String contactsBox = 'contacts';
  static const String transactionsBox = 'transactions';

  static Future<void> init() async {
    await Hive.initFlutter();
    Hive.registerAdapter(ContactAdapter());
    Hive.registerAdapter(LoanTransactionAdapter());
    await Hive.openBox<Contact>(contactsBox);
    await Hive.openBox<LoanTransaction>(transactionsBox);
  }

  // Contacts
  static Box<Contact> get contacts => Hive.box<Contact>(contactsBox);
  static Box<LoanTransaction> get transactions => Hive.box<LoanTransaction>(transactionsBox);

  // Add Contact
  static Future<void> addContact(Contact contact) async {
    await contacts.put(contact.id, contact);
  }

  // Add Transaction
  static Future<void> addTransaction(LoanTransaction transaction) async {
    await transactions.put(transaction.id, transaction);
  }

  // Update Transaction
  static Future<void> updateTransaction(LoanTransaction transaction) async {
    await transactions.put(transaction.id, transaction);
  }

  // Delete Transaction
  static Future<void> deleteTransaction(String id) async {
    await transactions.delete(id);
  }

  // Delete Contact
  static Future<void> deleteContact(String id) async {
    await contacts.delete(id);
  }

  // Get all transactions for a contact
  static List<LoanTransaction> getTransactionsForContact(String contactId) {
    return transactions.values
        .where((t) => t.contactId == contactId)
        .toList();
  }
}