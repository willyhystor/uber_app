import 'package:flutter/material.dart';
import 'package:uber_rider/configs/asset_config.dart';
import 'package:uber_rider/configs/material_state_config.dart';
import 'package:uber_rider/screens/registration/registration_screen.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({Key? key}) : super(key: key);

  static const String route = 'login';

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
                onPressed: () => onLogin(context),
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.resolveWith(
                      (states) => MaterialStateConfig.getButtonColor(states)),
                  shape: MaterialStateProperty.resolveWith(
                    (states) => MaterialStateConfig.getOutlinedBorder(states),
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
              onPressed: () => onRegister(context),
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

  void onLogin(BuildContext context) {
    Navigator.push<void>(
      context,
      MaterialPageRoute<void>(
        builder: (BuildContext context) => const RegistrationScreen(),
      ),
    );
  }

  void onRegister(BuildContext context) {
    Navigator.pushNamed(context, RegistrationScreen.route);
  }
}
