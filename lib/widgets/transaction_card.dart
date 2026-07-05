import 'package:flutter/material.dart';
import '../models/transaction_model.dart';
import '../services/interest_service.dart';
import '../screens/transaction_detail_screen.dart';
import 'package:intl/intl.dart';

class TransactionCard extends StatelessWidget {
  final LoanTransaction transaction;
  const TransactionCard({super.key, required this.transaction});

  @override
  Widget build(BuildContext context) {
    final interest = InterestService.interestTillToday(
      principal: transaction.amount,
      rate: transaction.interestRate,
      startDate: transaction.startDate,
      interestType: transaction.interestType,
    );
    final total = transaction.amount + interest;
    final isGiven = transaction.type == 'given';
    final color = isGiven ? Colors.green : Colors.red;

    return Card(
      margin: const EdgeInsets.only(bottom: 10),
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: ListTile(
        onTap: () => Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => TransactionDetailScreen(transaction: transaction),
          ),
        ),
        leading: CircleAvatar(
          backgroundColor: color.withOpacity(0.15),
          child: Text(
            transaction.contactName[0].toUpperCase(),
            style: TextStyle(color: color, fontWeight: FontWeight.bold),
          ),
        ),
        title: Text(
          transaction.contactName,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Principal: ₹${transaction.amount.toStringAsFixed(0)}'),
            Text(
              'Interest: ₹${interest.toStringAsFixed(0)} | Total: ₹${total.toStringAsFixed(0)}',
              style: TextStyle(color: color, fontSize: 12),
            ),
            Text(
              'Started: ${DateFormat('dd MMM yyyy').format(transaction.startDate)}',
              style: const TextStyle(fontSize: 11, color: Colors.grey),
            ),
          ],
        ),
        trailing: Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          decoration: BoxDecoration(
            color: _statusColor(transaction.status).withOpacity(0.15),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Text(
            transaction.status.toUpperCase(),
            style: TextStyle(
              color: _statusColor(transaction.status),
              fontSize: 10,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }

  Color _statusColor(String status) {
    switch (status) {
      case 'settled':
        return Colors.green;
      case 'partial':
        return Colors.orange;
      default:
        return Colors.blue;
    }
  }
}