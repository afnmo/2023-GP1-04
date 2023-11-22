import 'package:flutter/services.dart';
import 'package:csv/csv.dart';
import 'dart:convert';

class carData {
  static Future<List<String>> extractManufacturers() async {
    List<String> manufacturers = [];

    try {
      print('in try');
      final rawData =
          await rootBundle.load("assets/carDS/FE Vehicle Details.csv");
      print('in load');
      String csvData =
          utf8.decode(rawData.buffer.asUint8List(), allowMalformed: true);

      List<List<dynamic>> listData =
          const CsvToListConverter().convert(csvData);
      print('outside if');
      if (listData.isNotEmpty && listData[0].length > 1) {
        int manufacturerColumnIndex =
            1; // Assuming Manufacturer column is at index 1
        print('in if');
        for (int i = 1; i < listData.length; i++) {
          print('in for');
          try {
            print('in try2');
            String manufacturer =
                listData[i][manufacturerColumnIndex].toString();
            print('take mnu');
            if (manufacturer != null && manufacturer.isNotEmpty) {
              manufacturers.add(manufacturer);
              print('in if 2');
            }
          } catch (e) {
            // Handle any potential errors during extraction
            print("Error extracting manufacturer: $e");
          }
        }
      }

      // Remove duplicates using Set and convert back to List
      List<String> uniqueManufacturers = manufacturers.toSet().toList();
      uniqueManufacturers.sort();
      return uniqueManufacturers;
    } catch (e) {
      // Catch and handle any exceptions thrown in the process
      print("Error occurred: $e");
      // Return an empty list or handle the error as needed
      return ['not work'];
    }
  }

  Future<List<String>> getVehicleModels(String selectedCarMake) async {
    List<String> carModels = [];

    try {
      final rawData =
          await rootBundle.load("assets/carDS/FE Vehicle Details.csv");

      String csvData =
          utf8.decode(rawData.buffer.asUint8List(), allowMalformed: true);

      List<List<dynamic>> listData =
          const CsvToListConverter().convert(csvData);

      if (listData.isNotEmpty && listData[0].length > 1) {
        int manufacturerIndex = 1;
        int vehicleNameEnIndex = 2;
        Set<String> uniqueCarModels =
            Set<String>(); // Using Set to store unique values

        String selectedMakeLowerCase = selectedCarMake.toLowerCase();

        for (int i = 1; i < listData.length; i++) {
          if (listData[i].length > vehicleNameEnIndex) {
            String manufacturer = listData[i][manufacturerIndex].toString();
            if (manufacturer.toLowerCase() == selectedMakeLowerCase) {
              String carModel = listData[i][vehicleNameEnIndex].toString();
              uniqueCarModels.add(carModel); // Add to set to ensure uniqueness
            }
          }
        }

        carModels = uniqueCarModels.toList(); // Convert set to list
        carModels.sort(); // Sort the list alphabetically
      }
    } catch (e) {
      // Handle any errors occurring during file loading, decoding, or parsing
      print('Error while loading/parsing CSV data: $e');
    }

    return carModels; // Return the sorted and unique list of car models for the provided car make
  }

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
          const CsvToListConverter().convert(csvData);

      if (listData.isNotEmpty && listData[0].length > 1) {
        int manufacturerIndex = 1;
        int vehicleNameEnIndex = 2;
        int yearIndex = 0;

        Set<String> uniqueYears =
            Set<String>(); // Using Set to store unique values

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

        years = uniqueYears.toList(); // Convert set to list
        years.sort(); // Sort the list of years
      }
    } catch (e) {
      // Handle any errors occurring during file loading, decoding, or parsing
      print('Error while loading/parsing CSV data: $e');
    }

    return years;
  }

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
          const CsvToListConverter().convert(csvData);

      if (listData.isNotEmpty && listData[0].length > 1) {
        int yearIndex = 0;
        int manufacturerIndex = 1;
        int vehicleNameEnIndex = 2;
        int fuelEconomyIndex = 3;

        Set<String> uniqueFuelEconomy =
            Set<String>(); // Using Set to store unique values

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

        fuelEconomyData = uniqueFuelEconomy.toList(); // Convert set to list
        fuelEconomyData.sort(); // Sort the list
      }
    } catch (e) {
      // Handle any errors occurring during file loading, decoding, or parsing
      print('Error while loading/parsing CSV data: $e');
    }

    return fuelEconomyData;
  }

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
          const CsvToListConverter().convert(csvData);

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
              break; // Exit loop if the criteria match is found
            }
          }
        }
      }
    } catch (e) {
      // Handle any errors occurring during file loading, decoding, or parsing
      print('Error while loading/parsing CSV data: $e');
    }

    return grade;
  }
}
