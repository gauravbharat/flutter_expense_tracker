import 'dart:io';
import 'dart:collection';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:expense_tracker/constants.dart';
import 'package:expense_tracker/models/transaction.dart';
import 'package:expense_tracker/widgets/chart.dart';
import 'package:expense_tracker/widgets/transaction_list.dart';
import 'package:expense_tracker/widgets/new_transaction.dart';

class MyHomePage extends StatefulWidget {
  final Function darkModeHandler;

  MyHomePage({@required this.darkModeHandler});

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
  final List<Transaction> _userTransactions = [];
  bool _showChart = false;

  @override
  void initState() {
    super.initState();
    _loadStoredTransactions();
  }

  void _loadStoredTransactions() async {
    final SharedPreferences prefs = await _prefs;
    if (prefs.containsKey(kSharedPrefsStoreKey)) {
      final storedTransactions =
          json.decode(prefs.getString(kSharedPrefsStoreKey));

      if (storedTransactions != null) {
        (storedTransactions as List<dynamic>).forEach((tx) {
          _userTransactions.add(Transaction.fromJson(tx));
        });
      } else {
        prefs.remove(kSharedPrefsStoreKey);
      }
      print('$kSharedPrefsStoreKey $storedTransactions');
    }
  }

  void _storeTransactions() async {
    final SharedPreferences prefs = await _prefs;
    print(_userTransactions);
    prefs.setString(kSharedPrefsStoreKey, json.encode(_userTransactions));
  }

  UnmodifiableListView<Transaction> get userTransactions {
    return UnmodifiableListView(_userTransactions.reversed.toList());
  }

  void _startAddNewTransaction(BuildContext ctx) {
    showModalBottomSheet(
        context: ctx,
        isScrollControlled: true,
        builder: (_) {
          return NewTransaction(
            newTxHandler: _addNewTransaction,
          );
        });
  }

  void _addNewTransaction(String txTitle, double txAmount, DateTime txDate) {
    final newTx = Transaction(
      id: DateTime.now().toString(),
      title: txTitle,
      amount: txAmount,
      date: txDate,
    );

    setState(() {
      _userTransactions.add(newTx);
    });
    _storeTransactions();
  }

  void _deleteTransaction(String id) {
    setState(() {
      _userTransactions.removeWhere((tx) => tx.id == id);
    });
    _storeTransactions();
  }

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
    final appBar = AppBar(
        title: Row(
          children: [
            Text(
              'Personal Expenses',
            ),
            if (Platform.isIOS)
              IconButton(
                icon: Icon(Icons.add),
                onPressed: () => _startAddNewTransaction(context),
              ),
          ],
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.settings_display),
            onPressed: widget.darkModeHandler,
          ),
        ]);

    // Store mediaquery in variables instead of calling the methods
    final isLandscape =
        MediaQuery.of(context).orientation == Orientation.landscape;

    final availableHeight = (MediaQuery.of(context).size.height -
        appBar.preferredSize.height -
        MediaQuery.of(context).padding.top);

    final chartContainer = Container(
      // Set the height based on the screen height after reducing the
      // appbar and the top status/notch height
      height: availableHeight * (isLandscape ? 0.7 : 0.3),
      child: Chart(_recentTransactions),
    );

    final txListWidget = TransactionList(
        userTransactions: userTransactions,
        deleteTransactionHandler: _deleteTransaction);

    return Scaffold(
      appBar: appBar,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          if (isLandscape)
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text('Show Chart'),
                // Use .adaptive on available widgets, to show platform (ios/android) specific widgets
                Switch.adaptive(
                  activeColor: Theme.of(context).accentColor,
                  value: _showChart,
                  onChanged: (value) => setState(() => _showChart = value),
                ),
              ],
            ),
          if (isLandscape) _showChart ? chartContainer : txListWidget,
          if (!isLandscape) chartContainer,
          if (!isLandscape) txListWidget,
        ],
      ),
      // floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: Platform.isIOS
          ? Container()
          : FloatingActionButton(
              child: Icon(Icons.add),
              onPressed: () => _startAddNewTransaction(context),
              // foregroundColor: Theme.of(context).accentColor,
            ),
    );
  }
}
