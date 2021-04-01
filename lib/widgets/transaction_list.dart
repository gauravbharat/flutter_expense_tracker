import 'package:expense_tracker/models/transaction.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class TransactionList extends StatelessWidget {
  final List<Transaction> userTransactions;
  final Function deleteTransactionHandler;

  TransactionList({
    @required this.userTransactions,
    @required this.deleteTransactionHandler,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: userTransactions.isEmpty
          ? LayoutBuilder(builder: (ctx, constraints) {
              return Column(
                children: [
                  Text(
                    'No Transactions added yet!',
                    style: Theme.of(context).textTheme.headline6,
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
                  elevation: 3.0,
                  margin: EdgeInsets.symmetric(
                    vertical: 3.0,
                    horizontal: 5.0,
                  ),
                  child: ListTile(
                    leading: CircleAvatar(
                      radius: 30.0,
                      child: Padding(
                        padding: const EdgeInsets.all(6.0),
                        child: FittedBox(
                          child: Text(
                              '₹${userTransactions[index].amount.toStringAsFixed(2)}'),
                        ),
                      ),
                    ),
                    title: Text(
                      userTransactions[index].title,
                      style: Theme.of(context).textTheme.headline6,
                    ),
                    subtitle: Text(
                      DateFormat.yMMMd().format(userTransactions[index].date),
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
