import 'dart:io';
import 'package:expense_tracker/constants.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
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
              return Column(
                children: [
                  Text(
                    'No Transactions added yet!',
                    style: Platform.isIOS
                        ? kHeadLine6TextTheme
                        : Theme.of(context).textTheme.headline6,
                  ),
                  SizedBox(
                    height: 20.0,
                  ),
                  Container(
                    height: constraints.maxHeight * 0.6,
                    child: Image.asset(
                      'assets/images/waiting.png',
                      fit: BoxFit.cover,
                    ),
                  )
                ],
              );
            })
          : ListView.builder(
              itemBuilder: (ctx, index) {
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
                                onPressed: () => deleteTransactionHandler(
                                    userTransactions[index].id),
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
                                onPressed: () => deleteTransactionHandler(
                                    userTransactions[index].id),
                              ),
                  ),
                );
              },
              itemCount: userTransactions.length,
            ),
    );
  }
}
