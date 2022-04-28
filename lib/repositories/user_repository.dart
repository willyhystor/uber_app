import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:uber_rider/models/user_model.dart';

class UserRepository {
  Future<UserModel> getCurrentOnlineUserInfo() async {
    final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

    final currentUser = _firebaseAuth.currentUser;
    String userId = currentUser!.uid;

    DatabaseReference _reference =
        FirebaseDatabase.instance.ref().child('users').child(userId);

    UserModel? user;

    await _reference.once().then((value) {
      user = UserModel.fromSnapshot(value.snapshot);
    });

    return user!;
  }
}
