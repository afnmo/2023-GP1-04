
import 'package:gp91/consumption/fuel_firebase.dart';

class FuelCalculation {
  // fuel type retrieval:

  Future<String?> getUserId() async {
    String? userId = await FuelFirebase().getUserDocumentIdByEmail();
    return userId;
  }
  

  Future<double> getLitersConsumed(
      String documentCarId, String startDate, String endDate) async {
    try {
      Map<String, dynamic>? carData =
          await FuelFirebase().fetchCarDoc(documentCarId);

      if (carData.isNotEmpty) {
        String fuelType = carData['fuelType'] as String? ?? 'Unknown';
        double costPerLiter = 0;
        if (fuelType == "91") {
          costPerLiter = 2.18;
        } else if (fuelType == "95") {
          costPerLiter = 2.33;
        } else if (fuelType == "Diesel") {
          costPerLiter = 0.75;
        }
        print('Fuel Type: $fuelType');
        print("costPerLiter: $costPerLiter");

        // double expenses = 500;
        double expenses =
            await getTotalFuelExpenses(documentCarId, startDate, endDate);
        print("expenses: ");
        print(expenses);
        double litersConsumed = expenses / costPerLiter;
        print("litersConsumed: ${litersConsumed}");
        return litersConsumed;

        // You can use these variables as needed in your application
      } else {
        print('User has no cars.');
        return -1;
      }
    } catch (e) {
      print('An error occurred: $e');
      return -1;
    }
  }

  double getCalculatedFuelEconomy(
      double litersConsumed, double startMileage, double endMileage) {
    double calculatedFuelEconomy = (endMileage - startMileage) / litersConsumed;
    print("litersConsumed: ${litersConsumed}");
    print(
        "Mileage Difference: ${endMileage} - ${startMileage} = ${(endMileage - startMileage)}");
    print("calculatedFuelEconomy: ${calculatedFuelEconomy}");
    return (calculatedFuelEconomy * 10).round() / 10;
  }

  //   3) Percentage Difference=(Default Fuel Economy ∣Default Fuel Economy−Calculated Fuel Economy∣)×100

  Future<String> getPercentageDifference(
      String documentCarId, double calculatedFuelEconomy) async {
    try {
      Map<String, dynamic>? carData =
          await FuelFirebase().fetchCarDoc(documentCarId);
      if (carData.isNotEmpty) {
        double defualtFuelEconomy =
            double.tryParse(carData['fuelEconomy'] ?? '0') ?? 0.0;
        print("defualtFuelEconomy: ${defualtFuelEconomy}");
        double percentageDifference =
            ((defualtFuelEconomy - calculatedFuelEconomy).abs() /
                    defualtFuelEconomy) *
                100;
        print("percentageDifference: ${percentageDifference}");
        if (calculatedFuelEconomy > defualtFuelEconomy) {
          print("${percentageDifference}% higher than the default");
          return '${(percentageDifference * 10).round() / 10}% higher than the default fuel economy of this car (${defualtFuelEconomy})';
        } else {
          print('${percentageDifference}% lower than the default');
          return '${(percentageDifference * 10).round() / 10}% lower than the default fuel economy of this car (${defualtFuelEconomy})';
        }
      } else {
        print('User has no cars.');
        return "";
      }
    } catch (e) {
      print('An error occurred: $e');
      return "";
    }
  }

  // fuel expenses for a month
  // loop through all expenses in a duration for a specific car for specific user ofcourse
  // ex: from 1/1 to 30/1 for user 1 car 1
  // start from the initial date (the moment initial mileage entered)
  // end at the moment where submit button clicked

  Future<double> getTotalFuelExpenses(
      String carId, String startDate, String endDate) async {
    double totalExpenses = 0.0;
    print("carId: $carId");
    print("StartDate: $startDate");
    print("endDate: $endDate");
    List<Map<String, dynamic>> documents =
        await FuelFirebase().fetchBillDocs(carId, startDate, endDate);

    if (documents.isEmpty) {
      print("EMMMPTY");
    }
    for (var document in documents) {
      print("HERE");
      print(document);
      if (document.containsKey('amount')) {
        totalExpenses += document['amount'];
        print(totalExpenses);
      }
    }

    return totalExpenses;
  }
}
