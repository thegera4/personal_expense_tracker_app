import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/transaction.dart';

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
    return SizedBox(
      height: 450,
      child: userTransactions.isEmpty ?
        Column(children: [
          Text(
            'No transactions added yet!', 
            style: Theme.of(context).textTheme.headline6
          ),
          SizedBox(
            height: 275,
            child: Image.asset(
              'assets/images/No data-rafiki.png', 
              fit: BoxFit.cover
            )
          ),
        ],) : 
        ListView.builder( 
          itemBuilder: (context, index) {
            return Card(
              elevation: 5,
              margin: const EdgeInsets.symmetric(
                vertical: 8, 
                horizontal: 20
              ),
              child: ListTile(
                leading: CircleAvatar(
                  radius: 30,
                  child: Padding(
                    padding: const EdgeInsets.all(6),
                    child: FittedBox(
                      child: Text('\$${userTransactions[index].amount}')
                    ),
                  ),
                ),
                title: Text(
                  userTransactions[index].title, 
                  style: Theme.of(context).textTheme.headline6
                ),
                subtitle: Text(
                  DateFormat.yMMMd().format(userTransactions[index].date)
                ),
                trailing: IconButton(
                  onPressed: () => deleteTransaction(userTransactions[index].id),
                  icon: const Icon(Icons.delete),
                  color: Theme.of(context).errorColor,
                ),
              ),
            );
        },
        itemCount: userTransactions.length,
        ),
    );
  }
}