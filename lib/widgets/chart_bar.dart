import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ChartBar extends StatelessWidget {
  final String label;
  final double spendingAmount;
  final double spendingPctOfTotal;
  final bool isDarkMode;

  ChartBar(
      {@required this.label,
      @required this.spendingAmount,
      @required this.spendingPctOfTotal,
      @required this.isDarkMode});

  @override
  Widget build(BuildContext context) {
    // Use the LayoutBuilder to get the available height and width constraints
    // and dynamically calculate the height and width of child objects
    return LayoutBuilder(builder: (ctx, constraints) {
      return Column(
        children: [
          Container(
            height: constraints.maxHeight * 0.15,
            child: FittedBox(
              child: Text(
                '₹${spendingAmount.toStringAsFixed(0)}',
                style: TextStyle(
                  color: Platform.isIOS && isDarkMode
                      ? CupertinoTheme.of(context).primaryContrastingColor
                      : Colors.black,
                ),
              ),
            ),
          ),
          SizedBox(
            height: constraints.maxHeight * 0.05,
          ),
          Container(
            height: constraints.maxHeight * 0.6,
            width: 10.0,
            child: Stack(
              children: [
                Container(
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey, width: 1.0),
                    color: Color.fromRGBO(220, 220, 220, 1),
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                ),
                FractionallySizedBox(
                  heightFactor: spendingPctOfTotal,
                  child: Container(
                    decoration: BoxDecoration(
                      color: Platform.isIOS && isDarkMode
                          ? CupertinoTheme.of(context).barBackgroundColor
                          : Theme.of(context).primaryColor,
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(
            height: constraints.maxHeight * 0.05,
          ),
          Container(
            height: constraints.maxHeight * 0.15,
            child: FittedBox(
              child: Text(
                label,
                style: TextStyle(
                  color: Platform.isIOS && isDarkMode
                      ? CupertinoTheme.of(context).primaryContrastingColor
                      : Colors.black,
                ),
              ),
            ),
          )
        ],
      );
    });
  }
}
