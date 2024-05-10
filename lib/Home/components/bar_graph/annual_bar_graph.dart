import 'package:gp91/Home/components/bar_graph/bar_data.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class AnnualBarGraph extends StatelessWidget {
  final List<double> annualSummary;

  const AnnualBarGraph({Key? key, required this.annualSummary})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Initialize variables to store amounts
    double firstYearAmount = 0;
    double secondYearAmount = 0;
    double thirdYearAmount = 0;
    double currentYearAmount = 0;


    // Check if the annualSummary list has enough elements before accessing them
    if (annualSummary.length > 0) {
      currentYearAmount = annualSummary[0];
    }
    if (annualSummary.length > 1) {
      thirdYearAmount = annualSummary[1];
    }
    if (annualSummary.length > 2) {
      secondYearAmount = annualSummary[2];
    }
    if (annualSummary.length > 3) {
      firstYearAmount = annualSummary[3];
    }

    // Calculate the highest value for Y-axis
    double highestValue = annualSummary.isNotEmpty
        ? annualSummary
            .reduce((value, element) => value > element ? value : element)
        : 1000; // Default value if annualSummary is empty

    BarData myBarData = BarData(
      firstAmount: firstYearAmount,
      secondAmount: secondYearAmount,
      thirdAmount: thirdYearAmount,
      currentAmount: currentYearAmount,
    );
    myBarData.initializeBarData();

    return BarChart(
      BarChartData(
        maxY: highestValue + 100,
        minY: 0,
        gridData: const FlGridData(show: false),
        titlesData: const FlTitlesData(
          show: true,
          // Remove top and right title and get special bottom titles from the getBottomTitles method
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

// This method puts YEARS IN THE FORM YYYY = 2023 AND NOT 2K
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
