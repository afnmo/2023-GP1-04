import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:gp91/consumption/consumption_models.dart';

class FuelFirebase extends GetxController {
  static FuelFirebase get instance => Get.find();

  final _db = FirebaseFirestore.instance;

  final FirebaseAuth _auth = FirebaseAuth.instance;
  late Rx<User?> firebaseUser;

  FuelFirebase() {
    firebaseUser = Rx<User?>(_auth.currentUser);
  }

  String? getCurrentUserEmail() {
    return _auth.currentUser?.email;
  }

  Future<String?> getUserDocumentIdByEmail() async {
    try {
      String? email = getCurrentUserEmail();
      print("getUserDocumentIdByEmail(): email: $email");
      if (email == null) {
        print("Email is null");
        // Optionally, you can show a different snackbar or handle this case separately
        return null;
      }

      var querySnapshot = await _db
          .collection('Users')
          .where('email', isEqualTo: email)
          .limit(1)
          .get();

      if (querySnapshot.docs.isNotEmpty) {
        print("getUserDocumentIdByEmail(): querySnapshot.docs.isNotEmpty");
        return querySnapshot.docs.first.id;
      } else {
        print("getUserDocumentIdByEmail(): querySnapshot.docs.isEmpty");
        return null;
      }
    } catch (e) {
      Get.snackbar(
        "Error",
        "Something went wrong, try again",
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.redAccent.withOpacity(0.1),
        colorText: Colors.red,
      );
      return null;
    }
  }

  Future<List<String?>> fetchDocumentIdsByEmail() async {
    String? userDocId = await getUserDocumentIdByEmail();

    if (userDocId != null) {
      final carCollection = _db.collection('Cars');
      QuerySnapshot carQuerySnapshot =
          await carCollection.where('userId', isEqualTo: userDocId).get();

      List<String?> carDocumentIds =
          carQuerySnapshot.docs.map<String?>((carDoc) => carDoc.id).toList();

      return carDocumentIds;
    } else {
      return [];
    }
  }

  Future<void> addMileage(Map<String, dynamic> data) async {
    try {
      String? userId = await getUserDocumentIdByEmail();
      print("userId: " + userId!);
      Map<String, dynamic> additionalData = {
        'userId': userId,
      };

      // Append additional data to the existing map
      data.addAll(additionalData);

      await _db.collection("Consumption").add(data);
    } catch (error) {
      print("Something went wrong in addMileage");
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

  Future<void> deleteDoc(String documentId) async {
    try {
      await _db.collection("Consumption").doc(documentId).delete();
    } catch (error) {
      print("Error deleting document: ${error.toString()}");
      // Handling the error with a user-friendly message
      Get.snackbar(
        "Error",
        "Failed to delete the document, try again",
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.redAccent.withOpacity(0.1),
        colorText: Colors.red,
      );
    }
  }

  Future<Map<String, dynamic>> fetchConsumptionDoc(String documentId) async {
    try {
      DocumentSnapshot<Map<String, dynamic>> querySnapshot =
          await _db.collection("Consumption").doc(documentId).get();

      // If statement to check a condition - for example, if the document doesn't exist
      if (!querySnapshot.exists) {
        throw Exception('Document does not exist');
      }
      Map<String, dynamic>? data = querySnapshot.data();
      return data!; // Return the fetched document
    } catch (error) {
      print("Error retrieving the document: ${error.toString()}");
      // Handling the error with a user-friendly message
      Get.snackbar(
        "Error",
        "Failed to retrieve the document, try again",
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.redAccent.withOpacity(0.1),
        colorText: Colors.red,
      );
      rethrow; // Re-throw the caught exception
    }
  }

  Future<void> addFinalInputs(
      Map<String, dynamic> data, String consumptionDocumentId) async {
    try {
      // Update the specific document with the new data
      await _db
          .collection("Consumption")
          .doc(consumptionDocumentId)
          .set(data, SetOptions(merge: true));
    } catch (error) {
      print("Something went wrong in addFinalInputs");
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

  Future<List<Map<String, dynamic>>> fetchAllWithDoneTrue() async {
    try {
      String? userId = await getUserDocumentIdByEmail();
      print(userId);
      if (userId == null) {
        print("User ID is null");
        return [];
      }
      QuerySnapshot querySnapshot = await _db
          .collection("Consumption")
          .where('done', isEqualTo: true) // Filter for 'done' == true
          .where('userId', isEqualTo: userId)
          .get();

      List<Map<String, dynamic>> allDocuments = querySnapshot.docs.map((doc) {
        return doc.data() as Map<String, dynamic>;
      }).toList();

      return allDocuments;
    } catch (error) {
      print("Error fetching documents with 'done' = true: ${error.toString()}");
      return [];
    }
  }

  Future<List<Map<String, dynamic>>> fetchAllWithDoneFalse() async {
    try {
      String? userId = await getUserDocumentIdByEmail();
      print(userId);
      if (userId == null) {
        print("User ID is null");
        return [];
      }
      QuerySnapshot querySnapshot = await _db
          .collection("Consumption")
          .where('done', isEqualTo: false)
          .where('userId', isEqualTo: userId)
          .get();

      List<Map<String, dynamic>> allDocuments = querySnapshot.docs.map((doc) {
        return {
          'id': doc.id, // Include the document ID
          ...doc.data() as Map<String, dynamic>,
        };
      }).toList();

      return allDocuments;
    } catch (error) {
      print("Error fetching documents with 'done' = true: ${error.toString()}");
      return [];
    }
  }

  Future<Map<String, dynamic>> fetchCarDoc(String documentId) async {
    try {
      DocumentSnapshot<Map<String, dynamic>> querySnapshot =
          await _db.collection("Cars").doc(documentId).get();

      // If statement to check a condition - for example, if the document doesn't exist
      if (!querySnapshot.exists) {
        throw Exception('Document does not exist');
      }
      Map<String, dynamic>? data = querySnapshot.data();
      return data!; // Return the fetched document
    } catch (error) {
      print("Error retrieving the document: ${error.toString()}");
      // Handling the error with a user-friendly message
      Get.snackbar(
        "Error",
        "Failed to retrieve the document, try again",
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.redAccent.withOpacity(0.1),
        colorText: Colors.red,
      );
      rethrow; // Re-throw the caught exception
    }
  }

  Future<List<Map<String, dynamic>>> fetchBillDocs(
      String carId, String startDate, String endDate) async {
    try {
      String? userId = await getUserDocumentIdByEmail();
      print(userId);
      if (userId == null) {
        print("User ID is null");
        return [];
      }
      print("startDate $startDate");
      print("endDate $endDate");
      print("userId $userId");
      print("carId $carId");
      var querySnapshot = await _db
          .collection('Bills')
          .where('userId', isEqualTo: userId)
          .where('carId', isEqualTo: carId)
          .where('date', isGreaterThanOrEqualTo: startDate)
          .where('date', isLessThanOrEqualTo: endDate)
          .get();
      print(querySnapshot);
      querySnapshot.printInfo();

      return querySnapshot.docs.map((doc) => doc.data()).toList();
    } catch (e) {
      print(e);
      Get.snackbar(
        "Error",
        "Something went wrong, try again",
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.redAccent.withOpacity(0.1),
        colorText: Colors.red,
      );
      return [];
    }
  }

  Future<List<String>> getUserCarsNames(String userId) async {
    List<String> carNames = [];

    try {
      // Fetching documents from the 'cars' collection where 'userId' field matches the provided userId
      QuerySnapshot querySnapshot =
          await _db.collection('cars').where('userId', isEqualTo: userId).get();

      // Iterating over each document and adding the car name to the list
      for (var doc in querySnapshot.docs) {
        carNames.add(doc['carName']);
      }

      return carNames;
    } catch (e) {
      print(e);
      return []; // Return an empty list in case of an error
    }
  }

  Future<Map<Car, List<ConsumptionRecord>>>
      fetchCarsWithConsumptionRecords() async {
    Map<Car, List<ConsumptionRecord>> carsWithRecords = {};

    try {
      String? userId = await getUserDocumentIdByEmail();
      print(userId);
      if (userId == null) {
        print("User ID is null");
        return {};
      }
      // Fetch cars
      QuerySnapshot carSnapshot =
          await _db.collection('Cars').where('userId', isEqualTo: userId).get();

      // Iterate over each car document
      for (var carDoc in carSnapshot.docs) {
        Map<String, dynamic> carData = carDoc.data() as Map<String, dynamic>;
        Car car = Car(
          carId: carDoc.id,
          name: carData['name'],
          // Add other details as necessary
        );

        try {
          // Now fetch consumption records for this car
          QuerySnapshot consumptionSnapshot = await _db
              .collection('Consumption')
              .where('carId', isEqualTo: car.carId)
              .where('done', isEqualTo: true)
              .get();

          List<ConsumptionRecord> records =
              consumptionSnapshot.docs.map((recordDoc) {
            Map<String, dynamic> recordData =
                recordDoc.data() as Map<String, dynamic>;
            return ConsumptionRecord(
              carId: car.carId,
              calculatedFuelEconomy: recordData['calculatedFuelEconomy'],
              startDate: recordData['startDate'],
              endDate: recordData['finalDate'],
              percentageDifference: recordData['percentageDifference'],
              // Add other details as necessary
            );
          }).toList();

          // Add the car and its records to the map
          carsWithRecords[car] = records;
        } catch (e) {
          print("Error fetching consumption records for car ${car.name}: $e");
          // Handle the error or add error data to the map as appropriate
        }
      }

      return carsWithRecords;
    } catch (e) {
      print("Error fetching cars: $e");
      // Handle the error, for example by returning an empty map or re-throwing the exception
      return {};
    }
  }

  Future<void> updateAmountField(String carId, double amount) async {
    try {
      String? userId = await getUserDocumentIdByEmail();
      if (userId == null) throw Exception('User ID is null');

      // Fetch the user's current bill
      var billsQuery = await FirebaseFirestore.instance
          .collection("Bills")
          .where('userId', isEqualTo: userId)
          .where('carId', isEqualTo: carId)
          .limit(1)
          .get();

      if (billsQuery.docs.isEmpty)
        throw Exception('No bill found for this user');

      var bill = billsQuery.docs.first;

      // Update the field 'amount' with the new amount received
      await bill.reference.update({'amount': amount});
    } catch (error) {
      print("Error in adding car to bill: ${error.toString()}");
      Get.snackbar(
        "Error",
        "Something went wrong, try again",
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.redAccent.withOpacity(0.1),
        colorText: Colors.red,
      );
    }
  }

  Future<Map<Car, List<ConsumptionRecord>>>
      fetchCarsWithConsumptionDoneFalseRecords() async {
    Map<Car, List<ConsumptionRecord>> carsWithRecords = {};

    try {
      String? userId = await getUserDocumentIdByEmail();
      print(userId);
      if (userId == null) {
        print("User ID is null");
        return {};
      }
      // Fetch cars
      QuerySnapshot carSnapshot =
          await _db.collection('Cars').where('userId', isEqualTo: userId).get();

      // Iterate over each car document
      for (var carDoc in carSnapshot.docs) {
        Map<String, dynamic> carData = carDoc.data() as Map<String, dynamic>;
        Car car = Car(
          carId: carDoc.id,
          name: carData['name'],
          // Add other details as necessary
        );

        try {
          // Now fetch consumption records for this car
          QuerySnapshot consumptionSnapshot = await _db
              .collection('Consumption')
              .where('carId', isEqualTo: car.carId)
              .where('done', isEqualTo: false)
              .get();

          List<ConsumptionRecord> records =
              consumptionSnapshot.docs.map((recordDoc) {
            Map<String, dynamic> recordData =
                recordDoc.data() as Map<String, dynamic>;
            return ConsumptionRecord(
              carId: car.carId,
              consumptionId: recordDoc.id,
              startDate: recordData['startDate'],
              startMileage: recordData['startMileage'],
              // Add other details as necessary
            );
          }).toList();

          // Add the car and its records to the map
          carsWithRecords[car] = records;
        } catch (e) {
          print("Error fetching consumption records for car ${car.name}: $e");
          // Handle the error or add error data to the map as appropriate
        }
      }

      return carsWithRecords;
    } catch (e) {
      print("Error fetching cars: $e");
      // Handle the error, for example by returning an empty map or re-throwing the exception
      return {};
    }
  }

  Future<String?> getMostRecentFinalMileage(String carId) async {
    try {
      String? userId = await getUserDocumentIdByEmail();
      print(userId);
      if (userId == null) {
        print("User ID is null");
        return null;
      }

      // print(carId)
      // Reference to the Firestore collection
      var collection = _db.collection('Consumption');

      // Query to get the document with the most recent final_date for the given user ID and car ID
      var querySnapshot = await collection
          .where('userId', isEqualTo: userId)
          .where('carId', isEqualTo: carId)
          .orderBy('finalDate', descending: true)
          .limit(1)
          .get();

      if (querySnapshot.docs.isNotEmpty) {
        var data = querySnapshot.docs.first.data();
        print(data);

        // Check if 'finalMileage' exists and return it
        if (data.containsKey('endMileage')) {
          print('finalMileage found.');
          return data['endMileage'];
        } else {
          print('finalMileage not found in the document.');
          return null;
        }
      } else {
        print('No documents found for the specified user and car.');
        return null;
      }
    } catch (e) {
      print('Error fetching data: $e');
      return null;
    }
  }
}
