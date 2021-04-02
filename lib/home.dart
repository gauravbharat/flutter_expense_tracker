import 'dart:io';
import 'dart:collection';
import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:expense_tracker/constants.dart';
import 'package:expense_tracker/models/transaction.dart';
import 'package:expense_tracker/widgets/chart.dart';
import 'package:expense_tracker/widgets/transaction_list.dart';
import 'package:expense_tracker/widgets/new_transaction.dart';

class MyHomePage extends StatefulWidget {
  final Function darkModeHandler;
  final bool isDarkMode;

  MyHomePage({
    @required this.isDarkMode,
    @required this.darkModeHandler,
  });

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage>
    implements WidgetsBindingObserver {
  final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
  final List<Transaction> _userTransactions = [];
  bool _showChart = false;

  @override
  void initState() {
    super.initState();
    _loadStoredTransactions();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    // TODO: implement didChangeAppLifecycleState
    print('state $state');
  }

  @override
  void dispose() {
    super.dispose();
    WidgetsBinding.instance.removeObserver(this);
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
    final PreferredSizeWidget appBar = Platform.isIOS
        ? CupertinoNavigationBar(
            backgroundColor: CupertinoTheme.of(context).primaryColor,
            middle: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'Personal Expenses',
                  style: TextStyle(color: Colors.white),
                ),
                GestureDetector(
                  onTap: () => _startAddNewTransaction(context),
                  child: Icon(
                    CupertinoIcons.add,
                    color: CupertinoTheme.of(context).primaryContrastingColor,
                  ),
                ),
              ],
            ),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                GestureDetector(
                  child: Icon(
                    widget.isDarkMode
                        ? CupertinoIcons.circle_lefthalf_fill
                        : CupertinoIcons.circle_righthalf_fill,
                    color: CupertinoTheme.of(context).primaryContrastingColor,
                  ),
                  onTap: widget.darkModeHandler,
                ),
              ],
            ),
          )
        : AppBar(
            title: Text(
              'Personal Expenses',
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

    final Container chartContainer = Container(
      // Set the height based on the screen height after reducing the
      // appbar and the top status/notch height
      height: availableHeight * (isLandscape ? 0.7 : 0.3),
      child: Chart(_recentTransactions, widget.isDarkMode),
    );

    final TransactionList txListWidget = TransactionList(
      userTransactions: userTransactions,
      deleteTransactionHandler: _deleteTransaction,
      isDarkMode: widget.isDarkMode,
    );

    return Platform.isIOS
        ? buildCupertinoPageScaffold(
            appBar, isLandscape, context, chartContainer, txListWidget)
        : buildScaffold(
            appBar, isLandscape, context, chartContainer, txListWidget);
  }

  CupertinoPageScaffold buildCupertinoPageScaffold(
      PreferredSizeWidget appBar,
      bool isLandscape,
      BuildContext context,
      Container chartContainer,
      TransactionList txListWidget) {
    return CupertinoPageScaffold(
      navigationBar: appBar,
      child: buildBody(isLandscape, context, chartContainer, txListWidget),
    );
  }

  Scaffold buildScaffold(AppBar appBar, bool isLandscape, BuildContext context,
      Container chartContainer, TransactionList txListWidget) {
    return Scaffold(
      appBar: appBar,
      body: buildBody(isLandscape, context, chartContainer, txListWidget),
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

  SafeArea buildBody(bool isLandscape, BuildContext context,
      Container chartContainer, TransactionList txListWidget) {
    // Wrap with SafeArea for notch display!
    return SafeArea(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          if (isLandscape)
            ..._buildLandscapeContent(context, chartContainer, txListWidget),
          if (!isLandscape) ...<Widget>[
            chartContainer,
            txListWidget,
          ],
        ],
      ),
    );
  }

  List<Widget> _buildLandscapeContent(
    BuildContext context,
    Container chartContainer,
    TransactionList txListWidget,
  ) {
    return [
      Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            'Show Chart',
            style: Platform.isIOS
                ? kHeadLine6TextTheme
                : Theme.of(context).textTheme.headline6,
          ),
          // Use .adaptive on available widgets, to show platform (ios/android) specific widgets
          Switch.adaptive(
            activeColor: Platform.isIOS
                ? CupertinoTheme.of(context).primaryContrastingColor
                : Theme.of(context).accentColor,
            value: _showChart,
            onChanged: (value) => setState(() => _showChart = value),
          ),
        ],
      ),
      _showChart ? chartContainer : txListWidget
    ];
  }

  @override
  void didChangeAccessibilityFeatures() {
    // TODO: implement didChangeAccessibilityFeatures
    print('didChangeAccessibilityFeatures');
  }

  @override
  void didChangeLocales(List<Locale> locales) {
    // TODO: implement didChangeLocales
    print('didChangeLocales $locales');
  }

  @override
  void didChangeMetrics() {
    // TODO: implement didChangeMetrics
    print('didChangeMetrics');
  }

  @override
  void didChangePlatformBrightness() {
    // TODO: implement didChangePlatformBrightness
    print('didChangePlatformBrightness');
  }

  @override
  void didChangeTextScaleFactor() {
    // TODO: implement didChangeTextScaleFactor
    print('didChangeTextScaleFactor');
  }

  @override
  void didHaveMemoryPressure() {
    // TODO: implement didHaveMemoryPressure
    print('didHaveMemoryPressure');
  }

  @override
  Future<bool> didPopRoute() {
    // TODO: implement didPopRoute
    throw UnimplementedError();
  }

  @override
  Future<bool> didPushRoute(String route) {
    // TODO: implement didPushRoute
    throw UnimplementedError();
  }

  @override
  Future<bool> didPushRouteInformation(RouteInformation routeInformation) {
    // TODO: implement didPushRouteInformation
    throw UnimplementedError();
  }
}
