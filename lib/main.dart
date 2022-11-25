import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import './widgets/new_transaction.dart';
import './widgets/transaction_list.dart';
import '../models/transaction.dart';
import './widgets/chart.dart';

void main(){
  /*This is to lock the app to portrait mode
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]); */
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return Platform.isIOS ?
      const CupertinoApp(
        title: 'Expense Tracker',
        theme: CupertinoThemeData(
          primaryColor: Colors.green,
          primaryContrastingColor: Colors.orangeAccent,
          textTheme: CupertinoTextThemeData(
            primaryColor: Colors.white,
          ),
          barBackgroundColor: Colors.green,
          scaffoldBackgroundColor: Colors.white,
          brightness: Brightness.light,
        ),
        home: MyHomePage(title: 'Personal Expense Tracker'),
      ) :
      MaterialApp(
        title: 'Expense Tracker',
        theme: ThemeData(
          primarySwatch: Colors.green,
          colorScheme: ColorScheme
            .fromSwatch(primarySwatch: Colors.green)
            .copyWith(
              primary: Colors.green,
              secondary: Colors.orange,
              secondaryContainer: Colors.orange
            ),
          fontFamily: 'Quicksand',
          appBarTheme: AppBarTheme(
            toolbarTextStyle: ThemeData.light().textTheme.copyWith(
              headline6: const TextStyle(
                fontFamily: 'OpenSans',
                fontSize: 20,
              )
            ).bodyText2, titleTextStyle: ThemeData.light().textTheme.copyWith(
              headline6: const TextStyle(
                fontFamily: 'OpenSans',
                fontSize: 20,
              )
            ).headline6
          ),
          textTheme: ThemeData.light().textTheme.copyWith(
            headline6: TextStyle(
              fontFamily: 'OpenSans',
              fontSize: 18,
              fontWeight: FontWeight.bold,
              //color  primary color
              color: Colors.green[900],

            ),
          ),
        ),
        home: const MyHomePage(title: 'Personal Expense Tracker'),
      );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {

  final List<Transaction> _userTransactions = [
    /*Transaction(
      id: 't1',
      title: 'New Shoes',
      amount: 69.99,
      date: DateTime.now(),
    ),
    Transaction(
      id: 't2',
      title: 'Weekly Groceries',
      amount: 16.53,
      date: DateTime.now(),
    ),*/
  ];

  bool _showChart = false;

  List<Transaction> get _recentTransactions {
    return _userTransactions.where((transaction) {
      return transaction.date.isAfter(
        DateTime.now().subtract(
          const Duration(days: 7),
        ),
      );
    }).toList();
  }

  void _addNewTransaction(String title, double amount, DateTime date) {
    final newTransaction = Transaction(
      title: title,
      amount: amount,
      date: date,
      id: DateTime.now().toString(),
    );
    setState(() {
      _userTransactions.add(newTransaction);
    });
  }

  void _startAddNewTransaction(BuildContext ctx) {
    showModalBottomSheet(
      context: ctx,
      builder: (bCtx) {
        return NewTransaction(addNewTransaction: _addNewTransaction);
      },
    );
  }

  void _deleteTransaction(String id) {
    setState(() {
      _userTransactions.removeWhere((transaction) => transaction.id == id);
    });
  }

@override
  Widget build(BuildContext context) {

    final mediaQuery = MediaQuery.of(context); //for performance

    final isLandscape = mediaQuery.orientation == Orientation.landscape;

    final dynamic appBar = Platform.isIOS ?
      CupertinoNavigationBar(
        middle: const Text('Personal Expense Tracker'),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            GestureDetector(
            child: const Icon(CupertinoIcons.add),
            onTap: () => _startAddNewTransaction(context),
            )
          ],
        ),
      ) :
      AppBar(
        title: Text(widget.title),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () => _startAddNewTransaction(context),
          ),
        ],
      );

    final transactionListWidget = SizedBox(
        height: (MediaQuery.of(context).size.height -
            appBar.preferredSize.height -
            MediaQuery.of(context).padding.top) *
            0.7, //dynamic height based on screen size
        child: TransactionList(_userTransactions, _deleteTransaction)
    );

    final bodyPage = SafeArea(
      child: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            if(isLandscape) Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text('Show Chart'),
                Switch.adaptive( //adaptive adjust the look of the switch based on the platform
                  activeColor: Theme.of(context).colorScheme.secondary,
                  value: _showChart,
                  onChanged: (value) {
                    setState(() {
                      _showChart = value;
                    });
                  },
                ),
              ],
            ),
            if(!isLandscape) SizedBox(
              height: (mediaQuery.size.height -
                  appBar.preferredSize.height -
                  mediaQuery.padding.top) *
                  0.3,
              child: Chart(recentTransactions: _recentTransactions),
            ),
            if(!isLandscape) transactionListWidget,
            if(isLandscape) _showChart ? SizedBox(
                height: (mediaQuery.size.height -
                    appBar.preferredSize.height -
                    mediaQuery.padding.top) *
                    0.7,
                child: Chart(recentTransactions: _recentTransactions)
            ) : transactionListWidget,
          ],
        ),
      ),
    );

    return Platform.isIOS ?
      CupertinoPageScaffold(
        navigationBar: appBar,
        child: bodyPage,
      ) :
      Scaffold(
        appBar: appBar,
        body: bodyPage,
        floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
        floatingActionButton: Platform.isIOS ?
          Container() :
          FloatingActionButton(
            onPressed: () => _startAddNewTransaction(context),
            child: const Icon(Icons.add),
          ),
      );
  }
}
