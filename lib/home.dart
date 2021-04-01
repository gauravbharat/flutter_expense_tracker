import 'package:expense_tracker/constants.dart';
import 'package:flutter/material.dart';
import 'dart:collection';
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:expense_tracker/models/transaction.dart';
import 'package:expense_tracker/widgets/new_transaction.dart';
import 'package:expense_tracker/widgets/user_transactions.dart';

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

  @override
  Widget build(BuildContext context) {
    final appBar = AppBar(
        title: Text(
          'Personal Expenses',
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.settings_display),
            onPressed: widget.darkModeHandler,
          ),
        ]);

    return Scaffold(
      appBar: appBar,
      body: UserTransactions(
        userTransactions: userTransactions,
        deleteTransactionHandler: _deleteTransaction,
        appBarHeight: appBar.preferredSize.height,
        showChart: _showChart,
        showChartHandler: (value) => setState(() => _showChart = value),
      ),
      // floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () => _startAddNewTransaction(context),
        // foregroundColor: Theme.of(context).accentColor,
      ),
    );
  }
}
