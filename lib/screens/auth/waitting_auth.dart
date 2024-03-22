import 'package:flutter/material.dart';

class Authenticating extends StatefulWidget {
  const Authenticating({super.key});

  @override
  State<Authenticating> createState() => _AuthenticatingState();
}

class _AuthenticatingState extends State<Authenticating> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Networking'),
      ),
      body: const Center(
        child: Text('Loading...'),
      ),
    );
  }
}
