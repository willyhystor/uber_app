import 'package:flutter/material.dart';
import 'package:uber_rider/screens/home_page/home_page_screen.dart';
import 'package:uber_rider/screens/login/login_screen.dart';
import 'package:uber_rider/screens/registration/registration_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Uber Driver',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        fontFamily: "Bolt Semi Bold",
      ),
      initialRoute: LoginScreen.route,
      routes: {
        HomePageScreen.route: (context) =>
            const HomePageScreen(title: 'Uber Rider Mock'),
        LoginScreen.route: (context) => const LoginScreen(),
        RegistrationScreen.route: (context) => const RegistrationScreen(),
      },
      debugShowCheckedModeBanner: true,
    );
  }
}
