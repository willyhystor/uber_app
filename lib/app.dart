import 'package:flutter/material.dart';
import 'package:uber_rider/configs/firebase_config.dart';
import 'package:uber_rider/screens/home/home_screen.dart';
import 'package:uber_rider/screens/login/login_screen.dart';
import 'package:uber_rider/screens/registration/registration_screen.dart';

class App extends StatefulWidget {
  const App({Key? key}) : super(key: key);

  @override
  State<App> createState() => _AppState();
}

class _AppState extends State<App> {
  // Initiate db reference
  // DatabaseReference usersRef = FirebaseDatabase.instance.ref().child('users'); // should be added located to folder db

  // Initiate firebase
  final FirebaseConfig _firebaseConfig = FirebaseConfig();

  @override
  void initState() {
    WidgetsFlutterBinding.ensureInitialized();
    _firebaseConfig.initiate();

    super.initState();
  }

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
        HomeScreen.route: (context) =>
            const HomeScreen(title: 'Uber Rider Mock'),
        LoginScreen.route: (context) => const LoginScreen(),
        RegistrationScreen.route: (context) => const RegistrationScreen(),
      },
      debugShowCheckedModeBanner: true,
    );
  }
}
