import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

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
      if (email == null) {
        // Optionally, you can show a different snackbar or handle this case separately
        return null;
      }

      var querySnapshot = await FirebaseFirestore.instance
          .collection('users')
          .where('email', isEqualTo: email)
          .limit(1)
          .get();

      if (querySnapshot.docs.isNotEmpty) {
        return querySnapshot.docs.first.id;
      } else {
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

// -------------------------------------------------------------------
  // temproraly: retrieve first car for the user
  Future<Map<String, dynamic>?> getFirstCarForUser() async {
    try {
      String? userId = await getUserDocumentIdByEmail();
      var querySnapshot = await FirebaseFirestore.instance
          .collection('cars')
          .where('userId', isEqualTo: userId)
          .limit(1)
          .get();

      if (querySnapshot.docs.isNotEmpty) {
        return querySnapshot.docs.first.data();
      } else {
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

  Future<String?> getFirstCarDocumentIdForUser(String userId) async {
    try {
      var querySnapshot = await FirebaseFirestore.instance
          .collection('cars')
          .where('userId', isEqualTo: userId)
          .limit(1)
          .get();

      if (querySnapshot.docs.isNotEmpty) {
        return querySnapshot
            .docs.first.id; // Return the first car's document ID
      } else {
        return null; // Return null if the user has no cars
      }
    } catch (e) {
      Get.snackbar(
        "Error",
        "Something went wrong, try again",
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.redAccent.withOpacity(0.1),
        colorText: Colors.red,
      );
      return null; // Return null in case of an exception
    }
  }

// -------------------------------------------------------------------

  Future<void> addMileage(Map<String, dynamic> data) async {
    try {
      String? userId = await getUserDocumentIdByEmail();
      String? carId = await getFirstCarDocumentIdForUser(userId!);
      Map<String, dynamic> additionalData = {
        'userId': userId,
        'carId': carId,
      };

      // Append additional data to the existing map
      data.addAll(additionalData);

      await _db.collection("Consumption").add(data);
    } catch (error) {
      print("Something went wrong in create user database");
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

  Future<List<Map<String, dynamic>>> fetchAll() async {
    try {
      QuerySnapshot querySnapshot = await _db.collection("Consumption").get();
      List<Map<String, dynamic>> allDocuments = querySnapshot.docs.map((doc) {
        // Create a new map with the document ID and all the existing data
        return {
          'id': doc.id, // Include the document ID
          ...doc.data() as Map<String, dynamic>,
        };
      }).toList();

      return allDocuments;
    } catch (error) {
      print("Error fetching documents: ${error.toString()}");
      return [];
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

  Future<Map<String, dynamic>> fetchDoc(String documentId) async {
    try {
      DocumentSnapshot<Map<String, dynamic>> querySnapshot =
          await _db.collection("Consumption").doc(documentId).get();

      // If statement to check a condition - for example, if the document doesn't exist
      if (!querySnapshot.exists) {
        throw Exception('Document does not exist');
      }
      Map<String, dynamic>? data = await querySnapshot.data();
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
}
