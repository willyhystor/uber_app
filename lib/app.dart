import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:uber_rider/configs/firebase_config.dart';
import 'package:uber_rider/notifiers/location_notifier.dart';
import 'package:uber_rider/screens/home_screen.dart';
import 'package:uber_rider/screens/login_screen.dart';
import 'package:uber_rider/screens/registration_screen.dart';
import 'package:uber_rider/screens/search_location_screen.dart';

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
    return ChangeNotifierProvider(
      create: (BuildContext context) => LocationNotifier(),
      child: MaterialApp(
        title: 'Uber Driver',
        theme: ThemeData(
          primarySwatch: Colors.blue,
          fontFamily: "Bolt Semi Bold",
        ),
        initialRoute: HomeScreen.route,
        routes: {
          HomeScreen.route: (context) => HomeScreen(),
          LoginScreen.route: (context) => LoginScreen(),
          RegistrationScreen.route: (context) => RegistrationScreen(),
          SearchLocationScreen.route: (context) => SearchLocationScreen(),
        },
        debugShowCheckedModeBanner: true,
      ),
    );
  }
}
