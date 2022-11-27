import 'package:flutter/material.dart';
import '../models/transaction.dart';
import './transaction_item.dart';

class TransactionList extends StatelessWidget {

  final List<Transaction> userTransactions;
  final Function deleteTransaction;

  const TransactionList(
    this.userTransactions, 
    this.deleteTransaction, 
    {super.key}
  );

  @override
  Widget build(BuildContext context) {
    return userTransactions.isEmpty ?
        LayoutBuilder(builder: (context, constraints){
          return Column(
            children: [
              Text(
              'No transactions added yet!',
              style: Theme.of(context).textTheme.headline6
              ),
              SizedBox(
                height: constraints.maxHeight * 0.8,
                child: Image.asset(
                  'assets/images/No data-rafiki.png',
                  fit: BoxFit.cover
                ),
              ),
            ],
          );
        }) :
        ListView(
          children: [
            ...userTransactions.map((transaction) => TransactionItem(
              key: ValueKey(transaction.id),
              transaction: transaction,
              deleteTransaction: deleteTransaction,
            )).toList(),
          ],
        );
  }
}