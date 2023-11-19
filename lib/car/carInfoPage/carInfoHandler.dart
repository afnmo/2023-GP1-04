import 'package:cloud_firestore/cloud_firestore.dart';

class carInfoHandler {
  static Future<DocumentSnapshot> getCarData(String carId) async {
    return await FirebaseFirestore.instance.collection('Cars').doc(carId).get();
  }
}
