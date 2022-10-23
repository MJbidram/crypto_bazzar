import 'package:crypto_bazzar/screens/homeScreen.dart';
import 'package:crypto_bazzar/screens/loading.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApplication());
}

class MyApplication extends StatelessWidget {
  const MyApplication({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(body: LoadingScreen()),
    );
  }
}
