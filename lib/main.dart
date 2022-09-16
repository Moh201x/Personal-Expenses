// ignore_for_file: sort_child_properties_last, prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:test_app/chart.dart';
import 'package:test_app/tansaction_list.dart';
import 'package:test_app/user_input_transaction.dart';
import 'models/Trans.dart';
import 'package:intl/intl.dart';

void main() {
  // WidgetsFlutterBinding.ensureInitialized();
  // SystemChrome.setPreferredOrientations(
  //     [DeviceOrientation.portraitDown, DeviceOrientation.portraitUp]);
  runApp(HomePage());
}

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
          primarySwatch: Colors.purple,
          accentColor: Colors.amber,
          fontFamily: 'Quicksand',
          appBarTheme: AppBarTheme(
              titleTextStyle: TextStyle(
                  fontSize: 20,
                  fontFamily: "OpenSans",
                  fontWeight: FontWeight.bold)),
          textTheme: TextTheme(
              headline1: TextStyle(
                  fontFamily: "OpenSans",
                  fontSize: 18,
                  fontWeight: FontWeight.bold))),
      debugShowCheckedModeBanner: false,
      home: MyWidget(),
    );
  }
}

class MyWidget extends StatefulWidget {
  @override
  State<MyWidget> createState() => _MyWidgetState();
}

class _MyWidgetState extends State<MyWidget> with WidgetsBindingObserver {
  final List<Transactions> _userTransactions = [
    // Transactions(
    //     id: "t1", title: "New Shows", amount: 20, date: DateTime.now()),
    // Transactions(
    //     id: "t2", title: "New Laptop", amount: 500, date: DateTime.now()),
    // Transactions(
    //     id: "t3", title: "New Screen", amount: 200, date: DateTime.now())
  ];

  // @override
  // void initState() {
  //   WidgetsBinding.instance.addObserver(this);
  //   super.initState();
  // }

  // @override
  // void didChangeAppLifecycleState(AppLifecycleState state) {
  //   print(state);
  //   super.didChangeAppLifecycleState(state);
  // }

  // @override
  // void dispose() {
  //   WidgetsBinding.instance.removeObserver(this);
  //   super.dispose();
  // }

  void _add_item(String title, double amount, DateTime date) {
    Transactions item = Transactions(
        id: DateTime.now().toString(),
        title: title,
        amount: amount,
        date: date);
    setState(() {
      _userTransactions.add(item);
    });
  }

  void deleteTx(String id) {
    setState(() {
      _userTransactions.removeWhere((element) => element.id == id);
    });
  }

  void start_new_transaction(BuildContext ctx) {
    showModalBottomSheet(
        context: ctx,
        builder: (_) {
          return user_input_transaction(_add_item);
        });
  }

  List<Transactions> fillter_transactions() {
    return _userTransactions.where((tx) {
      return tx.date.isAfter(DateTime.now().subtract(Duration(days: 7)));
    }).toList();
  }

  bool showChart = false;
  Widget bulidPortraitMode(
      double media_height, double media_padding_top, AppBar appbar) {
    return Container(
        height:
            (media_height - appbar.preferredSize.height - media_padding_top) *
                0.3,
        child: Chart(fillter_transactions()));
  }

  Widget bulidLandscapeMode(
      double media_height, double media_padding_top, AppBar appbar) {
    return Container(
        height:
            (media_height - appbar.preferredSize.height - media_padding_top) *
                0.7,
        child: Chart(fillter_transactions()));
  }

  @override
  Widget build(BuildContext context) {
    final Mediaquery = MediaQuery.of(context);

    final isLandscape = Mediaquery.orientation == Orientation.landscape;
    final appbar = AppBar(
      title: Text("Personal Expenses"),
      actions: [
        Builder(builder: (context) {
          return IconButton(
              onPressed: () {
                start_new_transaction(context);
              },
              icon: Icon(Icons.add));
        })
      ],
    );
    return Scaffold(
        appBar: appbar,
        body: SingleChildScrollView(
          child: Column(
            //mainAxisAlignment: MainAxisAlignment.spaceAround,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              if (isLandscape)
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text("Show Chart"),
                    Switch(
                        value: showChart,
                        onChanged: (val) {
                          setState(() {
                            showChart = val;
                          });
                        })
                  ],
                ),
              if (!isLandscape)
                bulidPortraitMode(
                    Mediaquery.size.height, Mediaquery.padding.top, appbar),
              if (isLandscape)
                showChart == true
                    ? bulidLandscapeMode(
                        Mediaquery.size.height, Mediaquery.padding.top, appbar)
                    : Container(),
              Container(
                  height: (Mediaquery.size.height -
                          appbar.preferredSize.height -
                          Mediaquery.padding.top) *
                      0.6,
                  child: Transactionlist(_userTransactions, deleteTx))
            ],
          ),
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
        floatingActionButton: FloatingActionButton(
            child: Icon(Icons.add),
            onPressed: () => start_new_transaction(context)));
  }
}
