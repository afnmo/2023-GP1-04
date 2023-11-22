import 'dart:convert';
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';

class editCarInfoHandler {
  final String carId;

  editCarInfoHandler({required this.carId});

  Future<void> formUpdate(
      selectedFuelType,
      englishLettersController,
      numbersController,
      carNameController,
      selectedCarColor,
      File? selectedImage) async {
    // ... (other parts of your code remain unchanged)

    String fuelType = selectedFuelType ?? '';
    String englishLetters = englishLettersController.text ?? '';
    String numbers = numbersController.text ?? '';
    String name = carNameController.text ?? '';
    String color = selectedCarColor ?? '';
    String? arabicLetters = await convertEnglishToArabic(englishLetters);

    // Check if arabicLetters conversion was successful
    if (arabicLetters == null) {
      print('Error converting English to Arabic');
      return; // Exit the function if conversion fails
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

  Future<String?> convertImageToString(File? imageFile) async {
    if (imageFile == null) {
      return null; // If the image file is null, return null
    }

    try {
      // Read the image file as a list of bytes
      List<int> imageBytes = await imageFile.readAsBytes();

      // Encode the image bytes to a base64 string
      String base64Image = base64Encode(imageBytes);

      return base64Image;
    } catch (e) {
      // Handle any errors that might occur during image file conversion
      print('Error converting image to string: $e');
      return null; // Return null in case of an error
    }
  }
}
