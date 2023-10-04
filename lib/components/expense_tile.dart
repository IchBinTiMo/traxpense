import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

class ExpenseTile extends StatelessWidget {
  final num expIndex;
  final num? expLength;
  final Icon? type;
  final String name;
  final String amount;
  final DateTime? datetime;
  final Function(BuildContext)? addExpense;
  final Function(BuildContext)? deleteExpense;

  const ExpenseTile(
      {super.key,
      required this.expIndex,
      required this.expLength,
      required this.type,
      required this.name,
      required this.amount,
      required this.datetime,
      required this.addExpense,
      required this.deleteExpense});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(
          top: expIndex == 1 ? 2 : 1,
          left: 1,
          right: 1,
          bottom: expIndex == expLength! ? 2 : 1),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.primary,
        // borderRadius: BorderRadius.circular(10),
      ),
      child: Container(
        decoration: BoxDecoration(
          border: Border.all(
            color: Theme.of(context).colorScheme.primary,
          ),
          borderRadius: BorderRadius.circular(10),
          color: Theme.of(context).colorScheme.background,
        ),
        child: (datetime != null)
            ? Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: Colors.red.shade300,
                ),
                child: Slidable(
                  endActionPane: ActionPane(
                    extentRatio: 0.25,
                    motion: const ScrollMotion(),
                    children: [
                      SlidableAction(
                        onPressed: deleteExpense,
                        icon: Icons.delete,
                        foregroundColor: Colors.grey.shade900,
                        backgroundColor: Colors.red.shade300,
                        borderRadius: BorderRadius.circular(10),
                      )
                    ],
                  ),
                  child: Container(
                    decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.background,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: ListTile(
                      leading: type,
                      title: Text(name),
                      trailing: Text("\$$amount"),
                      subtitle: Text(
                          "${datetime!.year} / ${datetime!.month} / ${datetime!.day}"),
                    ),
                  ),
                ),
              )
            : Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: Colors.green.shade300,
                ),
                child: Slidable(
                  endActionPane: ActionPane(
                    extentRatio: 0.25,
                    motion: const ScrollMotion(),
                    children: [
                      SlidableAction(
                        onPressed: addExpense,
                        icon: Icons.add_circle_outline_sharp,
                        foregroundColor: Colors.grey.shade900,
                        backgroundColor: Colors.green.shade300,
                        borderRadius: BorderRadius.circular(10),
                      )
                    ],
                  ),
                  child: Container(
                    decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.background,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: ListTile(
                      leading: type,
                      title: Text(name),
                      trailing: const Text(" "),
                      subtitle: const Text(" "),
                    ),
                  ),
                ),
              ),
      ),
    );
  }
}
