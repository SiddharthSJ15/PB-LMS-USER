import 'package:flutter/material.dart';
import 'package:pb_lms/utilities/token_manager.dart';
import 'package:pb_lms/views/login_screen.dart';
import 'package:pb_lms/views/user_screen/main_screen/main_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    // Load resources or perform initialization tasks
    _loadResources();
  }

  Future<void> _loadResources() async {
    await Future.delayed(const Duration(seconds: 3));
    // Navigate to the next screen after loading resources
    final token = await TokenManager.getToken();
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(
        builder: (context) => token != null ? MainScreen() : LoginScreen(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const CircularProgressIndicator(),
            const SizedBox(height: 20),
            Text('Loading...', style: Theme.of(context).textTheme.titleLarge),
          ],
        ),
      ),
    );
  }
}
