import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class editCarInfoHandler {
  final String carId;

  editCarInfoHandler({required this.carId});

  Future<void> formUpdata(selectedFuelType, englishLettersController,
      numbersController /*, carNameController, selectedCarColor*/) async {
    // Gather form data
    String fuelType = selectedFuelType ?? '';
    String englishLetters = englishLettersController.text ?? '';
    String numbers = numbersController.text ?? '';
    // String name = carNameController.text ?? '';
    // String color = selectedCarColor ?? '';

    String? arabicLetters = await convertEnglishToArabic(englishLetters);
    // Submit data to Firebase
    FirebaseFirestore.instance.collection('Cars').doc(carId).update({
      'fuelType': fuelType,
      'englishLetters': englishLetters,
      'arabicLetters': arabicLetters,
      'plateNumbers': numbers,
      // 'color': color,
      // 'name': name,
    });
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

  static Future<Map<String, dynamic>> getCarData(String carId) async {
    DocumentSnapshot carDoc =
        await FirebaseFirestore.instance.collection('Cars').doc(carId).get();

    Map<String, dynamic> carDataInfo = {};

    if (carDoc.exists) {
      carDataInfo = carDoc.data() as Map<String, dynamic>;
    }

    return carDataInfo;
  }
}
