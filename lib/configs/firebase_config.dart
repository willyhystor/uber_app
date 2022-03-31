import 'package:firebase_core/firebase_core.dart';

class FirebaseConfig {
  Future<void> initiate() async {
    await Firebase.initializeApp();
  }
}
