import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';
import '../models/contact_model.dart';
import '../services/hive_service.dart';
import '../services/firestore_service.dart';

class ContactProvider extends ChangeNotifier {
  List<Contact> _contacts = [];
  final _uuid = const Uuid();

  List<Contact> get contacts => _contacts;

  ContactProvider() {
    loadContacts();
  }

  void loadContacts() {
    _contacts = HiveService.contacts.values.toList();
    notifyListeners();
  }

  Future<void> addContact({
    required String name,
    required String mobile,
    String? email,
  }) async {
    final contact = Contact(
      id: _uuid.v4(),
      name: name,
      mobile: mobile,
      email: email,
    );
    await HiveService.addContact(contact);
    loadContacts();

    // Sync to Firestore cloud (fire-and-forget, doesn't block UI)
    FirestoreService.syncContact(contact);
  }

  Future<void> deleteContact(String id) async {
    await HiveService.deleteContact(id);
    loadContacts();

    // Remove from cloud too
    FirestoreService.deleteContact(id);
  }

  Contact? getContactById(String id) {
    try {
      return _contacts.firstWhere((c) => c.id == id);
    } catch (e) {
      return null;
    }
  }

  List<Contact> searchContacts(String query) {
    return _contacts
        .where((c) => c.name.toLowerCase().contains(query.toLowerCase()))
        .toList();
  }
}