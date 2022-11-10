import 'package:flutter/material.dart';
import './transaction_item.dart';
import '../model/transaction.dart';


class TransactionList extends StatelessWidget {

final List<Transaction> transactions;
final Function deleteTx;
TransactionList(this.transactions,this.deleteTx);

  @override
  Widget build(BuildContext context) {
    print('build() Transaction_list');
    final mediaQuery = MediaQuery.of(context);
    return
      transactions.isEmpty? LayoutBuilder(builder: (ctx, constraints){
        return Column(
          children: [
            SizedBox(
              height: 10,
            ),
            Text(
              'No Transaction added yet!',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            SizedBox(
              height: 10,
            ),
            Container(
              height: constraints.maxHeight * 0.6,
              child: Image.asset('assets/images/waiting.png', fit: BoxFit.cover,),
            ),

          ],
        );
      }) : ListView.builder(
        itemBuilder: (ctx, index) {
          return TransactionItem(transaction: transactions[index], mediaQuery: mediaQuery, deleteTx: deleteTx);

        },
        itemCount: transactions.length,
    );
  }
}

