import 'package:flutter/material.dart';
import '../models/transaction.dart';
import 'package:intl/intl.dart';

class TransactionItem extends StatelessWidget {
  const TransactionItem({
    Key? key,
    required this.transaction,
    required this.deleteTransaction,
  }) : super(key: key);

  final Transaction transaction;
  final Function deleteTransaction;

  @override
  Widget build(BuildContext context) {
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
                child: Text('\$${transaction.amount}')
            ),
          ),
        ),
        title: Text(
            transaction.title,
            style: Theme.of(context).textTheme.headline6
        ),
        subtitle: Text(
            DateFormat.yMMMd().format(transaction.date)
        ),
        trailing: MediaQuery.of(context).size.width > 393 ? //to check if the device has a width greater than 393
        TextButton.icon(
          onPressed: () => deleteTransaction(transaction.id),
          icon: const Icon(Icons.delete),
          label: const Text('Delete'),
          style: TextButton.styleFrom(
              foregroundColor: Theme.of(context).errorColor
          ),
        ) :
        IconButton(
          onPressed: () => deleteTransaction(transaction.id),
          icon: const Icon(Icons.delete),
          color: Theme.of(context).errorColor,
        ),
      ),
    );
  }
}