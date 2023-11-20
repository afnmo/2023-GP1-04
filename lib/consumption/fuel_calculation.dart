import 'package:flutter/material.dart';
import 'package:gp91/consumption/fuel_firebase.dart';

class FuelCalculation {
  /*
  1) Liters = Expenses / Cost per Liter of Chosen Fuel Type

  Expenses: retrieved from expense collection from database
  Cost per Liter of Chosen Fuel Type: retrieved from car collection from database
  Based on the following:
  Gasoline 91 => $2.18 per liter
  Gasoline 95 => $2.33 per liter
  Diesel => $0.75 per liter


  2) Calculated Fuel Economy = Liters / (End Mileage−Start Mileage)
  End Mileage−Start Mileage: retrieved from consumption collection from database

  3) Percentage Difference=(Default Fuel Economy ∣Default Fuel Economy−Calculated Fuel Economy∣)×100
  Default Fuel Economy: retrieved from car collection from database
  */

  // expenses retrieval:
  // ---------------------------------------

  // fuel type retrieval:

  Future<double> getLitersConsumed(String documentCarId) async {
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

        double expenses = 500;
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
          return '${(percentageDifference* 10).round() / 10}% higher than the default';
        } else {
          print('${percentageDifference}% lower than the default');
          return '${(percentageDifference* 10).round() / 10}% lower than the default';
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
}
