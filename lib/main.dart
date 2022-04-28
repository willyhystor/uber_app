import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:uber_rider/app.dart';

void main() async {
  // Initiate firebase

  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  runApp(App());
}

DatabaseReference usersRef = FirebaseDatabase.instance.ref().child('users');
