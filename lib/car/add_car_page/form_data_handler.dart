import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'car_data.dart';

class FormDataHandler {
  CarData carDataObj = CarData();

  Future<String?> findDocumentIdByEmail() async {
    FirebaseAuth auth = FirebaseAuth.instance;
    User? user = auth.currentUser;

    if (user != null && user.email != null) {
      CollectionReference usersCollection =
          FirebaseFirestore.instance.collection('Users');

      QuerySnapshot querySnapshot =
          await usersCollection.where('email', isEqualTo: user.email).get();

      if (querySnapshot.docs.isNotEmpty) {
        return querySnapshot.docs.first.id;
      } else {
        // User document not found based on the provided email
        return "no doc";
      }
    } else {
      // No current user or user email found
      return null;
    }
  }

  Future<void> formData(
      selectedCarMake,
      selectedCarModel,
      selectedYear,
      selectedFuelType,
      selectedFuelEconomy,
      englishLettersController,
      numbersController,
      carNameController,
      selectedCarColor) async {
    // Gather form data
    String make = selectedCarMake ?? '';
    String model = selectedCarModel ?? '';
    String year = selectedYear ?? '';
    String fuelType = selectedFuelType ?? '';
    String fuelEconomy = selectedFuelEconomy ?? '';
    String englishLetters = englishLettersController.text ?? '';
    String numbers = numbersController.text ?? '';
    String name = carNameController.text ?? '';
    String color = selectedCarColor ?? '';
    String grade =
        await carDataObj.getGradeForFuelEconomy(year, make, model, fuelEconomy);

    String? documentId = await findDocumentIdByEmail();
    String? arabicLetters = await convertEnglishToArabic(englishLetters);
    // Submit data to Firebase
    DocumentReference carDate =
        await FirebaseFirestore.instance.collection('Cars').add({
      'make': make,
      'model': model,
      'year': year,
      'fuelType': fuelType,
      'fuelEconomy': fuelEconomy,
      'englishLetters': englishLetters,
      'arabicLetters': arabicLetters,
      'plateNumbers': numbers,
      'grade': grade,
      'color': color,
      'name': name,
      'userId': documentId,
      'image': "",
    });

    await setInitialExpense(carDate.id, documentId);
  }

  Future<String> convertEnglishToArabic(String input) async {
    Map<String, String> letterMap = {
      'A': 'أ',
      'B': 'ب',
      'J': 'ح',
      'D': 'د',
      'R': 'ر',
      'S': 'س',
      'X': 'ص',
      'T': 'ط',
      'E': 'ع',
      'G': 'ق',
      'K': 'ك',
      'L': 'ل',
      'Z': 'م',
      'N': 'ن',
      'H': 'هـ',
      'U': 'و',
      'V': 'ى',
    };

    String result = '';
    for (int i = 0; i < input.length; i++) {
      String currentLetter = input[i].toUpperCase();
      if (letterMap.containsKey(currentLetter)) {
        result += letterMap[currentLetter]! + ' ';
      } else {
        result += input[i];
      }
    }
    return result.trim();
  }

  Future<void> setInitialExpense(String carId, String? userId) async {
    try {
      DateTime now = DateTime.now();
      String dateString = DateFormat('yyyy-MM-dd').format(now);
      List<String> dateParts =
          dateString.split('-').map((s) => s.trim()).toList();
      int year = int.parse(dateParts[0]);
      int month = int.parse(dateParts[1]);
      int day = int.parse(dateParts[2]);

      // String? userId = await getUserId();
      print("userId: " + userId!);
      Map<String, dynamic> data = {
        'userId': userId,
        'date': dateString,
        'year': year,
        'month': month,
        'day': day,
        'amount': 500,
        'carId': carId
      };

      // Append additional data to the existing map

      await FirebaseFirestore.instance.collection("Bills").add(data);
    } catch (error) {
      print("Something went wrong in setting initial expenses for a car");
      Get.snackbar(
        "Error",
        "Something went wrong, try again",
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.redAccent.withOpacity(0.1),
        colorText: Colors.red,
      );
      print(error.toString());
    }
  }
}
