import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../models/contact_model.dart';
import '../models/transaction_model.dart';

class FirestoreService {
  static final FirebaseFirestore _db = FirebaseFirestore.instance;

  static String? get _uid => FirebaseAuth.instance.currentUser?.uid;

  // Each user's data is stored under users/{uid}/contacts and users/{uid}/transactions
  static CollectionReference<Map<String, dynamic>>? get _contactsRef {
    if (_uid == null) return null;
    return _db.collection('users').doc(_uid).collection('contacts');
  }

  static CollectionReference<Map<String, dynamic>>? get _transactionsRef {
    if (_uid == null) return null;
    return _db.collection('users').doc(_uid).collection('transactions');
  }

  // ---------- CONTACTS ----------
  static Future<void> syncContact(Contact contact) async {
    final ref = _contactsRef;
    if (ref == null) return; // not logged in, skip silently
    await ref.doc(contact.id).set({
      'id': contact.id,
      'name': contact.name,
      'mobile': contact.mobile,
      'email': contact.email,
      'updatedAt': FieldValue.serverTimestamp(),
    });
  }

  static Future<void> deleteContact(String id) async {
    final ref = _contactsRef;
    if (ref == null) return;
    await ref.doc(id).delete();
  }

  // ---------- TRANSACTIONS ----------
  static Future<void> syncTransaction(LoanTransaction t) async {
    final ref = _transactionsRef;
    if (ref == null) return;
    await ref.doc(t.id).set({
      'id': t.id,
      'contactId': t.contactId,
      'contactName': t.contactName,
      'amount': t.amount,
      'type': t.type,
      'interestRate': t.interestRate,
      'startDate': t.startDate.toIso8601String(),
      'dueDate': t.dueDate?.toIso8601String(),
      'status': t.status,
      'paidAmount': t.paidAmount,
      'notes': t.notes,
      'interestType': t.interestType,
      'updatedAt': FieldValue.serverTimestamp(),
    });
  }

  static Future<void> deleteTransaction(String id) async {
    final ref = _transactionsRef;
    if (ref == null) return;
    await ref.doc(id).delete();
  }

  // ---------- FETCH (for restore / cross-device use) ----------
  static Future<List<Map<String, dynamic>>> fetchContacts() async {
    final ref = _contactsRef;
    if (ref == null) return [];
    final snap = await ref.get();
    return snap.docs.map((d) => d.data()).toList();
  }

  static Future<List<Map<String, dynamic>>> fetchTransactions() async {
    final ref = _transactionsRef;
    if (ref == null) return [];
    final snap = await ref.get();
    return snap.docs.map((d) => d.data()).toList();
  }
}