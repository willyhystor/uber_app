import 'package:firebase_database/firebase_database.dart';

class UserModel {
  late String id;
  late String email;
  late String name;
  late String phone;

  UserModel({
    required this.id,
    required this.email,
    required this.name,
    required this.phone,
  });

  UserModel.fromSnapshot(DataSnapshot snapshot) {
    final map = snapshot.value as Map;

    id = snapshot.key!;
    email = map['email'];
    name = map['name'];
    phone = map['phone'];
  }
}
