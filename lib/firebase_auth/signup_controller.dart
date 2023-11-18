
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
    return emailInUse;
  }


  Future<void> createUser(UserModel userModel) async {
    print("Future<void> createUser(UserModel userModel) async ENTERED");
    await userRepo.createUser(userModel);
  }
}
