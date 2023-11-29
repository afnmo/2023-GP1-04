import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
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
    FirebaseFirestore.instance.collection('Cars').add({
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
}
