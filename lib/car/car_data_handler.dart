import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class CarDataHandler {
  //Retrieve from cars collection based on user ID
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
          Stream<QuerySnapshot> carQueryStream =
              carCollection.where('userId', isEqualTo: userDocId).snapshots();

          await for (QuerySnapshot carSnapshot in carQueryStream) {
            List<String?> carDocumentIds =
                carSnapshot.docs.map<String?>((carDoc) => carDoc.id).toList();

            yield carDocumentIds;
          }
        }
      }
    } catch (e) {
      print('Error fetching car document IDs: $e');
      yield [];
    }
  }

// Delete the car with related bills and fuel consumption
  Future<void> deleteCar(String carDocumentId) async {
    try {
      await FirebaseFirestore.instance
          .collection('Cars')
          .doc(carDocumentId)
          .delete();

      QuerySnapshot billsSnapshot = await FirebaseFirestore.instance
          .collection('Bills')
          .where('carId', isEqualTo: carDocumentId)
          .get();

      List<Future<void>> deleteBills = [];
      for (DocumentSnapshot bill in billsSnapshot.docs) {
        deleteBills.add(bill.reference.delete());
      }

      await Future.wait(deleteBills);

      QuerySnapshot consumptionSnapshot = await FirebaseFirestore.instance
          .collection('Consumption')
          .where('carId', isEqualTo: carDocumentId)
          .get();

      List<Future<void>> deleteConsumption = [];
      for (DocumentSnapshot consumption in consumptionSnapshot.docs) {
        deleteConsumption.add(consumption.reference.delete());
      }

      await Future.wait(deleteConsumption);
    } catch (e) {
      print('Error deleting car: $e');
    }
  }
}
