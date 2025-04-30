import 'package:bakeryadminapp/Auth/signup.dart';
import 'package:bakeryadminapp/bottom_bar/bottom_bar.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class SignInScreen extends StatefulWidget {
  const SignInScreen({super.key});

  @override
  State<SignInScreen> createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  final _emailController = TextEditingController();
  final _passController = TextEditingController();
  bool _obscurePassword = true;
  bool _isLoading = false;

  Future<void> loginUser() async {
    setState(() => _isLoading = true);
    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: _emailController.text.trim(),
        password: _passController.text.trim(),
      );

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const BottomBarScreen()),
      );
    } on FirebaseAuthException catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(e.message ?? 'Login failed')),
      );
    } finally {
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Login'), backgroundColor: const Color(0xffEEEEE6)),
      backgroundColor: const Color(0xffEEEEE6),
      body: SingleChildScrollView(
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text("Email"), const SizedBox(height: 8),
                TextFormField(controller: _emailController, decoration: _inputDecoration()),

                const SizedBox(height: 20), const Text("Password"), const SizedBox(height: 8),
                TextFormField(
                  controller: _passController,
                  obscureText: _obscurePassword,
                  decoration: _inputDecoration().copyWith(
                    suffixIcon: IconButton(
                      icon: Icon(_obscurePassword ? Icons.visibility_off : Icons.visibility),
                      onPressed: () => setState(() => _obscurePassword = !_obscurePassword),
                    ),
                  ),
                ),

                const SizedBox(height: 10),
                const Align(
                  alignment: Alignment.centerRight,
                  child: Text("Forget your password?", style: TextStyle(fontStyle: FontStyle.italic)),
                ),

                const SizedBox(height: 30),
                Align(
                  alignment: Alignment.center,
                  child: ElevatedButton(
                    onPressed: _isLoading ? null : loginUser,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green[800],
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                      padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 14),
                    ),
                    child: _isLoading
                        ? const CircularProgressIndicator(color: Colors.white)
                        : const Text("Proceed", style: TextStyle(color: Colors.white)),
                  ),
                ),

                const SizedBox(height: 30),
                Align(
                  alignment: Alignment.center,
                  child: GestureDetector(
                    onTap: () => Navigator.pushReplacement(
                        context, MaterialPageRoute(builder: (_) => const SignUpScreen())),
                    child: const Text.rich(
                      TextSpan(
                        text: "Didn't have any accounts? ",
                        children: [
                          TextSpan(text: "Click here", style: TextStyle(color: Colors.blue)),
                          TextSpan(text: " to create new"),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  InputDecoration _inputDecoration() {
    return const InputDecoration(
      filled: true,
      fillColor: Colors.white,
      border: InputBorder.none,
    );
  }
}
