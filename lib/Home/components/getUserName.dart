import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get_rx/src/rx_types/rx_types.dart';

class GetUserName {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  late Rx<User?> firebaseUser;

  GetUserName() {
    firebaseUser = Rx<User?>(_auth.currentUser);
  }

  String? getCurrentUserEmail() {
    return _auth.currentUser?.email;
  }

  Future<String?> getUserName() async {
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
        String name = "";
        name = querySnapshot.docs[0].data()['name'];
        return name;
      } else {
        return null;
      }
    } catch (e) {
      print('Error retrieving user name: $e');
      return null;
    }
  }
}
