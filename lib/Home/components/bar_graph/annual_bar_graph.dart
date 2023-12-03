import 'package:gp91/Home/components/bar_graph/bar_data.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class AnnualBarGraph extends StatelessWidget {
  final List<double> annualSummary;

  const AnnualBarGraph({Key? key, required this.annualSummary})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    //get the data
    // ignore: prefer_is_empty
    double firstYearAmount = annualSummary.length > 0 ? annualSummary[3] : 0;
    double secondYearAmount = annualSummary.length > 1 ? annualSummary[2] : 0;
    double thirdYearAmount = annualSummary.length > 2 ? annualSummary[1] : 0;
    double currentYearAmount = annualSummary.length > 3 ? annualSummary[0] : 0;
    double highestValue = 1000; //just to intilize the highestValue
    if (annualSummary.isNotEmpty) {
      // calculate the highest value to make it the max of the Y axis
      highestValue = annualSummary
          .reduce((value, element) => value > element ? value : element);
    }
    BarData myBarData = BarData(
      firstAmount: firstYearAmount,
      secondAmount: secondYearAmount,
      thirdAmount: thirdYearAmount,
      currentAmount: currentYearAmount,
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

// this method puts YEARS IN THE FORM YYYY = 2023 AND NOT 2K
Widget getBottomTitles(double value, TitleMeta meta) {
  const style = TextStyle(
    color: Color(0xFF6EA67C),
    fontSize: 14,
  );
  String currentYear = '';
  String firstYear = '';
  String secondYear = '';
  String thirdYear = '';
  final currentDate = DateTime.now();
  int nowYear = currentDate.year;
// Assign current YEAR name
  currentYear = nowYear.toString();
// Assign previous YEARS names
  thirdYear = (nowYear - 1).toString();
  secondYear = (nowYear - 2).toString();
  firstYear = (nowYear - 3).toString();

  Widget text;
  switch (value.toInt()) {
    case 0:
      text = Text(
        firstYear,
        style: style,
      );
      break;
    case 1:
      text = Text(
        secondYear,
        style: style,
      );
      break;
    case 2:
      text = Text(
        thirdYear,
        style: style,
      );
      break;
    case 3:
      text = Text(
        currentYear,
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
