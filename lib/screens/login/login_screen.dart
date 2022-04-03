import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:uber_rider/configs/asset_config.dart';
import 'package:uber_rider/utilities/material_state_util.dart';
import 'package:uber_rider/main.dart';
import 'package:uber_rider/screens/home/home_screen.dart';
import 'package:uber_rider/screens/registration/registration_screen.dart';
import 'package:uber_rider/utilities/regex_util.dart';
import 'package:uber_rider/widgets/loading_dialog.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  static const String route = 'login';

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Logo
            SizedBox(
              width: double.infinity,
              child: Image(
                image: AssetImage(AssetConfig.imageLogo),
                alignment: Alignment.center,
              ),
            ),
            const SizedBox(height: 4),

            // Label
            const Text(
              "Login as a Rider",
              style: TextStyle(
                fontSize: 24,
                fontFamily: "Bolt Semi Bold",
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 4),

            // Email
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 40),
              child: TextFormField(
                keyboardType: TextInputType.emailAddress,
                controller: _emailController,
                decoration: const InputDecoration(
                  labelText: "Email",
                  labelStyle: TextStyle(
                    fontSize: 14,
                  ),
                  hintStyle: TextStyle(
                    fontSize: 10,
                    color: Colors.grey,
                  ),
                ),
                style: const TextStyle(
                  fontSize: 14,
                ),
              ),
            ),
            const SizedBox(height: 4),

            // Password
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 40),
              child: TextFormField(
                obscureText: true,
                controller: _passwordController,
                decoration: const InputDecoration(
                  labelText: "Password",
                  labelStyle: TextStyle(
                    fontSize: 14,
                  ),
                  hintStyle: TextStyle(
                    fontSize: 10,
                    color: Colors.grey,
                  ),
                ),
                style: const TextStyle(
                  fontSize: 14,
                ),
              ),
            ),
            const SizedBox(height: 20),

            // Login Button
            SizedBox(
              width: MediaQuery.of(context).size.width * 0.8,
              child: ElevatedButton(
                onPressed: () {
                  if (_validateForm()) {
                    onLogin(context);
                  }
                },
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.resolveWith(
                      (states) => MaterialStateUtility.getButtonColor(states)),
                  shape: MaterialStateProperty.resolveWith(
                    (states) => MaterialStateUtility.getOutlinedBorder(states),
                  ),
                ),
                child: const Text(
                  'Login',
                  style: TextStyle(
                    fontSize: 18,
                    fontFamily: "Bolt Semi Bold",
                  ),
                ),
              ),
            ),
            const SizedBox(height: 8),

            // Register Button
            TextButton(
              onPressed: () => toRegister(context),
              child: const Text(
                'Do not have an account? Register here.',
                style: TextStyle(
                  fontSize: 14,
                  fontFamily: "Bolt Semi Bold",
                ),
              ),
            ),
            const SizedBox(height: 8),
          ],
        ),
      ),
    );
  }

  bool _validateForm() {
    bool result = true;
    if (RegexUtil.checkEmail(_emailController.text)) {
      Fluttertoast.showToast(msg: 'Invalid email address');

      result = false;
    }

    if (_passwordController.text.length < 8) {
      Fluttertoast.showToast(msg: 'Password must be at least 8 characters');

      result = false;
    }

    return result;
  }

  void onLogin(BuildContext context) async {
    // Show dialog
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return LoadingDialog(msg: 'Please wait...');
        });

    final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

    final user = (await _firebaseAuth
            .signInWithEmailAndPassword(
      email: _emailController.text,
      password: _passwordController.text,
    )
            .catchError((e) {
      Fluttertoast.showToast(msg: e.message);
    }))
        .user;

    if (user != null) {
      usersRef.child(user.uid).once().then((value) => handleAuth(value, user));
    } else {
      Fluttertoast.showToast(
          msg: 'There is some problem, please contact our Help Center');
    }

    // close dialog
    Navigator.pop(context);
  }

  void handleAuth(DatabaseEvent value, User user) {
    final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

    if (value.snapshot.value != null) {
      Fluttertoast.showToast(msg: 'Welcome ${user.displayName}');

      Navigator.pushNamedAndRemoveUntil(
          context, HomeScreen.route, (route) => false);
    } else {
      _firebaseAuth.signOut();

      Fluttertoast.showToast(
          msg: 'Account not found, please create new account');
    }
  }

  void toRegister(BuildContext context) {
    Navigator.pushNamed(context, RegistrationScreen.route);
  }
}
