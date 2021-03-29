import 'package:expense_tracker/models/transaction.dart';
import 'package:flutter/material.dart';
import 'package:expense_tracker/widgets/transaction_list.dart';
import 'package:expense_tracker/widgets/transactions_chart.dart';

class UserTransactions extends StatelessWidget {
  final List<Transaction> userTransactions;
  final Function deleteTransactionHandler;

  UserTransactions({
    @required this.userTransactions,
    @required this.deleteTransactionHandler,
  });

  List<Transaction> get _recentTransactions {
    return userTransactions
        .where(
          (tx) => tx.date.isAfter(
            DateTime.now().subtract(Duration(days: 7)),
          ),
        )
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        TransactionsChart(
          recentTransactions: _recentTransactions,
        ),
        TransactionList(
            userTransactions: userTransactions,
            deleteTransactionHandler: deleteTransactionHandler),
      ],
    );
  }
}
