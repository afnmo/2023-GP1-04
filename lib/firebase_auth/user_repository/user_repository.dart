import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:gp91/firebase_auth/user_model.dart';

class UserRepository extends GetxController {
  static UserRepository get instance => Get.find();
  

  final _db = FirebaseFirestore.instance;

  // createUser(UserModel userModel) async {
  //   print("createUser(UserModel userModel) async ENTERED");
  //   await _db
  //       .collection("Users")
  //       .add(userModel.toJson())
  //       .whenComplete(
  //         () => Get.snackbar("Success", "Your account has been created",
  //             snackPosition: SnackPosition.BOTTOM,
  //             backgroundColor: Colors.green.withOpacity(0.1),
  //             colorText: Colors.green),
  //       )
  //       .catchError((error, stackTrace){
  //     print("Something went wrong in create user database");
  //     Get.snackbar("Error", "Something went wrong, try again",
  //         snackPosition: SnackPosition.BOTTOM,
  //         backgroundColor: Colors.redAccent.withOpacity(0.1),
  //         colorText: Colors.red);
  //     print(error.toString());
  //   });
  // }

  Future<void> createUser(UserModel userModel) async {
    try {
      await _db.collection("Users").add(userModel.toJson());
    } catch (error, stackTrace) {
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
}
