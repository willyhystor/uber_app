import 'package:flutter/material.dart';
import 'package:uber_rider/config/app_assets.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({Key? key}) : super(key: key);

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
                image: AssetImage(AppAssets.imageLogo),
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
            const SizedBox(height: 8),

            // Login Button
            SizedBox(
              width: MediaQuery.of(context).size.width * 0.8,
              child: ElevatedButton(
                onPressed: onLogin,
                style: ButtonStyle(
                  shape: MaterialStateProperty.resolveWith(
                    (states) => getOutlinedBorder(states),
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
              onPressed: onRegister,
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

  OutlinedBorder getOutlinedBorder(Set<MaterialState> states) {
    return RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(24),
    );
  }

  void onLogin() {
    print('login');
  }

  void onRegister() {
    print('register');
  }
}
