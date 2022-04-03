import 'package:firebase_database/firebase_database.dart';

class UsersDatabase {
  final _usersRef = FirebaseDatabase.instance.ref().child('users');

  void saveUser(String uuid, Map userMap) {
    _usersRef.child(uuid).set(userMap);
  }
}
