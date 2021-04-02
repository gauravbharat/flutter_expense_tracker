import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:expense_tracker/widgets/transaction_item.dart';
import 'package:expense_tracker/widgets/no_transactions.dart';
import 'package:expense_tracker/models/transaction.dart';

class TransactionList extends StatelessWidget {
  final List<Transaction> userTransactions;
  final Function deleteTransactionHandler;
  final bool isDarkMode;

  TransactionList(
      {@required this.userTransactions,
      @required this.deleteTransactionHandler,
      @required this.isDarkMode});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: userTransactions.isEmpty
          ? LayoutBuilder(builder: (ctx, constraints) {
              return NoTransactions(constraints: constraints);
            })
          : ListView.builder(
              itemBuilder: (ctx, index) {
                return TransactionItem(
                    index: index,
                    isDarkMode: isDarkMode,
                    userTransactions: userTransactions,
                    deleteTransactionHandler: deleteTransactionHandler);
              },
              itemCount: userTransactions.length,
            ),
    );
  }
}
