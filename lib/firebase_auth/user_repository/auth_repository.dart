import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:gp91/home/screens/home_screen.dart';
import 'package:gp91/signup/components/signup_email_password_failure.dart';
import 'package:gp91/firebase_auth/user_model.dart';
import 'package:gp91/firebase_auth/user_repository/user_repository.dart';

import 'package:gp91/welcome/welcome_screen.dart';

class AuthRepository extends GetxController {
  static AuthRepository get instance => Get.find();

  final _auth = FirebaseAuth.instance;
  // normal user
  late final Rx<User?> firebaseUser;

  // employee?

  @override
  void onReady() {
    firebaseUser = Rx<User?>(_auth.currentUser);
    firebaseUser.bindStream(_auth.userChanges());
    ever(firebaseUser, _setInitialScreen);
  }

  _setInitialScreen(User? user) {
    // user == null
    //     ? Get.offAll(() => OnBoardingScreen())
    //     : Get.offAll(() => const HomeScreen());
    if (user != null) {
      print("HI: user ${user}");
      Get.offAll(() => const HomeScreen());
    }
  }

  Future<void> createUserWithEmailAndPassword(UserModel userModel) async {
    try {
      Get.dialog(
        const Center(child: CircularProgressIndicator()),
      );
      print(
          "Future<void> createUserWithEmailAndPassword(UserModel userModel) async entered");
      final existingMethods = await FirebaseAuth.instance
          .fetchSignInMethodsForEmail(userModel.email!);

      if (existingMethods.isEmpty) {
        print("// Email is not in use, proceed with registration");
        // Email is not in use, proceed with registration
        final userCredential =
            await FirebaseAuth.instance.createUserWithEmailAndPassword(
          email: userModel.email!,
          password: userModel.password!,
        );

        if (userCredential.user != null) {
          // User registration succeeded, now add the user to Firestore
          // userModel.uid = userCredential.user
          //     .uid; // Assuming you have a field for user UID in your UserModel
          await UserRepository.instance.createUser(userModel);

          // Display a success message to the user
          Get.back();
          Get.snackbar(
            "Success",
            "Your account has been created",
            snackPosition: SnackPosition.BOTTOM,
            backgroundColor: Colors.green.withOpacity(0.1),
            colorText: Colors.green,
          );
        }
      } else {
        print("// Email is already in use, show an error message");
        // Email is already in use, show an error message
        Get.back();
        Get.snackbar(
          "Error",
          "Email is already in use",
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.redAccent.withOpacity(0.1),
          colorText: Colors.red,
        );
      }
    } on FirebaseAuthException catch (e) {
      // Handle Firebase Authentication exceptions
      final ex = SignUpWithEmailAndPasswordFailure.code(e.code);
      print('FIREBASE AUTH EXCEPTION - ${ex.message}');
      print("// Email is already in use, show an error message");
      // Email is already in use, show an error message
      Get.back();
      Get.snackbar(
        "Error",
        "Email is already in use",
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.redAccent.withOpacity(0.1),
        colorText: Colors.red,
      );
      throw ex;
    } catch (e, a) {
      // Handle other exceptions
      print(e);
      print(a);
      const ex = SignUpWithEmailAndPasswordFailure();
      Get.back();
      print('Exception - ${ex.message}');
      throw ex;
    }
  }
  //

  Future<User?> signInWithEmailAndPassword(
      String email, String password) async {
    try {
      UserCredential credential = await _auth.signInWithEmailAndPassword(
          email: email, password: password);
      return credential.user;
    } catch (e) {
      print(e);
    }
    return null;
  }

  // Future<void> logout() async => await _auth.signOut();
  Future<void> logoutAndNavigateToWelcomePage() async {
    // Log the user out (replace this with your actual logout code).
    await _auth.signOut();

    // Navigate to the welcome page using GetX's navigation.
    Get.to(() => WelcomeScreen());
  }
}
