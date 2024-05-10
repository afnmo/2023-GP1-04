import 'package:flutter/services.dart';
import 'package:csv/csv.dart';
import 'dart:convert';

class CarData {
// extract manufacturers from dataset
  static Future<List<String>> extractManufacturers() async {
    List<String> manufacturers = [];


    try {
      final rawData =
          await rootBundle.load("assets/carDS/FE Vehicle Details.csv");
      String csvData =
          utf8.decode(rawData.buffer.asUint8List(), allowMalformed: true);

      List<List<dynamic>> listData =
          const CsvToListConverter(eol: '\n').convert(csvData);
      if (listData.isNotEmpty && listData[0].length > 1) {
        int manufacturerColumnIndex = 1;
        for (int i = 1; i < listData.length; i++) {
          try {
            String manufacturer =
                listData[i][manufacturerColumnIndex].toString();
            if (manufacturer != null && manufacturer.isNotEmpty) {
              manufacturers.add(manufacturer);
            }
          } catch (e) {
            print("Error extracting manufacturer: $e");
          }
        }
      }

      List<String> uniqueManufacturers = manufacturers.toSet().toList();
      uniqueManufacturers.sort();
      return uniqueManufacturers;
    } catch (e) {
      print("Error occurred: $e");

      return [];
    }
  }

// get vehicle models based on make
  Future<List<String>> getVehicleModels(String selectedCarMake) async {
    List<String> carModels = [];

    try {
      final rawData =
          await rootBundle.load("assets/carDS/FE Vehicle Details.csv");

      String csvData =
          utf8.decode(rawData.buffer.asUint8List(), allowMalformed: true);

      List<List<dynamic>> listData =
          const CsvToListConverter(eol: '\n').convert(csvData);

      if (listData.isNotEmpty && listData[0].length > 1) {
        int manufacturerIndex = 1;
        int vehicleNameEnIndex = 2;
        Set<String> uniqueCarModels = Set<String>();

        String selectedMakeLowerCase = selectedCarMake.toLowerCase();

        for (int i = 1; i < listData.length; i++) {
          if (listData[i].length > vehicleNameEnIndex) {
            String manufacturer = listData[i][manufacturerIndex].toString();
            if (manufacturer.toLowerCase() == selectedMakeLowerCase) {
              String carModel = listData[i][vehicleNameEnIndex].toString();
              uniqueCarModels.add(carModel);
            }
          }
        }

        carModels = uniqueCarModels.toList();
        carModels.sort();
      }
    } catch (e) {
      print('Error while loading/parsing CSV data: $e');
    }

    return carModels;
  }

// get years based on make And model
  Future<List<String>> getYearsForMakeAndModel(
    String selectedCarMake,
    String selectedCarModel,
  ) async {
    List<String> years = [];

    try {
      final rawData =
          await rootBundle.load("assets/carDS/FE Vehicle Details.csv");

      String csvData =
          utf8.decode(rawData.buffer.asUint8List(), allowMalformed: true);

      List<List<dynamic>> listData =
          const CsvToListConverter(eol: '\n').convert(csvData);

      if (listData.isNotEmpty && listData[0].length > 1) {
        int manufacturerIndex = 1;
        int vehicleNameEnIndex = 2;
        int yearIndex = 0;

        Set<String> uniqueYears = Set<String>();

        for (int i = 1; i < listData.length; i++) {
          if (listData[i].length > vehicleNameEnIndex) {
            String manufacturer = listData[i][manufacturerIndex].toString();
            String carModel = listData[i][vehicleNameEnIndex].toString();

            if (manufacturer.toLowerCase() == selectedCarMake.toLowerCase() &&
                carModel.toLowerCase() == selectedCarModel.toLowerCase()) {
              uniqueYears.add(listData[i][yearIndex].toString());
            }
          }
        }

        years = uniqueYears.toList();
        years.sort();
      }
    } catch (e) {
      print('Error while loading/parsing CSV data: $e');
    }

    return years;
  }

// get fuel economy based on make, model, and year
  Future<List<String>> getFuelEconomy(
    String selectedYear,
    String selectedCarMake,
    String selectedCarModel,
  ) async {
    List<String> fuelEconomyData = [];

    try {
      final rawData =
          await rootBundle.load("assets/carDS/FE Vehicle Details.csv");

      String csvData =
          utf8.decode(rawData.buffer.asUint8List(), allowMalformed: true);

      List<List<dynamic>> listData =
          const CsvToListConverter(eol: '\n').convert(csvData);

      if (listData.isNotEmpty && listData[0].length > 1) {
        int yearIndex = 0;
        int manufacturerIndex = 1;
        int vehicleNameEnIndex = 2;
        int fuelEconomyIndex = 3;

        Set<String> uniqueFuelEconomy = Set<String>();

        for (int i = 1; i < listData.length; i++) {
          if (listData[i].length > vehicleNameEnIndex) {
            String year = listData[i][yearIndex].toString();
            String manufacturer = listData[i][manufacturerIndex].toString();
            String carModel = listData[i][vehicleNameEnIndex].toString();

            if (year.toLowerCase() == selectedYear.toLowerCase() &&
                manufacturer.toLowerCase() == selectedCarMake.toLowerCase() &&
                carModel.toLowerCase() == selectedCarModel.toLowerCase()) {
              uniqueFuelEconomy.add(listData[i][fuelEconomyIndex].toString());
            }
          }
        }

        fuelEconomyData = uniqueFuelEconomy.toList();
        fuelEconomyData.sort();
      }
    } catch (e) {
      print('Error while loading/parsing CSV data: $e');
    }

    return fuelEconomyData;
  }

// get grade based on make, model, year, and fuel economy
  Future<String> getGradeForFuelEconomy(
    String selectedYear,
    String selectedCarMake,
    String selectedCarModel,
    String selectedFuelEconomy,
  ) async {
    String grade = '';

    try {
      final rawData =
          await rootBundle.load("assets/carDS/FE Vehicle Details.csv");

      String csvData =
          utf8.decode(rawData.buffer.asUint8List(), allowMalformed: true);

      List<List<dynamic>> listData =
          const CsvToListConverter(eol: '\n').convert(csvData);

      if (listData.isNotEmpty && listData[0].length > 1) {
        int yearIndex = 0;
        int manufacturerIndex = 1;
        int vehicleNameEnIndex = 2;
        int fuelEconomyIndex = 3;
        int gradeIndex = 4;

        for (int i = 1; i < listData.length; i++) {
          if (listData[i].length > vehicleNameEnIndex) {
            String year = listData[i][yearIndex].toString();
            String manufacturer = listData[i][manufacturerIndex].toString();
            String carModel = listData[i][vehicleNameEnIndex].toString();
            String fuelEconomy = listData[i][fuelEconomyIndex].toString();

            if (year.toLowerCase() == selectedYear.toLowerCase() &&
                manufacturer.toLowerCase() == selectedCarMake.toLowerCase() &&
                carModel.toLowerCase() == selectedCarModel.toLowerCase() &&
                fuelEconomy == selectedFuelEconomy) {
              grade = listData[i][gradeIndex].toString();
              break;
            }
          }
        }
      }
    } catch (e) {
      print('Error while loading/parsing CSV data: $e');
    }

    return grade;
  }
}
