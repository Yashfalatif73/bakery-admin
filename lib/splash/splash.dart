import 'package:bakeryadminapp/Auth/signup.dart';
import 'package:flutter/material.dart';
import 'dart:async';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Timer(const Duration(seconds: 2), () {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const SignUpScreen()),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFDE5B33),
      body: Column(
        children: [
          SizedBox(
            width: double.infinity,
            child: Image.asset(
              'images/splashimg.png',
              fit: BoxFit.cover,
            ),
          ),

          const Spacer(),
          const Text(
            'Food Ordering',
            style: TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          const Spacer(),
        ],
      ),
    );
  }
}
