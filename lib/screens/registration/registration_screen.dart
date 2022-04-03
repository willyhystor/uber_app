import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:uber_rider/configs/asset_config.dart';
import 'package:uber_rider/utilities/material_state_util.dart';
import 'package:uber_rider/main.dart';
import 'package:uber_rider/screens/home/home_screen.dart';
import 'package:uber_rider/utilities/regex_util.dart';
import 'package:uber_rider/widgets/loading_dialog.dart';

class RegistrationScreen extends StatefulWidget {
  const RegistrationScreen({Key? key}) : super(key: key);

  static const String route = 'registration';

  @override
  State<RegistrationScreen> createState() => _RegistrationScreenState();
}

class _RegistrationScreenState extends State<RegistrationScreen> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
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
              "Registration as a Rider",
              style: TextStyle(
                fontSize: 24,
                fontFamily: "Bolt Semi Bold",
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 4),

            // Name
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 40),
              child: TextFormField(
                keyboardType: TextInputType.text,
                controller: _nameController,
                decoration: const InputDecoration(
                  labelText: "Name",
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

            // Phone
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 40),
              child: TextFormField(
                keyboardType: TextInputType.phone,
                controller: _phoneController,
                decoration: const InputDecoration(
                  labelText: "Phone",
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

            // Registration Button
            SizedBox(
              width: MediaQuery.of(context).size.width * 0.8,
              child: ElevatedButton(
                onPressed: () {
                  if (_validateForm()) {
                    _onRegister();
                  }
                },
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.resolveWith(
                    (states) => MaterialStateUtility.getButtonColor(states),
                  ),
                  shape: MaterialStateProperty.resolveWith(
                    (states) => MaterialStateUtility.getOutlinedBorder(states),
                  ),
                ),
                child: const Text(
                  'Register',
                  style: TextStyle(
                    fontSize: 18,
                    fontFamily: "Bolt Semi Bold",
                  ),
                ),
              ),
            ),
            const SizedBox(height: 8),

            // Login Button
            TextButton(
              onPressed: () => toLogin(context),
              child: const Text(
                'Already have an account? Login here.',
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
    if (_nameController.text.length < 4) {
      Fluttertoast.showToast(msg: 'Name must be at least 4 characters');

      result = false;
    }

    if (RegexUtil.checkEmail(_emailController.text)) {
      Fluttertoast.showToast(msg: 'Invalid email address');

      result = false;
    }

    if (_phoneController.text.length < 10 &&
        _phoneController.text.length > 12) {
      Fluttertoast.showToast(msg: 'Phonenumber must between 10-12 digits');

      result = false;
    }

    if (_passwordController.text.length < 8) {
      Fluttertoast.showToast(msg: 'Password must be at least 8 characters');

      result = false;
    }

    return result;
  }

  void _onRegister() async {
    final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

    // Show dialog
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return LoadingDialog(msg: 'Please wait...');
        });

    final user = (await _firebaseAuth
            .createUserWithEmailAndPassword(
      email: _emailController.text,
      password: _passwordController.text,
    )
            .catchError((e) {
      Fluttertoast.showToast(msg: e.message);
    }))
        .user;

    if (user != null) {
      final userMap = {
        'name': _nameController.text.trim(),
        'email': _emailController.text.trim(),
        'phone': _phoneController.text.trim(),
      };

      try {
        usersRef.child(user.uid).set(userMap);
      } catch (e) {
        Fluttertoast.showToast(msg: e.toString());
      }

      Fluttertoast.showToast(
          msg: 'Congratulations, your account has been created');

      Navigator.pushNamedAndRemoveUntil(
          context, HomeScreen.route, (route) => false);
    } else {
      Fluttertoast.showToast(
          msg: 'There is some problem, please contact our Help Center');
    }

    // close dialog
    Navigator.pop(context);
  }

  void toLogin(BuildContext context) {
    Navigator.of(context).pop();
  }
}
