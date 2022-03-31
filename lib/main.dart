import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:uber_rider/app.dart';

void main() {
  runApp(const App());
}

DatabaseReference usersRef = FirebaseDatabase.instance.ref().child('users');
