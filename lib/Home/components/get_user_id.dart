import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';

class GetUserId {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  late Rx<User?> firebaseUser;

  GetUserId() {
    // get the current user from the Firebase authentication service.
    firebaseUser = Rx<User?>(_auth.currentUser);
  }

  String? getCurrentUserEmail() {
    // get the current user's email, the id is not a field so u need email
    return _auth.currentUser?.email;
  }

  Future<String?> getUserId() async {
    try {
      String? email = getCurrentUserEmail();
      if (email == null) {
        // If the user's email is not available, return null.
        return null;
      }
// If the user's email is available get the document with the same email
      var querySnapshot = await FirebaseFirestore.instance
          .collection('Users')
          .where('email', isEqualTo: email)
          .limit(1)
          .get();

      if (querySnapshot.docs.isNotEmpty) {
        // if it exits get the document's id
        return querySnapshot.docs.first.id;
      } else {
        return null;
      }
    } catch (e) {
      // if (kDebugMode) {
      //   print('Error retrieving user ID: $e');
      // }
      return null;
    }
  }
}
