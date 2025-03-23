import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:washee/providers/auth_provider.dart';
import 'package:washee/screens/auth/login_screen.dart';
import 'package:washee/screens/home/home_screen.dart';
import 'dart:async';
import 'dart:io' show Platform;

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _checkAuthAndNavigate();
  }

  Future<void> _checkAuthAndNavigate() async {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    
    // Add a delay for the splash screen
    await Future.delayed(const Duration(seconds: 2));
    
    // Check if user is logged in
    final isLoggedIn = await authProvider.isUserLoggedIn();
    
    if (mounted) {
      if (isLoggedIn) {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (_) => const HomeScreen()),
        );
      } else {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (_) => const LoginScreen()),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Logo
            Image.asset(
              'assets/images/logo.png',
              width: 250,
              height: 100,
              fit: BoxFit.contain,
            ),
            const SizedBox(height: 48),
            // Loading indicator
            const CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF1E88E5)),
            ),
          ],
        ),
      ),
    );
  }
}

