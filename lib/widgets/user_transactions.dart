import 'package:expense_tracker/models/transaction.dart';
import 'package:flutter/material.dart';
import 'package:expense_tracker/widgets/transaction_list.dart';
import 'package:expense_tracker/widgets/transactions_chart.dart';

class UserTransactions extends StatelessWidget {
  final List<Transaction> userTransactions;

  UserTransactions({@required this.userTransactions});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        TransactionsChart(),
        TransactionList(
          userTransactions: userTransactions,
        ),
      ],
    );
  }
}
