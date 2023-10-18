import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:gp91/Home/screens/home_screen.dart';
import 'package:gp91/exceptions/signup_email_password_failure.dart';
import 'package:gp91/firebase_auth/user_model.dart';
import 'package:gp91/firebase_auth/user_repository/user_repository.dart';
import 'package:gp91/login/login.dart';
import 'package:gp91/logout.dart';
import 'package:gp91/screens/welcome_screen.dart';

class AuthRepository extends GetxController {
  static AuthRepository get instance => Get.find();

  final _auth = FirebaseAuth.instance;
  late final Rx<User?> firebaseUser;

  @override
  void onReady() {
    firebaseUser = Rx<User?>(_auth.currentUser);
    firebaseUser.bindStream(_auth.userChanges());
    ever(firebaseUser, _setInitialScreen);
  }

  _setInitialScreen(User? user) {
    user == null
        ? Get.offAll(() => WelcomeScreen())
        // home page
        : Get.offAll(() => Logout());
    // WelcomeScreen()
  }

  // Future<User?> signUpWithEmailAndPassword(
  //     String email, String password) async {
  //   try {
  //     UserCredential credential = await _auth.createUserWithEmailAndPassword(
  //         email: email, password: password);
  //     return credential.user;
  //   } catch (e) {
  //     print("Some error occured in sign(Up)WithEmailAndPassword");
  //   }

  //   return null;
  // }

  // Future<User?> createUserWithEmailAndPassword(
  //     String email, String password) async {
  //   try {
  //     UserCredential credential =
  //         await FirebaseAuth.instance.createUserWithEmailAndPassword(
  //       email: email,
  //       password: password,
  //     );
  //     Get.showSnackbar(
  //       const GetSnackBar(
  //         message: "Good work, the name is not in use",
  //       ),
  //     );
  //     return credential.user;
  //   } on FirebaseAuthException catch (e) {
  //     final ex = SignUpWithEmailAndPasswordFailure.code(e.code);
  //     print('FIREBASE AUTH EXCEPTION - ${ex.message}');
  //     throw ex;
  //   } catch (_) {
  //     const ex = SignUpWithEmailAndPasswordFailure();
  //     print('Exception - ${ex.message}');
  //     throw ex;
  //   }
  // }

  Future<void> createUserWithEmailAndPassword(UserModel userModel) async {
    try {
      Get.dialog(
        Center(child: CircularProgressIndicator()),
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
    } catch (_) {
      // Handle other exceptions
      const ex = SignUpWithEmailAndPasswordFailure();
      Get.back();
      print('Exception - ${ex.message}');
      throw ex;
    }
  }

  // Future<User?> createUserWithEmailAndPassword(
  //     String email, String password) async {
  //   try {
  //     // Check if the email is already associated with an account
  //     final existingMethods =
  //         await FirebaseAuth.instance.fetchSignInMethodsForEmail(email);

  //     if (existingMethods.isEmpty) {
  //       // The email is not in use, so proceed with registration
  //       UserCredential credential =
  //           await FirebaseAuth.instance.createUserWithEmailAndPassword(
  //         email: email,
  //         password: password,
  //       );
  //       Get.showSnackbar(
  //         const GetSnackBar(
  //           message: "Good work, the email is not in use",
  //         ),
  //       );
  //       return credential.user;
  //     } else {
  //       // The email is already in use
  //       Get.showSnackbar(
  //         const GetSnackBar(
  //           message: "Oops!, the email is already in use",
  //         ),
  //       );
  //       throw const SignUpWithEmailAndPasswordFailure(
  //           'Email is already in use');
  //     }
  //   } on FirebaseAuthException catch (e) {
  //     final ex = SignUpWithEmailAndPasswordFailure.code(e.code);
  //     print('FIREBASE AUTH EXCEPTION - ${ex.message}');
  //     throw ex;
  //   } catch (_) {
  //     const ex = SignUpWithEmailAndPasswordFailure();
  //     print('Exception - ${ex.message}');
  //     throw ex;
  //   }
  // }

  // Future<void> loginWithEmailAndPassword(String email, String password) async {
  //   try {
  //     await _auth.signInWithEmailAndPassword(email: email, password: password);
  //   } on FirebaseAuthException catch (e) {
  //     // e.code
  //   } catch (_) {}
  // }

  Future<User?> signInWithEmailAndPassword(
      String email, String password) async {
    try {
      UserCredential credential = await _auth.signInWithEmailAndPassword(
          email: email, password: password);
      return credential.user;
    } catch (e) {
      print("Some error occured in sign(In)WithEmailAndPassword");
    }

    return null;
  }

  // Future<User?> signInWithEmailAndPassword(
  //     String email, String password, BuildContext context) async {
  //   try {
  //     showDialog(
  //       context: context,
  //       builder: (context) {
  //         return const Center(child: CircularProgressIndicator());
  //       },
  //     );

  //     UserCredential credential = await _auth.signInWithEmailAndPassword(
  //       email: email,
  //       password: password,
  //     );

  //     // Dismiss the loading indicator when sign-in is successful.
  //     Navigator.of(context).pop();

  //     // Check if the user exists.
  //     if (credential.user != null) {
  //       return credential.user;
  //     } else {
  //       print("User does not exist");
  //       return null;
  //     }
  //   } catch (e) {
  //     print("Some error occurred in sign(In)WithEmailAndPassword");

  //     // Dismiss the loading indicator when an error occurs.
  //     Navigator.of(context).pop();

  //     return null;
  //   }
  // }

  Future<void> logout() async => await _auth.signOut();
}
