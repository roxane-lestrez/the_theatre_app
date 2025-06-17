import 'package:first_app/api_service.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:first_app/pages/tabs.dart';
import 'package:first_app/pages/login/login_page.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  SplashScreenState createState() => SplashScreenState();
}

class SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _checkAuthStatus();
  }

  Future<bool> checkSessionValidity(String cookie) async {
    final response = await callApiPost('check-session');
    if (response != null && response.statusCode == 200) {
      return true;
    }

    return false;
  }

  Future<void> _checkAuthStatus() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final cookie = prefs.getString('almond_cookie');

    if (cookie == null) {
      _navigateToLoginScreen();
      return;
    }

    try {
      final isStillAuthenticated = await checkSessionValidity(cookie);
      if (isStillAuthenticated) {
        _navigateToTabsScreen();
      } else {
        prefs.remove('almond_cookie');
        _navigateToLoginScreen();
      }
    } catch (e) {
      prefs.remove('almond_cookie');
      _navigateToLoginScreen();
    }
  }

  void _navigateToTabsScreen() {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => const TabsScreen()),
    );
  }

  void _navigateToLoginScreen() {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => const LoginPage()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: CircularProgressIndicator(),
      ),
    );
  }
}
