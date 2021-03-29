import 'package:expense_tracker/models/transaction.dart';
import 'package:expense_tracker/widgets/chart.dart';
import 'package:flutter/material.dart';

class TransactionsChart extends StatelessWidget {
  final List<Transaction> recentTransactions;
  TransactionsChart({@required this.recentTransactions});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      child: Chart(recentTransactions),
    );
  }
}
