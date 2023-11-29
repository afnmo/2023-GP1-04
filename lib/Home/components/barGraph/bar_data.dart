import 'package:gp91/Home/components/barGraph/bar.dart';

class BarData {
  final double firstAmount;
  final double secondAmount;
  final double thirdAmount;
  final double currentAmount;

  List<Bar> barData = [];

  BarData({
    required this.firstAmount,
    required this.secondAmount,
    required this.thirdAmount,
    required this.currentAmount,
  });

  void initializeBarData() {
    barData = [
      Bar(x: 0, y: firstAmount),
      Bar(x: 1, y: secondAmount),
      Bar(x: 2, y: thirdAmount),
      Bar(x: 3, y: currentAmount),
    ];
  }
}
