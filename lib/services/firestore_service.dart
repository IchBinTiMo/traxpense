import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class FirestoreService {
  final User _user = FirebaseAuth.instance.currentUser!;

  // get all expense items
  Future<DocumentSnapshot<Map<String, dynamic>>> getUserExps() async {
    final tmp = await FirebaseFirestore.instance
        .collection("User")
        .doc(_user.uid)
        .get();
    return tmp;
  }

  // create a new expense

  // delete an expense

  // update an expense
}
