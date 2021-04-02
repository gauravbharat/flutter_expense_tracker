import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:expense_tracker/constants.dart';

class NoTransactions extends StatelessWidget {
  final BoxConstraints constraints;
  NoTransactions({@required this.constraints});

  @override
  Widget build(BuildContext context) {
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
  }
}
