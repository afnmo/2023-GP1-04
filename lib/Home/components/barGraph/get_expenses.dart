import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:gp91/Home/components/get_user_id.dart';

class GetExpenses {
  final QuerySnapshot billsDocuments;

  GetExpenses({required this.billsDocuments});

  Future<List<double>> getMontlhyAmounts() async {
    //GET THE USER ID
    final userId = await _getUserIdAsync();
    if (userId == null) {
      return [0.0, 0.0, 0.0, 0.0];
    }
// IF THE USER EXITS GET THE BILLS DOCUMENTS
    final bills = billsDocuments.docs;
// GET THE CURRENT DATE
    final currentDate = DateTime.now();

    double currentMonthAmount = 0; // THIS MONTH'S VARIBLE
    // THE PAST THREE MONTHS VARIABLES
    double firstMonthAmount = 0;
    double secondMonthAmount = 0;
    double thirdMonthAmount = 0;
// LOOP THROUGH THE BILLS DOCS
    for (var bill in bills) {
      var data = bill.data() as Map<String, dynamic>?;
      if (data != null) {
        if (kDebugMode) {
          print(data);
        }
// IF THERE ARE BILLS GET THE CURRENT BILL'S userID and Date and amount
        final billUserId = data['userId'] as String?;
        final billDate = data['date'] as String?;
        if (kDebugMode) {
          print("bill['amount']: ${data['amount']}");
        }

        // Safe casting as num?
        final billAmount = data['amount'] is num ? data['amount'] as num : null;
        if (kDebugMode) {
          print("billAmount: $billAmount");
        }

        if (billUserId == userId) {
          // if the bill belongs to the current user parse the date to get the month and the year
          // the date format is YYYY-MM-DD
          final parsedDate = DateTime.parse(billDate!);
          final billMonth = parsedDate.month;
          final billYear = parsedDate.year;
          // get the current year and month
          final currentMonth = currentDate.month;
          final currentYear = currentDate.year;
          // if the bill belongs to this month add it to the currentAmount variable
          if (billMonth == currentMonth && billYear == currentYear) {
            currentMonthAmount += billAmount ?? 0;
            // currentAmount += billAmount;
          } // the next if else's calculates the past three months with considration fspecial cases like JAN, FEB ,MARCH
          else if ((billMonth == (currentMonth - 1) % 12 &&
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
        if (kDebugMode) {
          print("Error: Document data is null.");
        }
        return [0.0, 0.0, 0.0, 0.0];
      }
    }
    return [
      currentMonthAmount,
      firstMonthAmount,
      secondMonthAmount,
      thirdMonthAmount
    ];
  }

  ////////////////////////////////////////////////////
  Future<List<double>> getAnnualAmounts() async {
    //get the user id
    final userId = await _getUserIdAsync();
    if (userId == null) {
      return [0.0, 0.0, 0.0, 0.0];
    }

    // IF THE USER EXITS GET THE BILLS DOCUMENTS
    final bills = billsDocuments.docs;
    //get current date
    final currentDate = DateTime.now();

    double currentYearAmount = 0; // variable for current year's amount
    // variables for past 3 years
    double firstYearAmount = 0;
    double secondYearAmount = 0;
    double thirdYearAmount = 0;
// LOOP THROUGH THE BILLS DOCS
    for (var bill in bills) {
      var data = bill.data() as Map<String, dynamic>?;
      if (data != null) {
        // if there are bills get the current bills userId, date and amount
        final billUserId = data['userId'] as String?;
        final billDate = data['date'] as String?;
        final billAmount = data['amount'] as num?;
        // if the bill belongs to this user parse its date to get the year
        if (billUserId == userId) {
          final parsedDate = DateTime.parse(billDate!);

          final billYear = parsedDate.year;
          // get the current year
          final currentYear = currentDate.year;
          // if the bill belongs to the current year add it to the variable
          if (billYear == currentYear) {
            currentYearAmount += billAmount ?? 0;
          } // the next if else's calculates the past 3 years
          else if (billYear == currentYear - 1) {
            firstYearAmount += billAmount ?? 0;
          } else if (billYear == currentYear - 2) {
            secondYearAmount += billAmount ?? 0;
          } else if (billYear == currentYear - 3) {
            thirdYearAmount += billAmount ?? 0;
          }
        }
      }
    }
    return [
      currentYearAmount,
      firstYearAmount,
      secondYearAmount,
      thirdYearAmount
    ];
  }

  /////////////////////////////////////////////////////
// so the calculations does not start untill the id is retrieved
  Future<String?> _getUserIdAsync() async {
    GetUserId getUserId = GetUserId();
    return await getUserId.getUserId();
  }
}
