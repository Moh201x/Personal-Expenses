// ignore_for_file: prefer_interpolation_to_compose_strings, sort_child_properties_last
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:intl/intl.dart';
import 'package:test_app/models/Trans.dart';
import 'package:flutter/material.dart';

class Transactionlist extends StatelessWidget {
  List<Transactions> translist;
  Function deleteTx;
  Transactionlist(this.translist, this.deleteTx);
  @override
  Widget build(BuildContext context) {
    return translist.isEmpty
        ? LayoutBuilder(builder: (_, cons) {
            return Column(
              children: [
                const SizedBox(
                  height: 10,
                ),
                Image.asset(
                  height: cons.maxHeight * 0.6,
                  'assets/images/waiting.png',
                  fit: BoxFit.cover,
                ),
                const SizedBox(
                  height: 10,
                ),
                Text(
                  "No Transations yet !",
                  style: Theme.of(context).textTheme.headline1,
                )
              ],
            );
          })
        : ListView.builder(
            itemBuilder: (context, index) {
              return Card(
                elevation: 5,
                margin: const EdgeInsets.symmetric(
                  vertical: 8,
                  horizontal: 5,
                ),
                child: ListTile(
                  leading: CircleAvatar(
                    radius: 30,
                    child: Padding(
                      padding: const EdgeInsets.all(6),
                      child: FittedBox(
                        child: Text('\$${translist[index].amount}'),
                      ),
                    ),
                  ),
                  title: Text(
                    translist[index].title,
                    style: Theme.of(context).textTheme.headline1,
                  ),
                  subtitle: Text(
                    DateFormat.yMMMd().format(translist[index].date),
                  ),
                  trailing: IconButton(
                    icon: const Icon(Icons.delete),
                    color: Theme.of(context).errorColor,
                    onPressed: () => deleteTx(translist[index].id),
                  ),
                ),
              );
            },
            itemCount: translist.length,
            //we can use a container with height
          );
  }
}
