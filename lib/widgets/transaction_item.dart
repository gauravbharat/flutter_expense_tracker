import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:expense_tracker/models/transaction.dart';

class TransactionItem extends StatelessWidget {
  const TransactionItem({
    @required this.index,
    @required this.isDarkMode,
    @required this.userTransactions,
    @required this.deleteTransactionHandler,
  });

  final int index;
  final bool isDarkMode;
  final List<Transaction> userTransactions;
  final Function deleteTransactionHandler;

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Platform.isIOS && isDarkMode
          ? CupertinoTheme.of(context).primaryColor
          : Colors.white,
      elevation: 3.0,
      margin: EdgeInsets.symmetric(
        vertical: 3.0,
        horizontal: 5.0,
      ),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: Platform.isIOS && isDarkMode
              ? CupertinoTheme.of(context).primaryContrastingColor
              : Theme.of(context).primaryColor,
          foregroundColor: Platform.isIOS && isDarkMode
              ? CupertinoTheme.of(context).primaryColor
              : Colors.white,
          radius: 30.0,
          child: Padding(
            padding: const EdgeInsets.all(6.0),
            child: FittedBox(
              child: Text(
                '₹${userTransactions[index].amount.toStringAsFixed(2)}',
              ),
            ),
          ),
        ),
        title: Text(
          userTransactions[index].title,
          style: TextStyle(
            color: Platform.isIOS && isDarkMode
                ? CupertinoTheme.of(context).primaryContrastingColor
                : Colors.black,
            fontSize: 18.0,
            fontFamily: 'OpenSans',
          ),
        ),
        subtitle: Text(
          DateFormat.yMMMd().format(userTransactions[index].date),
          style: TextStyle(
            color: Platform.isIOS && isDarkMode
                ? CupertinoTheme.of(context).primaryContrastingColor
                : Colors.black,
          ),
        ),
        trailing:
            // Show larger buttons when some real estate is available on larger screens
            MediaQuery.of(context).size.width > 460
                ? ElevatedButton.icon(
                    onPressed: () =>
                        deleteTransactionHandler(userTransactions[index].id),
                    style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all(
                          Theme.of(context).errorColor),
                    ),
                    icon: Icon(
                      Icons.delete_forever,
                    ),
                    label: Text(
                      'Delete',
                    ),
                  )
                : IconButton(
                    color: Theme.of(context).errorColor,
                    icon: Icon(
                      Icons.delete_forever,
                    ),
                    onPressed: () =>
                        deleteTransactionHandler(userTransactions[index].id),
                  ),
      ),
    );
  }
}
