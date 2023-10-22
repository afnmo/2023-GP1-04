
import 'package:flutter/material.dart';
import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:get/instance_manager.dart';
import 'package:gp91/firebase_auth/user_model.dart';
import 'package:gp91/firebase_auth/user_repository/user_repository.dart';

class SignUpController extends GetxController {
  static SignUpController get instance => Get.find();

  final name = TextEditingController();
  final email = TextEditingController();
  final password = TextEditingController();

  final userRepo = Get.put(UserRepository());

  bool registerUser(UserModel userModel, String email, String password) {
    bool emailInUse = false;
    // Future<User?> userFuture =
    // AuthRepository.instance
    //     .createUserWithEmailAndPassword(userModel, email, password);

    // userFuture.then((user) {
    //   if (user != null) {
    //     emailInUse = false;
    //     print("User registered: ${user.toString()}");
    //     // You can also access and work with the user data here.
    //   } else {
    //     emailInUse = true;
    //     print("User registration failed.");
    //   }
    // }).catchError((error) {
    //   emailInUse = true;
    //   print("Error in registerUser(email, password): $error");
    // });
    return emailInUse;
  }
  // void registerUser(String email, String password) {
  //   Future<User?> error =
  //       AuthRepository.instance.createUserWithEmailAndPassword(email, password);

  //   if (error != null) {
  //     print("Error in registerUser(email, password)");
  //     print(error.toString());
  //     // Get.showSnackbar(GetSnackBar(
  //     //   message: error.toString(),
  //     // ));
  //   }
  // }

  // void registerUser(String email, String password) async {
  //   // try {
  //   User? user = await AuthRepository.instance
  //       .createUserWithEmailAndPassword(email, password);

  //   if (user != null) {
  //     print("User is successfully created");
  //     // Navigator.pushNamed(context, "/home");
  //   } else {
  //     print("User created failed");
  //   }

  // }

  Future<void> createUser(UserModel userModel) async {
    print("Future<void> createUser(UserModel userModel) async ENTERED");
    await userRepo.createUser(userModel);
  }
}
