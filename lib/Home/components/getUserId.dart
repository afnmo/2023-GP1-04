import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get_rx/src/rx_types/rx_types.dart';

class GetUserId {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  late Rx<User?> firebaseUser;

  GetUserId() {
    firebaseUser = Rx<User?>(_auth.currentUser);
  }

  String? getCurrentUserEmail() {
    return _auth.currentUser?.email;
  }

  Future<String?> getUserId() async {
    try {
      String? email = getCurrentUserEmail();
      if (email == null) {
        // Optionally, you can show a different snackbar or handle this case separately
        return null;
      }

      var querySnapshot = await FirebaseFirestore.instance
          .collection('Users')
          .where('email', isEqualTo: email)
          .limit(1)
          .get();

      if (querySnapshot.docs.isNotEmpty) {
        return querySnapshot.docs.first.id;
      } else {
        return null;
      }
    } catch (e) {
      print('Error retrieving user ID: $e');
      return null;
    }
  }
}
