import 'package:gp91/Home/components/annualGraph/aBar_data.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class annualBarGraph extends StatelessWidget {
  final List<double> annualSummary;

  const annualBarGraph({Key? key, required this.annualSummary})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    double firstYearAmount = annualSummary.length > 0 ? annualSummary[3] : 0;
    double secondYearAmount = annualSummary.length > 1 ? annualSummary[2] : 0;
    double thirdYearAmount = annualSummary.length > 2 ? annualSummary[1] : 0;
    double currentYearAmount = annualSummary.length > 3 ? annualSummary[0] : 0;
    double highestValue = 1000;
    if (!annualSummary.isEmpty) {
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
  String currentYear = '';
  String firstYear = '';
  String secondYear = '';
  String thirdYear = '';
  final currentDate = DateTime.now();
  int nowYear = currentDate.year;
// Assign current month name
  currentYear = nowYear.toString();
// Assign previous month names
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
  return SideTitleWidget(child: text, axisSide: meta.axisSide);
}
