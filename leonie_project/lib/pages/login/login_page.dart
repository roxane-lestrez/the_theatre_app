import 'package:first_app/pages/login/register_page.dart';
import 'package:first_app/pages/tabs.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  LoginPageState createState() => LoginPageState();
}

class LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  String _email = '';
  String _password = '';
  String _errorMessage = '';

  Future<bool> loginUser() async {
    final url = Uri.parse('https://tta.alwaysdata.net/login');

    // POST login request.
    final response = await http.post(
      url,
      headers: {
        'Content-Type': 'application/json',
      },
      body: json.encode({
        'email': _email,
        'password': _password,
      }),
    );

    if (response.statusCode == 200) {
      // Cookies extraction (token and username).
      String? rawCookie = response.headers['set-cookie'];
      // String? pseudo = response.headers['pseudo'];

      if (rawCookie != null) {
        int index = rawCookie.indexOf(';');
        String cookie =
            (index == -1) ? rawCookie : rawCookie.substring(0, index);
        SharedPreferences prefs = await SharedPreferences.getInstance();
        await prefs.setString('almond_cookie', cookie);
      }

      // if (pseudo != null) {
      //   int index = pseudo.indexOf(';');
      //   String cookiePseudo =
      //       (index == -1) ? pseudo : pseudo.substring(0, index);
      //   SharedPreferences prefs = await SharedPreferences.getInstance();
      //   await prefs.setString('pseudo', cookiePseudo);
      // }

      return true;
    } else {
      setState(() {
        _errorMessage = 'Invalid password';
      });
      return false;
    }
  }

  void navigateToTabsScreen(BuildContext context) {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => const TabsScreen(),
      ),
    );
  }

  void _submitLogin() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();

      loginUser().then((loginSuccess) {
        if (loginSuccess) {
          navigateToTabsScreen(context);
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    // Save the height of the device's screen
    final maxHeight = MediaQuery.of(context).size.height;
    return Scaffold(
      appBar: AppBar(
          title: const Text('Login'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Display error message if any.
                if (_errorMessage.isNotEmpty)
                  Text(
                    _errorMessage,
                    style: const TextStyle(color: Colors.red),
                  ),
          
                SizedBox(height: maxHeight / 10),
          
                Image.asset("assets/logo_theatre_app_extended.png"),
          
                SizedBox(height: maxHeight / 7),
          
                // Field for e-mail address.
                TextFormField(
                  decoration: const InputDecoration(
                    labelText: 'E-mail address',
                    border: OutlineInputBorder(),
                  ),
                  keyboardType: TextInputType.emailAddress,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your e-mail address';
                    } else if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$')
                        .hasMatch(value)) {
                      return 'Enter a valid e-mail address';
                    }
                    return null;
                  },
                  onSaved: (value) {
                    _email = value!;
                  },
                ),
          
                const SizedBox(height: 16.0),
          
                // Field for password.
                TextFormField(
                  decoration: const InputDecoration(
                    labelText: 'Password',
                    border: OutlineInputBorder(),
                  ),
                  obscureText: true,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your password';
                    }
                    return null;
                  },
                  onSaved: (value) {
                    _password = value!;
                  },
                ),
          
                const SizedBox(height: 24.0),
          
                // Button to validate the form.
                ElevatedButton(
                  onPressed: _submitLogin,
                  child: const Text('Confirm'),
                ),
          
                // Button to create an account.
                TextButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const RegisterPage()),
                    );
                  },
                  child: const Text('Create new account'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
