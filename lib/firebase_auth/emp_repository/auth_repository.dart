import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:gp91/employee/home.dart';
import 'package:gp91/welcome/welcome_screen.dart';

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
    if (user != null) {
      Get.offAll(() => const Home(
            email: '..',
            //station_name: '..',
          ));
    }
  }

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

  Future<bool> validateEmployeeCredentials(String email) async {
    // Query the collection
    QuerySnapshot<Map<String, dynamic>> querySnapshot = await FirebaseFirestore
        .instance
        .collection('Station_Employee')
        .where('email', isEqualTo: email)
        .get();

    // Check if there is a matching record
    return querySnapshot.docs.isNotEmpty;
  }
}
