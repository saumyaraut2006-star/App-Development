import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../models/transaction_model.dart';
import '../providers/transaction_provider.dart';
import '../services/interest_service.dart';

class TransactionDetailScreen extends StatelessWidget {
  final LoanTransaction transaction;
  const TransactionDetailScreen({super.key, required this.transaction});

  @override
  Widget build(BuildContext context) {
    final interestTillToday = InterestService.interestTillToday(
      principal: transaction.amount,
      rate: transaction.interestRate,
      startDate: transaction.startDate,
      interestType: transaction.interestType,
    );

    final interestTillDue = InterestService.interestTillDueDate(
      principal: transaction.amount,
      rate: transaction.interestRate,
      startDate: transaction.startDate,
      interestType: transaction.interestType,
      dueDate: transaction.dueDate,
    );

    final totalToday = transaction.amount + interestTillToday;
    final isGiven = transaction.type == 'given';
    final color = isGiven ? Colors.green : Colors.red;
    final remaining = transaction.amount - transaction.paidAmount;

    return Scaffold(
      appBar: AppBar(
        title: Text(transaction.contactName),
        backgroundColor: const Color(0xFF1E3A5F),
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            icon: const Icon(Icons.delete_outline),
            onPressed: () async {
              await context
                  .read<TransactionProvider>()
                  .deleteTransaction(transaction.id);
              if (context.mounted) Navigator.pop(context);
            },
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Card(
            color: color.withOpacity(0.08),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    isGiven ? 'You Lent' : 'You Borrowed',
                    style: TextStyle(color: color, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    '₹${transaction.amount.toStringAsFixed(0)}',
                    style: const TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 4),
                  Text('Status: ${transaction.status.toUpperCase()}'),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),
          _infoTile('Interest Rate', '${transaction.interestRate}% ${transaction.interestType}'),
          _infoTile('Start Date', DateFormat('dd MMM yyyy').format(transaction.startDate)),
          _infoTile('Due Date', transaction.dueDate == null
              ? 'Not set'
              : DateFormat('dd MMM yyyy').format(transaction.dueDate!)),
          _infoTile('Interest Till Today', '₹${interestTillToday.toStringAsFixed(2)}'),
          if (interestTillDue != null)
            _infoTile('Interest Till Due Date', '₹${interestTillDue.toStringAsFixed(2)}'),
          _infoTile('Total Amount (Today)', '₹${totalToday.toStringAsFixed(2)}'),
          _infoTile('Paid Amount', '₹${transaction.paidAmount.toStringAsFixed(2)}'),
          _infoTile('Remaining', '₹${remaining.toStringAsFixed(2)}'),
          if (transaction.notes != null && transaction.notes!.isNotEmpty)
            _infoTile('Notes', transaction.notes!),
          const SizedBox(height: 24),
          if (transaction.status != 'settled') ...[
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                ),
                icon: const Icon(Icons.check_circle, color: Colors.white),
                label: const Text('Mark as Settled',
                    style: TextStyle(color: Colors.white)),
                onPressed: () async {
                  await context
                      .read<TransactionProvider>()
                      .markAsSettled(transaction.id);
                  if (context.mounted) Navigator.pop(context);
                },
              ),
            ),
            const SizedBox(height: 10),
            SizedBox(
              width: double.infinity,
              child: OutlinedButton.icon(
                icon: const Icon(Icons.payments_outlined),
                label: const Text('Record Partial Payment'),
                onPressed: () => _showPartialPaymentDialog(context),
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _infoTile(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: const TextStyle(color: Colors.grey)),
          Text(value, style: const TextStyle(fontWeight: FontWeight.w600)),
        ],
      ),
    );
  }

  void _showPartialPaymentDialog(BuildContext context) {
    final controller = TextEditingController();
    showDialog(
      context: context,
      builder: (ctx) {
        return AlertDialog(
          title: const Text('Record Payment'),
          content: TextField(
            controller: controller,
            keyboardType: TextInputType.number,
            decoration: const InputDecoration(labelText: 'Amount Paid (₹)'),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(ctx),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () async {
                final amount = double.tryParse(controller.text);
                if (amount != null && amount > 0) {
                  await context
                      .read<TransactionProvider>()
                      .recordPartialPayment(transaction.id, amount);
                  if (ctx.mounted) Navigator.pop(ctx);
                  if (context.mounted) Navigator.pop(context);
                }
              },
              child: const Text('Save'),
            ),
          ],
        );
      },
    );
  }
}