import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:gp91/Home/components/getUserId.dart';

Future<bool> checkCarExists() async {
  final userId = await _getUserIdAsync();
  final QuerySnapshot snapshot = await FirebaseFirestore.instance
      .collection('Cars')
      .where('userId', isEqualTo: userId)
      .get();

  //return snapshot.docs.isNotEmpty;
  return true;
}

Future<String?> _getUserIdAsync() async {
  GetUserId getUserId = GetUserId();
  return await getUserId.getUserId();
}
