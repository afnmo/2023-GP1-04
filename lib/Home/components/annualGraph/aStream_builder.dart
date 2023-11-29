import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:gp91/Home/components/getUserId.dart';

class StreamBuilderAnnual {
  final QuerySnapshot billsDocuments;

  StreamBuilderAnnual({required this.billsDocuments});

  Future<List<double>> getAnnualAmounts() async {
    final userId = await _getUserIdAsync();
    if (userId == null) {
      return [0.0, 0.0, 0.0, 0.0];
    }

    // final snapshot = await stream.first;
    final bills = billsDocuments.docs;
    final currentDate = DateTime.now();

    double currentAmount = 0;
    double firstYearAmount = 0;
    double secondYearAmount = 0;
    double thirdYearAmount = 0;

    for (var bill in bills) {
      var data = bill.data() as Map<String, dynamic>?;
      if (data != null) {
        final billUserId = data['userId'] as String?;
        final billDate = data['date'] as String?;
        final billAmount = data['amount'] as num?;

        if (billUserId == userId) {
          final parsedDate = DateTime.parse(billDate!);

          final billYear = parsedDate.year;

          final currentYear = currentDate.year;

          if (billYear == currentYear) {
            currentAmount += billAmount ?? 0;
          } else if (billYear == currentYear - 1) {
            firstYearAmount += billAmount ?? 0;
          } else if (billYear == currentYear - 2) {
            secondYearAmount += billAmount ?? 0;
          } else if (billYear == currentYear - 3) {
            thirdYearAmount += billAmount ?? 0;
          }
        }
      }
    }
    return [currentAmount, firstYearAmount, secondYearAmount, thirdYearAmount];
  }

  Future<String?> _getUserIdAsync() async {
    GetUserId getUserId = GetUserId();
    return await getUserId.getUserId();
  }
}
