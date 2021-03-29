import 'package:expense_tracker/constants.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:expense_tracker/home.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
  bool _darkMode = false;

  @override
  void initState() {
    super.initState();
    _loadUserPreferences();
  }

  void _loadUserPreferences() async {
    final prefs = await _prefs;

    if (prefs.containsKey(kSharedPrefsDarkMode)) {
      setState(() {
        _darkMode = prefs.getBool(kSharedPrefsDarkMode);
      });
    }
  }

  void _toggleDarkMode() async {
    final prefs = await _prefs;

    setState(() {
      _darkMode = !_darkMode;
    });

    prefs.setBool(kSharedPrefsDarkMode, _darkMode);
    // print(_darkMode);
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: _darkMode
          ? ThemeData.dark().copyWith(
              textTheme: ThemeData.dark().textTheme.copyWith(
                    headline6: kHeadLine6TextTheme,
                  ),
              appBarTheme: AppBarTheme(
                textTheme: ThemeData.dark().textTheme.copyWith(
                      headline6: kHeadLine6AppBarTheme,
                    ),
              ),
            )
          : ThemeData(
              primarySwatch: Colors.purple,
              accentColor: Colors.amber,
              fontFamily: 'Quicksand',
              textTheme: ThemeData.light().textTheme.copyWith(
                    headline6: kHeadLine6TextTheme,
                  ),
              appBarTheme: AppBarTheme(
                textTheme: ThemeData.light().textTheme.copyWith(
                      headline6: kHeadLine6AppBarTheme,
                    ),
              ),
            ),
      debugShowCheckedModeBanner: false,
      title: 'Flutter Expense App',
      home: MyHomePage(
        darkModeHandler: _toggleDarkMode,
      ),
    );
  }
}
