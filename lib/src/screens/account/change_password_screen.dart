import 'package:flutter/material.dart';

class ChangePasswordScreen extends StatelessWidget {
  const ChangePasswordScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.orange),
        title: const Text(
          "Change Password",
          style: TextStyle(
            fontFamily: 'Poppins',
            fontSize: 18,
            fontWeight: FontWeight.w600,
            color: Colors.white,
          ),
        ),
      ),
      body: const Center(
        child: Text(
          "Change Password Screen",
          style: TextStyle(
            fontFamily: 'Poppins',
            fontSize: 16,
            color: Colors.white,
          ),
        ),
      ),
    );
  }
}
