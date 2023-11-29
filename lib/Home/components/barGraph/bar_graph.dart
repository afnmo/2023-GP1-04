import 'package:gp91/Home/components/barGraph/bar_data.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class MyBarGraph extends StatelessWidget {
  final List<double> monthlySummary;

  const MyBarGraph({Key? key, required this.monthlySummary}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    double firstAmount = monthlySummary.length > 0 ? monthlySummary[3] : 0;
    double secondAmount = monthlySummary.length > 1 ? monthlySummary[2] : 0;
    double thirdAmount = monthlySummary.length > 2 ? monthlySummary[1] : 0;
    double currentAmount = monthlySummary.length > 3 ? monthlySummary[0] : 0;
    double highestValue = 1000;
    if (!monthlySummary.isEmpty) {
      highestValue = monthlySummary
          .reduce((value, element) => value > element ? value : element);
    }
    BarData myBarData = BarData(
      firstAmount: firstAmount,
      secondAmount: secondAmount,
      thirdAmount: thirdAmount,
      currentAmount: currentAmount,
    );
    myBarData.initializeBarData();

    return BarChart(
      BarChartData(
        maxY: highestValue,
        minY: 0,
        //backgroundColor: Color.fromRGBO(220, 220, 220, 100),
        gridData: FlGridData(show: false),
        titlesData: FlTitlesData(
          show: true,
          topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
          rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
          bottomTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              getTitlesWidget: getBottomTitles,
            ),
          ),
        ),
        barGroups: myBarData.barData
            .map((data) => BarChartGroupData(
                  x: data.x,
                  barRods: [
                    BarChartRodData(
                      toY: data.y,
                      color: Color.fromRGBO(254, 156, 2, 1),
                      width: 30,
                      borderRadius: BorderRadius.circular(2),
                    )
                  ],
                ))
            .toList(),
      ),
    );
  }
}

Widget getBottomTitles(double value, TitleMeta meta) {
  const style = TextStyle(
    color: Color(0xFF6EA67C),
    //fontWeight: FontWeight.bold,
    fontSize: 14,
  );
  String currentMonth = '';
  String firstMonth = '';
  String secondMonth = '';
  String thirdMonth = '';
  DateTime now = DateTime.now();
  int currentMonthIndex = now.month - 1;
  // Define a list of month names
  List<String> monthNames = [
    'Jan',
    'Feb',
    'Mar',
    'Apr',
    'May',
    'Jun',
    'Jul',
    'Aug',
    'Sep',
    'Oct',
    'Nov',
    'Dec',
  ];

// Assign current month name
  currentMonth = monthNames[currentMonthIndex];
// Calculate previous month indices (taking care of January)
  int thirdMonthIndex = (currentMonthIndex - 1 + 12) % 12;
  int secondMonthIndex = (currentMonthIndex - 2 + 12) % 12;
  int firstMonthIndex = (currentMonthIndex - 3 + 12) % 12;

// Assign previous month names
  thirdMonth = monthNames[thirdMonthIndex];
  secondMonth = monthNames[secondMonthIndex];
  firstMonth = monthNames[firstMonthIndex];

  Widget text;
  switch (value.toInt()) {
    case 0:
      text = Text(
        firstMonth,
        style: style,
      );
      break;
    case 1:
      text = Text(
        secondMonth,
        style: style,
      );
      break;
    case 2:
      text = Text(
        thirdMonth,
        style: style,
      );
      break;
    case 3:
      text = Text(
        currentMonth,
        style: style,
      );
      break;
    default:
      text = const Text(
        ' ',
        style: style,
      );
      break;
  }
  return SideTitleWidget(child: text, axisSide: meta.axisSide);
}
