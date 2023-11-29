import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:gp91/Home/components/getUserId.dart';

class StreamBuilderExample {
  final QuerySnapshot billsDocuments;

  StreamBuilderExample({required this.billsDocuments});

  Future<List<double>> getAmounts() async {
    final userId = await _getUserIdAsync();
    if (userId == null) {
      return [0.0, 0.0, 0.0, 0.0];
    }

    final bills = billsDocuments.docs;

    final currentDate = DateTime.now();

    double currentAmount = 0;
    double firstMonthAmount = 0;
    double secondMonthAmount = 0;
    double thirdMonthAmount = 0;

    for (var bill in bills) {
      var data = bill.data() as Map<String, dynamic>?;
      if (data != null) {
        print(data);

        final billUserId = data['userId'] as String?;
        final billDate = data['date'] as String?;
        print("bill['amount']: ${data['amount']}");

        // Safe casting as num?
        final billAmount = data['amount'] is num ? data['amount'] as num : null;
        print("billAmount: ${billAmount}");

        if (billUserId == userId) {
          final parsedDate = DateTime.parse(billDate!);
          final billMonth = parsedDate.month;
          final billYear = parsedDate.year;

          final currentMonth = currentDate.month;
          final currentYear = currentDate.year;

          if (billMonth == currentMonth && billYear == currentYear) {
            currentAmount += billAmount ?? 0;
            // currentAmount += billAmount;
          } else if ((billMonth == (currentMonth - 1) % 12 &&
                  billYear == currentYear - (currentMonth == 1 ? 1 : 0)) ||
              (billMonth == currentMonth &&
                  currentMonth == 1 &&
                  billYear == currentYear - 1)) {
            firstMonthAmount += billAmount ?? 0;
          } else if ((billMonth == (currentMonth - 2) % 12 &&
                  billYear == currentYear - (currentMonth <= 2 ? 1 : 0)) ||
              (billMonth == currentMonth &&
                  currentMonth <= 2 &&
                  billYear == currentYear - 1)) {
            secondMonthAmount += billAmount ?? 0;
          } else if ((billMonth == (currentMonth - 3) % 12 &&
                  billYear == currentYear - (currentMonth <= 3 ? 1 : 0)) ||
              (billMonth == currentMonth &&
                  currentMonth <= 3 &&
                  billYear == currentYear - 1)) {
            thirdMonthAmount += billAmount ?? 0;
          }
        }
      } else {
        // Handle the case where data is null
        print("Error: Document data is null.");
        return [];
      }

      // return [
      //   currentAmount,
      //   firstMonthAmount,
      //   secondMonthAmount,
      //   thirdMonthAmount
      // ];
    }
    return [
      currentAmount,
      firstMonthAmount,
      secondMonthAmount,
      thirdMonthAmount
    ];
  }

  Future<String?> _getUserIdAsync() async {
    GetUserId getUserId = GetUserId();
    return await getUserId.getUserId();
  }
}
