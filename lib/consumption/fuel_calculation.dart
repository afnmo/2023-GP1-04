import 'dart:ffi';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:gp91/consumption/fuel_firebase.dart';

class FuelCalculation {
  /*
  Liters = Expenses / Cost per Liter of Chosen Fuel Type

  Expenses: retrieved from expense collection from database
  Cost per Liter of Chosen Fuel Type: retrieved from car collection from database
  Based on the following:
  Gasoline 91 => $2.18 per liter
  Gasoline 95 => $2.33 per liter
  Diesel => $0.75 per liter


  Calculated Fuel Economy = Liters / (End Mileage−Start Mileage)
  End Mileage−Start Mileage: retrieved from consumption collection from database

  Percentage Difference=(Default Fuel Economy ∣Default Fuel Economy−Calculated Fuel Economy∣)×100
  Default Fuel Economy: retrieved from car collection from database
  */

  // expenses retrieval:
  // ---------------------------------------

  // fuel type retrieval:

  Future<void> getFuelType() async {
    try {
      Map<String, dynamic>? carData = await FuelFirebase().getFirstCarForUser();

      if (carData != null) {
        String fuelType = carData['fuelType'] as String? ?? 'Unknown';
        double costPerLiter = 0;
        if (fuelType == "91") {
          costPerLiter = 2.18;
        } else if (fuelType == "95") {
          costPerLiter = 2.33;
        } else if (fuelType == "Diesel") {
          costPerLiter = 0.75;
        }

        double expenses = 100;
        double litersConsumed = expenses / costPerLiter;

        print('Fuel Type: $fuelType');

        // You can use these variables as needed in your application
      } else {
        print('User has no cars.');
      }
    } catch (e) {
      print('An error occurred: $e');
    }
  }

  Future<double> calculatedFuelEconomy(
      double litersConsumed, String documentId) async {
    try {
      Map<String, dynamic>? consumption =
          await FuelFirebase().fetchDoc(documentId);
      if (consumption != null) {
        double startMileage = consumption['startMileage'] as double;
        double endMileage = consumption['endMileage'] as double;
        double calculatedFuelEconomy =
            litersConsumed / (endMileage - startMileage);
        return calculatedFuelEconomy;
      } else {
        print('User has no cars.');
        return 0;
      }
    } catch (e) {
      print('An error occurred: $e');
      return 0;
    }
  }
}
