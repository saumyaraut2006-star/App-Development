import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/contact_provider.dart';
import '../providers/transaction_provider.dart';
import '../models/contact_model.dart';

class AddTransactionScreen extends StatefulWidget {
  const AddTransactionScreen({super.key});

  @override
  State<AddTransactionScreen> createState() => _AddTransactionScreenState();
}

class _AddTransactionScreenState extends State<AddTransactionScreen> {
  final _formKey = GlobalKey<FormState>();
  final _amountController = TextEditingController();
  final _rateController = TextEditingController();
  final _notesController = TextEditingController();

  Contact? _selectedContact;
  String _type = 'given';
  String _interestType = 'monthly';
  DateTime _startDate = DateTime.now();
  DateTime? _dueDate;

  @override
  Widget build(BuildContext context) {
    final contacts = context.watch<ContactProvider>().contacts;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Transaction'),
        backgroundColor: const Color(0xFF1E3A5F),
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Type selector
              Row(
                children: [
                  Expanded(
                    child: ChoiceChip(
                      label: const Text('Given (Lent)'),
                      selected: _type == 'given',
                      selectedColor: Colors.green.shade100,
                      onSelected: (_) => setState(() => _type = 'given'),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: ChoiceChip(
                      label: const Text('Taken (Borrowed)'),
                      selected: _type == 'taken',
                      selectedColor: Colors.red.shade100,
                      onSelected: (_) => setState(() => _type = 'taken'),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),

              // Contact dropdown
              DropdownButtonFormField<Contact>(
                decoration: const InputDecoration(
                  labelText: 'Select Contact',
                  border: OutlineInputBorder(),
                ),
                items: contacts
                    .map((c) => DropdownMenuItem(value: c, child: Text(c.name)))
                    .toList(),
                onChanged: (v) => setState(() => _selectedContact = v),
                validator: (v) => v == null ? 'Select a contact' : null,
              ),
              if (contacts.isEmpty)
                const Padding(
                  padding: EdgeInsets.only(top: 8),
                  child: Text(
                    'No contacts yet. Add one from Contacts tab first.',
                    style: TextStyle(color: Colors.red, fontSize: 12),
                  ),
                ),
              const SizedBox(height: 16),

              TextFormField(
                controller: _amountController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelText: 'Amount (₹)',
                  border: OutlineInputBorder(),
                ),
                validator: (v) => v == null || v.isEmpty ? 'Enter amount' : null,
              ),
              const SizedBox(height: 16),

              TextFormField(
                controller: _rateController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelText: 'Interest Rate (%)',
                  border: OutlineInputBorder(),
                ),
                validator: (v) => v == null || v.isEmpty ? 'Enter rate' : null,
              ),
              const SizedBox(height: 16),

              // Interest type
              Row(
                children: [
                  const Text('Interest Type: '),
                  const SizedBox(width: 10),
                  ChoiceChip(
                    label: const Text('Monthly'),
                    selected: _interestType == 'monthly',
                    onSelected: (_) => setState(() => _interestType = 'monthly'),
                  ),
                  const SizedBox(width: 8),
                  ChoiceChip(
                    label: const Text('Yearly'),
                    selected: _interestType == 'yearly',
                    onSelected: (_) => setState(() => _interestType = 'yearly'),
                  ),
                ],
              ),
              const SizedBox(height: 16),

              // Start Date
              ListTile(
                contentPadding: EdgeInsets.zero,
                title: const Text('Start Date'),
                subtitle: Text('${_startDate.toLocal()}'.split(' ')[0]),
                trailing: const Icon(Icons.calendar_today),
                onTap: () async {
                  final picked = await showDatePicker(
                    context: context,
                    initialDate: _startDate,
                    firstDate: DateTime(2020),
                    lastDate: DateTime(2030),
                  );
                  if (picked != null) setState(() => _startDate = picked);
                },
              ),

              // Due Date
              ListTile(
                contentPadding: EdgeInsets.zero,
                title: const Text('Due Date (Optional)'),
                subtitle: Text(_dueDate == null
                    ? 'Not set'
                    : '${_dueDate!.toLocal()}'.split(' ')[0]),
                trailing: const Icon(Icons.calendar_today),
                onTap: () async {
                  final picked = await showDatePicker(
                    context: context,
                    initialDate: _startDate,
                    firstDate: DateTime(2020),
                    lastDate: DateTime(2035),
                  );
                  if (picked != null) setState(() => _dueDate = picked);
                },
              ),
              const SizedBox(height: 16),

              TextFormField(
                controller: _notesController,
                decoration: const InputDecoration(
                  labelText: 'Notes (Optional)',
                  border: OutlineInputBorder(),
                ),
                maxLines: 2,
              ),
              const SizedBox(height: 24),

              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF1E3A5F),
                    padding: const EdgeInsets.symmetric(vertical: 14),
                  ),
                  onPressed: () async {
                    if (_formKey.currentState!.validate() &&
                        _selectedContact != null) {
                      await context.read<TransactionProvider>().addTransaction(
                            contactId: _selectedContact!.id,
                            contactName: _selectedContact!.name,
                            amount: double.parse(_amountController.text),
                            type: _type,
                            interestRate: double.parse(_rateController.text),
                            startDate: _startDate,
                            dueDate: _dueDate,
                            notes: _notesController.text,
                            interestType: _interestType,
                          );
                      if (context.mounted) Navigator.pop(context);
                    }
                  },
                  child: const Text('Save Transaction',
                      style: TextStyle(color: Colors.white)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}