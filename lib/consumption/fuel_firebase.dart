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
      print("getUserDocumentIdByEmail(): email: $email");
      if (email == null) {
        print("Email is null");
        // Optionally, you can show a different snackbar or handle this case separately
        return null;
      }

      var querySnapshot = await FirebaseFirestore.instance
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
      final carCollection = FirebaseFirestore.instance.collection('Cars');
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
      QuerySnapshot querySnapshot = await _db
          .collection("Consumption")
          .where('done', isEqualTo: true) // Filter for 'done' == true
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
      QuerySnapshot querySnapshot = await _db
          .collection("Consumption")
          .where('done', isEqualTo: false) 
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
}
