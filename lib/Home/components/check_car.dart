import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:gp91/Home/components/get_user_id.dart';

Future<bool> checkCarExists() async {
  // get current user's id
  final userId = await _getUserIdAsync();
  // get the document in Cars that has the same userId as the current user
  final QuerySnapshot snapshot = await FirebaseFirestore.instance
      .collection('Cars')
      .where('userId', isEqualTo: userId)
      .get();
// if there is a car it will return true, else will return false
  return snapshot.docs.isNotEmpty;
  //return true;
}

// get the user id before you check if a car exists
Future<String?> _getUserIdAsync() async {
  GetUserId getUserId = GetUserId();
  return await getUserId.getUserId();
}
