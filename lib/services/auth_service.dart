import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:logger/logger.dart';
import 'package:traxpense/helpers/daily_expense.dart';
import 'package:traxpense/helpers/object_converter.dart';

class AuthService {
  var logger = Logger();
  // google sign in method
  signInWithGoogle() async {
    // begin interactive sign in process
    try {
      final GoogleSignInAccount? gUser = await GoogleSignIn().signIn();

      // obtain auth details from req
      final GoogleSignInAuthentication? gAuth = await gUser?.authentication;

      // create a new credential for user
      final credential = GoogleAuthProvider.credential(
        accessToken: gAuth?.accessToken,
        idToken: gAuth?.idToken,
      );

      UserCredential userCredential =
          await FirebaseAuth.instance.signInWithCredential(credential);

      // create a user document and add to firestore
      await createUserDocument(userCredential);
      return userCredential;
    } catch (e) {
      // im not gonna handle the error
    }

    // sign in
  }

  Future<void> createUserDocument(UserCredential? userCredential) async {
    Map<DateTime, DailyExpense> dailyExpenses = {};

    ObjectConverter objectConverter = ObjectConverter();

    Map<String, dynamic> dataToStore =
        objectConverter.dailyExpensesToFireStoreMap(dailyExpenses);

    if (userCredential != null && userCredential.user != null) {
      await FirebaseFirestore.instance
          .collection("User")
          .doc(userCredential.user!.uid)
          .set({
        "uid": userCredential.user!.uid,
        "email": userCredential.user!.email,
        "dailyExpenses": dataToStore,
      });
    }
  }
}
