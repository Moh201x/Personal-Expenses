import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:test_app/models/Trans.dart';
import 'package:intl/intl.dart';

import 'chart_bar.dart';

class Chart extends StatelessWidget {
  final List<Transactions> recent_trans;
  const Chart(this.recent_trans);

  List<Map<String, Object>> get Transactions_values {
    return List.generate(7, (index) {
      final weekday = DateTime.now().subtract(Duration(days: index));
      double totalSum = 0;
      for (var i = 0; i < recent_trans.length; i++) {
        if (recent_trans[i].date.day == weekday.day &&
            recent_trans[i].date.month == weekday.month &&
            recent_trans[i].date.year == weekday.year) {
          totalSum += recent_trans[i].amount;
        }
      }
      return {
        'Day': DateFormat.E().format(weekday).substring(0, 1),
        'Amount': totalSum
      };
    }).reversed.toList();
  }

  double get getAllSum {
    return Transactions_values.fold(0.0, (sum, arr) {
      return sum + (arr['Amount'] as double);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 6,
      margin: EdgeInsets.all(20),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(mainAxisAlignment: MainAxisAlignment.spaceAround, children: [
          ...Transactions_values.map((data) {
            return Flexible(
              fit: FlexFit.loose,
              child: ChartBar(data['Day'] as String, data['Amount'] as double,
                  getAllSum == 0 ? 0 : (data['Amount'] as double) / getAllSum),
            );
          }).toList(),
        ]),
      ),
    );
  }
}
