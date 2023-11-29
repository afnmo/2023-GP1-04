import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class carDataHandler {
  static Stream<List<String?>> fetchCarDocumentIdsAsStream() async* {
    try {
      FirebaseAuth auth = FirebaseAuth.instance;
      User? user = auth.currentUser;

      if (user != null) {
        CollectionReference usersCollection =
            FirebaseFirestore.instance.collection('Users');

        QuerySnapshot querySnapshot = await usersCollection
            .where('email', isEqualTo: user.email)
            .limit(1)
            .get();

        if (querySnapshot.docs.isNotEmpty) {
          String userDocId = querySnapshot.docs.first.id;

          final carCollection = FirebaseFirestore.instance.collection('Cars');
          Stream<QuerySnapshot> carQueryStream = carCollection
              .where('userId', isEqualTo: userDocId)
              .snapshots(); // Get the live stream of car documents

          await for (QuerySnapshot carSnapshot in carQueryStream) {
            List<String?> carDocumentIds =
                carSnapshot.docs.map<String?>((carDoc) => carDoc.id).toList();

            yield carDocumentIds; // Yield the list of car document IDs
          }
        }
      }
    } catch (e) {
      print('Error fetching car document IDs: $e');
      yield [];
    }
  }
}
