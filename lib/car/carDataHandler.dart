import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class carDataHandler {
  static Future<String?> findDocumentIdByEmail() async {
    FirebaseAuth auth = FirebaseAuth.instance;
    User? user = auth.currentUser;

    CollectionReference usersCollection =
        FirebaseFirestore.instance.collection('Users');

    QuerySnapshot querySnapshot =
        await usersCollection.where('email', isEqualTo: user?.email).get();

    if (querySnapshot.docs.isNotEmpty) {
      return querySnapshot.docs.first.id;
    } else {
      return null;
    }
  }

  static Future<List<String?>> fetchDocumentIdsByEmail() async {
    String? userDocId = await findDocumentIdByEmail();

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

  // Other database-related methods can also be added here
}
