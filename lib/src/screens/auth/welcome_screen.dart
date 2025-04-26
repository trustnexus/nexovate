import 'package:flutter/material.dart';
import 'package:animate_do/animate_do.dart';

class AppImages {
  static const logo = 'assets/images/logo_enhanced.png';
}

 class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            
            const SizedBox(height: 10),

            /// 👇 Logo Image
            FadeInDown(
              delay: const Duration(milliseconds: 300),
              child: Image.asset(
                AppImages.logo,
                height: 360,
                width: 360,
              ),
            ),

            const SizedBox(height: 25),
            FadeInDown(
              delay: const Duration(milliseconds: 400),
              duration: const Duration(milliseconds: 800),
              child: const Text(
                "Empowering your ideas\nwith the right talent!",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 16,
                  fontFamily: 'Poppins',
                  color: Colors.white70,
                  height: 1.5,
                ),
              ),
            ),
            const SizedBox(height: 50),
            SlideInUp(
              duration: const Duration(milliseconds: 1000),
              child: GestureDetector(
                onTap: () => Navigator.pushNamed(context, '/login'),
                child: Container(
                  width: 220,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [Color(0xFFFF8C00), Color(0xFFD500F9)],
                      begin: Alignment.centerLeft,
                      end: Alignment.centerRight,
                    ),
                    borderRadius: BorderRadius.circular(30),
                    boxShadow: const [
                      BoxShadow(
                        color: Color(0x4DFF6E40),
                        blurRadius: 12,
                        spreadRadius: 1,
                        offset: Offset(0, 6),
                      ),
                    ],
                  ),
                  child: const Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "Get Started",
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          fontFamily: 'Poppins',
                          color: Colors.white,
                        ),
                      ),
                      SizedBox(width: 8),
                      Icon(Icons.arrow_forward, color: Colors.white),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
