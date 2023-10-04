import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:traxpense/data/expense_data.dart';

class MyPieChart extends StatelessWidget {
  final double totalAmount;
  final PieChart chartSections;
  const MyPieChart(
      {super.key, required this.totalAmount, required this.chartSections});

  @override
  Widget build(BuildContext context) {
    return Consumer<ExpenseData>(builder: (context, expenseData, child) {
      return SizedBox(
        height: 350,
        child: Column(
          children: [
            SizedBox(
              height: 70,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  const Padding(
                    padding: EdgeInsets.only(
                      // top: 40,
                      left: 20,
                    ),
                    child: Text(
                      "Total: ",
                      style: TextStyle(
                        fontSize: 25,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 0),
                    child: expenseData.calculateTotalExpense() % 1 == 0
                        ? Text(
                            "\$${expenseData.calculateTotalExpense().toInt()}",
                            style: const TextStyle(
                              fontSize: 25,
                            ),
                          )
                        : Text(
                            "\$${expenseData.calculateTotalExpense()}",
                            style: const TextStyle(
                              fontSize: 25,
                            ),
                          ),
                  )
                ],
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                const Padding(padding: EdgeInsets.only(left: 20)),
                SizedBox(
                  height: 250,
                  width: 250,
                  child: expenseData.getChartSections(),
                ),
                const Padding(padding: EdgeInsets.only(left: 5)),
                Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: expenseData.getIndicators(),
                ),
              ],
            ),
          ],
        ),
      );
    });
  }
}
