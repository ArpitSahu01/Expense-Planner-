import 'dart:math';
import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import '../model/transaction.dart';

class TransactionItem extends StatefulWidget {
  const TransactionItem({
    Key? key,
    required this.transaction,
    required this.mediaQuery,
    required this.deleteTx,
  }) : super(key: key);

  final Transaction transaction;
  final MediaQueryData mediaQuery;
  final Function deleteTx;

  @override
  State<TransactionItem> createState() => _TransactionItemState();
}

class _TransactionItemState extends State<TransactionItem> {

  Color? _bgColor;

  @override
  void initState() {
    const availableColor = [Colors.red,Colors.blue,Colors.black,Colors.purple,];
    _bgColor = availableColor[Random().nextInt(4)];

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 5,
      margin: EdgeInsets.symmetric(vertical: 7,horizontal: 5),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: _bgColor,
          radius: 30,
          child: Padding(
            padding: const EdgeInsets.all(6.0),
            child: FittedBox(
              child:Text('\$${widget.transaction.amount}'),
            ),
          ),
        ),
        title: Text(
          widget.transaction.title as String,
          style: Theme.of(context).textTheme.titleLarge,
        ),
        subtitle: Text(DateFormat.yMMMd().format(widget.transaction.date as DateTime),),
        trailing: widget.mediaQuery.size.width > 400 ? TextButton.icon(
          icon: Icon(Icons.delete),
          label: Text("Delete"),
          style: TextButton.styleFrom(foregroundColor: Theme.of(context).errorColor, ),
          onPressed: ()=> widget.deleteTx(widget.transaction.id ),
        ):IconButton(
          icon: Icon(Icons.delete),
          color: Theme.of(context).errorColor,
          onPressed: ()=> widget.deleteTx(widget.transaction.id ),
        ),

      ),

    );
  }
}
