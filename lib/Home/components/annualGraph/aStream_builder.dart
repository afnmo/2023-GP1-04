import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:gp91/Home/components/getUserId.dart';

class StreamBuilderAnnual {
  final Stream<QuerySnapshot> stream;

  StreamBuilderAnnual({required this.stream});

  Future<List<double>> getAnnualAmounts() async {
    final userId = await _getUserIdAsync();
    if (userId == null) {
      return [0.0, 0.0, 0.0, 0.0];
    }

    final snapshot = await stream.first;
    final bills = snapshot.docs;
    final currentDate = DateTime.now();

    double currentAmount = 0;
    double firstYearAmount = 0;
    double secondYearAmount = 0;
    double thirdYearAmount = 0;

    for (var bill in bills) {
      final billUserId = bill['userId'] as String?;
      final billDate = bill['date'] as String?;
      final billAmount = bill['amount'] as num?;

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

    return [currentAmount, firstYearAmount, secondYearAmount, thirdYearAmount];
  }

  Future<String?> _getUserIdAsync() async {
    GetUserId getUserId = GetUserId();
    return await getUserId.getUserId();
  }
}
