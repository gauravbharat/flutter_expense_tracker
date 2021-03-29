import 'package:expense_tracker/models/transaction.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class TransactionList extends StatelessWidget {
  final List<Transaction> userTransactions;
  TransactionList({@required this.userTransactions});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: ListView.builder(
        itemBuilder: (ctx, index) {
          return Card(
            child: Row(
              children: [
                Container(
                  margin: EdgeInsets.symmetric(
                    vertical: 10.0,
                    horizontal: 15.0,
                  ),
                  decoration: BoxDecoration(
                    border: Border.all(
                      width: 2,
                      color: Theme.of(context).primaryColor,
                    ),
                    borderRadius: BorderRadius.all(Radius.circular(5.0)),
                  ),
                  padding: EdgeInsets.all(10.0),
                  child: Text(
                    '₹${userTransactions[index].amount.toStringAsFixed(2)}',
                    style: TextStyle(
                      fontWeight: FontWeight.w300,
                      fontSize: 18.0,
                      color: Theme.of(context).primaryColor,
                    ),
                  ),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      userTransactions[index].title,
                      style: Theme.of(context).textTheme.headline6,
                    ),
                    Text(
                      DateFormat.yMMMd().format(userTransactions[index].date),
                      style: TextStyle(
                        fontSize: 12.0,
                        color: Colors.grey,
                      ),
                    ),
                  ],
                )
              ],
            ),
          );
        },
        itemCount: userTransactions.length,
      ),
    );
  }
}
