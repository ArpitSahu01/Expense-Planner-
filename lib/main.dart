import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import './widgets/new_transaction.dart';
import './model/transaction.dart';
import './widgets/transaction_list.dart';
import './widgets/chart.dart';


void main() {

  // WidgetsFlutterBinding.ensureInitialized();
  // SystemChrome.setPreferredOrientations([
  //   DeviceOrientation.portraitUp,
  //   DeviceOrientation.portraitDown
  // ]);

  runApp(MyApp());

}

class MyApp extends StatelessWidget {
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Expence Planner',
      theme: ThemeData(
        primarySwatch: Colors.deepPurple,
        fontFamily: 'Quicksand',
        errorColor: Colors.blue,
        textTheme: ThemeData.light().textTheme.copyWith(
          headline6: TextStyle(
            fontFamily: 'Quicksand',
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),
          button: TextStyle(color: Colors.white),
        ),
        appBarTheme: AppBarTheme(
          titleTextStyle: TextStyle(
              fontFamily: 'OpenSans',
              fontSize: 20,
              fontWeight: FontWeight.bold,
          ),
        ),

      ),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {

  @override
  State<MyHomePage> createState() => _MyHomePageState();

}


class _MyHomePageState extends State<MyHomePage> with WidgetsBindingObserver{

final List<Transaction> _userTransactions = [

  // Transaction(
  //   id: 't1',
  //   title: 'New Shoes',
  //   amount: 1200,
  //   date: DateTime.now(),
  // ),
  //
  // Transaction(
  //   id: 't2',
  //   title: 'Weekly Groceries',
  //   amount: 8000,
  //   date: DateTime.now(),
  // ),

];

bool _showChart = false;


@override
void initState(){
  WidgetsBinding.instance.addObserver(this);
  super.initState();
}

@override
void didChangeAppLifecycleState(AppLifecycleState state){
print(state);
}

@override
dispose(){
  WidgetsBinding.instance.removeObserver(this);
  super.dispose();
}

  List<Transaction> get _recentTransactions{
  return _userTransactions.where((tx){
    return tx.date!.isAfter(DateTime.now().subtract(Duration(days: 7),),
    );
  }).toList();
 }

void _addTransaction(String txTitle,double txAmount,DateTime chosenDate){

  final newTx =Transaction(
      id: DateTime.now().toString(),
      title: txTitle,
      amount: txAmount,
      date: chosenDate
  );

  setState(() {
    _userTransactions.add(newTx);
  });

}

void _deleteTransaction(String id){
    setState(() {
      _userTransactions.removeWhere((element) => element.id == id);
    });
}


void _startAddNewTransaction(BuildContext ctx){
  showModalBottomSheet(context: ctx, builder: (_){
    return GestureDetector(
      onTap: (){},
      child:NewTransaction(_addTransaction),
      behavior: HitTestBehavior.opaque,
    );
  },);
}

List<Widget> _buildLandscapeContent(AppBar appBar,Widget txListWidget){
    return [Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Text("Show Chart"),
        Switch.adaptive(value: _showChart, onChanged: (val){
          setState(() {
            _showChart = val;
          });
        },),
      ],
    ),_showChart ? Container(
      height: (MediaQuery.of(context).size.height-appBar.preferredSize.height-MediaQuery.of(context).padding.top)*0.6,
      child: Chart(_recentTransactions),
    ): txListWidget];
}

List<Widget> _buildPotraitContent(AppBar appBar,Widget txListWidget){
    return [Container(
      height: (MediaQuery.of(context).size.height-appBar.preferredSize.height-MediaQuery.of(context).padding.top)*0.3,
      child: Chart(_recentTransactions),
    ),txListWidget];
}

  Widget build(BuildContext context) {
    print('build() main');
    final isLandscape = MediaQuery.of(context).orientation == Orientation.landscape;

    final appBar = AppBar(
      title: Text('Expence Planner',),
      actions: [
        IconButton(onPressed: () => _startAddNewTransaction(context), icon: Icon(Icons.add),)
      ],
    );

    final txListWidget =Container(
      height: (MediaQuery.of(context).size.height-appBar.preferredSize.height-MediaQuery.of(context).padding.top)*0.7,
      child: TransactionList(_userTransactions,_deleteTransaction),
    );

    return Scaffold(


      appBar: appBar,
      body: Column(
        // mainAxisAlignment: MainAxisAlignment.spaceAround,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          if(isLandscape) ..._buildLandscapeContent(appBar,txListWidget),

          if(!isLandscape) ..._buildPotraitContent(appBar,txListWidget),

        ],
      ),

      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: Platform.isIOS ? Container() : FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () => _startAddNewTransaction(context),
      ),

    );
  }
}
