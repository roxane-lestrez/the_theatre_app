import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  RegisterPageState createState() => RegisterPageState();
}

class RegisterPageState extends State<RegisterPage> {
  final _formKey = GlobalKey<FormState>();
  String _email = '';
  String _password = '';
  String _pseudo = '';
  bool _newsletter = false;
  String _errorMessage = '';

  Future<void> registerUser(BuildContext context) async {
    final url = Uri.parse('https://tta.alwaysdata.net/register');

    // POST login request.
    final response = await http.post(
      url,
      headers: {
        'Content-Type': 'application/json',
      },
      body: json.encode({
        'email': _email,
        'password': _password,
        'pseudo': _pseudo,
        'newsletter': _newsletter,
      }),
    );

    if (response.statusCode == 201) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (Navigator.canPop(context)) {
          Navigator.pop(context);
        }
      });
    } else {
      setState(() {
        _errorMessage = 'Account creation failed';
      });
    }
  }

  void _submitRegistration() {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      registerUser(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Create your account')),
      resizeToAvoidBottomInset: true,
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Display error message if any.
              if (_errorMessage.isNotEmpty)
                Text(
                  _errorMessage,
                  style: const TextStyle(color: Colors.red),
                ),
              const SizedBox(height: 16.0),

              // Field for username.
              TextFormField(
                decoration: const InputDecoration(
                  labelText: 'Username',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a username';
                  }
                  return null;
                },
                onSaved: (value) {
                  _pseudo = value!;
                },
              ),

              const SizedBox(height: 16.0),

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

              const SizedBox(height: 16.0),

              // Checkbox for the newsletter.
              CheckboxListTile(
                title: const Text("Subscribe to our newsletter"),
                value: _newsletter,
                onChanged: (bool? value) {
                  setState(() {
                    _newsletter = value ?? false;
                  });
                },
              ),
              const SizedBox(height: 24.0),

              // Button to submit account creation
              ElevatedButton(
                onPressed: _submitRegistration,
                child: const Text('Create account'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
