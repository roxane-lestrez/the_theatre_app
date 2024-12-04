import 'package:flutter/material.dart';

class SynopsisPage extends StatelessWidget {
  final String synopsis;

  const SynopsisPage({super.key, required this.synopsis});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Synopsis'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Text(
            synopsis,
            style: const TextStyle(fontSize: 16),
          ),
        ),
      ),
    );
  }
}
