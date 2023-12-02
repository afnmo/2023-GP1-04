import 'dart:convert';
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';

class EditCarInfoHandler {
  final String carId;

  EditCarInfoHandler({required this.carId});

// update car info
  Future<void> formUpdate(
      selectedFuelType,
      englishLettersController,
      numbersController,
      carNameController,
      selectedCarColor,
      File? selectedImage) async {
    String fuelType = selectedFuelType ?? '';
    String englishLetters = englishLettersController.text ?? '';
    String numbers = numbersController.text ?? '';
    String name = carNameController.text ?? '';
    String color = selectedCarColor ?? '';
    String? arabicLetters = await convertEnglishToArabic(englishLetters);

    // Check if arabicLetters conversion was successful
    if (arabicLetters == null) {
      print('Error converting English to Arabic');
      return;
    }

    String? imageString = await convertImageToString(selectedImage);

    if (imageString != null) {
      await FirebaseFirestore.instance.collection('Cars').doc(carId).update({
        'fuelType': fuelType,
        'englishLetters': englishLetters,
        'arabicLetters': arabicLetters,
        'plateNumbers': numbers,
        'color': color,
        'name': name,
        'image': imageString,
      });
    } else {
      await FirebaseFirestore.instance.collection('Cars').doc(carId).update({
        'fuelType': fuelType,
        'englishLetters': englishLetters,
        'arabicLetters': arabicLetters,
        'plateNumbers': numbers,
        'color': color,
        'name': name,
      });
    }
  }

// convert english letters To arabic letters
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

// get car data from database
  static Future<Map<String, dynamic>> getCarData(String carId) async {
    DocumentSnapshot carDoc =
        await FirebaseFirestore.instance.collection('Cars').doc(carId).get();

    Map<String, dynamic> carDataInfo = {};

    if (carDoc.exists) {
      carDataInfo = carDoc.data() as Map<String, dynamic>;
    }

    return carDataInfo;
  }

// convert image to string for storing in database
  Future<String?> convertImageToString(File? imageFile) async {
    if (imageFile == null) {
      return null;
    }

    try {
      List<int> imageBytes = await imageFile.readAsBytes();

      String base64Image = base64Encode(imageBytes);

      return base64Image;
    } catch (e) {
      print('Error converting image to string: $e');
      return null;
    }
  }
}
