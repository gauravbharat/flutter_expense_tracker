import 'package:expense_tracker/models/transaction.dart';
import 'package:expense_tracker/widgets/chart.dart';
import 'package:flutter/material.dart';
import 'package:expense_tracker/widgets/transaction_list.dart';

class UserTransactions extends StatelessWidget {
  final List<Transaction> userTransactions;
  final Function deleteTransactionHandler;
  final appBarHeight;

  UserTransactions(
      {@required this.userTransactions,
      @required this.deleteTransactionHandler,
      @required this.appBarHeight});

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
    final availableHeight = (MediaQuery.of(context).size.height -
        appBarHeight -
        MediaQuery.of(context).padding.top);

    print(MediaQuery.of(context).orientation);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Container(
          // Set the height based on the screen height after reducing the
          // appbar and the top status/notch height
          height: availableHeight * 0.3,
          child: Chart(_recentTransactions),
        ),
        TransactionList(
            userTransactions: userTransactions,
            deleteTransactionHandler: deleteTransactionHandler),
      ],
    );
  }
}
