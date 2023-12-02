import 'package:cloud_firestore/cloud_firestore.dart';

class CarInfoHandler {
  // Retrieve specific car based on user ID
  static Stream<DocumentSnapshot<Map<String, dynamic>>> getCarDataStream(
      String carId) {
    return FirebaseFirestore.instance.collection('Cars').doc(carId).snapshots();
  }
}
