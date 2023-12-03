import 'package:gp91/Home/components/barGraph/bar_data.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class MonthlyBarGraph extends StatelessWidget {
  final List<double> monthlySummary;

  const MonthlyBarGraph({Key? key, required this.monthlySummary})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    //get the data
    // ignore: prefer_is_empty
    double firstAmount = monthlySummary.length > 0 ? monthlySummary[3] : 0;
    double secondAmount = monthlySummary.length > 1 ? monthlySummary[2] : 0;
    double thirdAmount = monthlySummary.length > 2 ? monthlySummary[1] : 0;
    double currentAmount = monthlySummary.length > 3 ? monthlySummary[0] : 0;
    double highestValue = 1000; //just to intilize the highestValue
    if (monthlySummary.isNotEmpty) {
      // calculate the highest value to make it the max of the Y axis
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
        gridData: const FlGridData(show: false),
        titlesData: const FlTitlesData(
          show: true,
          // remove top and right title and get special bottom titles from the getBottomTitles method
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
                      color: const Color.fromRGBO(254, 156, 2, 1),
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

// this method puts month names as the x axis bottom titles
Widget getBottomTitles(double value, TitleMeta meta) {
  const style = TextStyle(
    color: Color(0xFF6EA67C),
    fontSize: 14,
  );
  // intialize the strings
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
  return SideTitleWidget(axisSide: meta.axisSide, child: text);
}
