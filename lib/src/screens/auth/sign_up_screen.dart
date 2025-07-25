// ! DEPRECATED FILE
// ! This file is deprecated and will be removed in future updates.
import 'package:flutter/material.dart';
import 'package:animate_do/animate_do.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:url_launcher/url_launcher.dart' as launcher;

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class AppImages {
  static const bg = 'assets/images/background.png';
}

class _SignupScreenState extends State<SignupScreen> {
  final _formKey = GlobalKey<FormState>();
  final _fullNameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;

  final GoogleSignIn _googleSignIn = GoogleSignIn(
    clientId: dotenv.env['GOOGLE_CLIENT_ID'],
  );

  void _onSignup() {
    if (_formKey.currentState!.validate()) {
      Navigator.pushReplacementNamed(context, '/dashboard');
    }
  }

  Future<void> _handleGoogleSignup() async {
    try {
      final account = await _googleSignIn.signIn();
      if (account != null) {
        Navigator.pushReplacementNamed(context, '/dashboard');
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Google Sign-Up failed")),
      );
    }
  }

  Future<void> _handleGitHubSignup() async {
    final clientId = dotenv.env['GITHUB_CLIENT_ID'];
    final redirectUri = 'https://nexovate-e26e5.firebaseapp.com/__"/auth/handler'; // Replace this

    final url = Uri.parse(
      'https://github.com/login/oauth/authorize?client_id=$clientId&redirect_uri=$redirectUri&scope=read:user',
    );

    if (await launcher.canLaunchUrl(url)) {
      await launcher.launchUrl(url, mode: launcher.LaunchMode.externalApplication);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Could not launch GitHub sign-up URL")),
      );
    }
  }

  Widget _buildInputField({
    required TextEditingController controller,
    required String hint,
    required IconData icon,
    bool obscure = false,
    VoidCallback? toggleObscure,
    String? Function(String?)? validator,
  }) {
    return FadeInUp(
      duration: const Duration(milliseconds: 700),
      child: TextFormField(
        controller: controller,
        obscureText: obscure,
        validator: validator,
        style: const TextStyle(color: Colors.white),
        decoration: InputDecoration(
          hintText: hint,
          prefixIcon: Icon(icon, color: Colors.white70),
          suffixIcon: toggleObscure != null
              ? IconButton(
                  icon: Icon(
                    obscure ? Icons.visibility_off : Icons.visibility,
                    color: Colors.white70,
                  ),
                  onPressed: toggleObscure,
                )
              : null,
          hintStyle: const TextStyle(color: Colors.white54),
          filled: true,
          fillColor: Colors.white12,
          contentPadding: const EdgeInsets.symmetric(vertical: 16, horizontal: 20),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(20),
            borderSide: BorderSide.none,
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(20),
            borderSide: const BorderSide(color: Colors.orange, width: 1.5),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage(AppImages.bg),
            fit: BoxFit.cover,
          ),
        ),
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 30),
            child: FadeIn(
              duration: const Duration(milliseconds: 800),
              child: Container(
                padding: const EdgeInsets.all(25),
                decoration: BoxDecoration(
                  color: const Color(0x99000000),
                  borderRadius: BorderRadius.circular(30),
                  boxShadow: const [
                    BoxShadow(
                      color: Color(0x66000000),
                      blurRadius: 12,
                      spreadRadius: 3,
                    ),
                  ],
                ),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      FadeInDown(
                        duration: const Duration(milliseconds: 700),
                        child: const Text(
                          'CREATE ACCOUNT',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 30,
                            color: Colors.orange,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      const SizedBox(height: 25),
                      _buildInputField(
                        controller: _fullNameController,
                        hint: "Full Name",
                        icon: Icons.person_outline,
                        validator: (val) => val == null || val.isEmpty
                            ? "Enter your full name"
                            : !RegExp(r"^[a-zA-Z ]+$").hasMatch(val)
                                ? "Only letters allowed"
                                : null,
                      ),
                      const SizedBox(height: 15),
                      _buildInputField(
                        controller: _emailController,
                        hint: "Email Address",
                        icon: Icons.email_outlined,
                        validator: (val) => val == null || val.isEmpty
                            ? "Enter your email"
                            : !RegExp(r"^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$")
                                    .hasMatch(val)
                                ? "Enter a valid email"
                                : null,
                      ),
                      const SizedBox(height: 15),
                      _buildInputField(
                        controller: _passwordController,
                        hint: "Password",
                        icon: Icons.lock_outline,
                        obscure: _obscurePassword,
                        toggleObscure: () => setState(() {
                          _obscurePassword = !_obscurePassword;
                        }),
                        validator: (val) => val == null || val.isEmpty
                            ? "Enter a password"
                            : !RegExp(
                                        r'^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)(?=.*[!@#\$%^&*])[A-Za-z\d!@#\$%^&*]{8,}$')
                                    .hasMatch(val)
                                ? "Password must be 8+ chars with uppercase, lowercase, number & symbol"
                                : null,
                      ),
                      const SizedBox(height: 15),
                      _buildInputField(
                        controller: _confirmPasswordController,
                        hint: "Confirm Password",
                        icon: Icons.lock_outline,
                        obscure: _obscureConfirmPassword,
                        toggleObscure: () => setState(() {
                          _obscureConfirmPassword = !_obscureConfirmPassword;
                        }),
                        validator: (val) =>
                            val != _passwordController.text
                                ? "Passwords don't match"
                                : null,
                      ),
                      const SizedBox(height: 25),
                      FadeInUp(
                        duration: const Duration(milliseconds: 800),
                        child: ElevatedButton.icon(
                          onPressed: _onSignup,
                          icon: const Icon(Icons.login, color: Colors.white),
                          label: const Text(
                            "SIGN UP",
                            style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold),
                          ),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.orange,
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(25),
                            ),
                            elevation: 8,
                          ),
                        ),
                      ),
                      const SizedBox(height: 15),
                      FadeInUp(
                        duration: const Duration(milliseconds: 900),
                        child: ElevatedButton.icon(
                          onPressed: _handleGoogleSignup,
                          icon: const FaIcon(FontAwesomeIcons.google,
                              color: Colors.black),
                          label: const Text("Sign Up with Google", ),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.white,
                            foregroundColor: Colors.black87,
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(25),
                            ),
                            elevation: 5,
                          ),
                        ),
                      ),
                      const SizedBox(height: 15),
                     FadeInUp(
                            duration: const Duration(milliseconds: 1000),
                            child: ElevatedButton.icon(
                              onPressed: _handleGitHubSignup,
                              icon: const FaIcon(
                                FontAwesomeIcons.github,
                                color: Colors.white,
                              ),
                              label: const Text(
                                "Sign Up with GitHub",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w600,
                                  letterSpacing: 0.5,
                                ),
                              ),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.black,
                                foregroundColor: Colors.white,
                                padding: const EdgeInsets.symmetric(vertical: 16),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(25),
                                ),
                                elevation: 6,
                                shadowColor: Colors.black87,
                              ).copyWith(
                                overlayColor: WidgetStateProperty.resolveWith<Color?>(
                                  (states) {
                                    if (states.contains(WidgetState.hovered)) {
                                      return Colors.grey[850];
                                    }
                                    if (states.contains(WidgetState.pressed)) {
                                      return Colors.grey[700];
                                    }
                                    return null;
                                  },
                                ),
                              ),
                            ),
                          ),
                      const SizedBox(height: 20),
                      FadeInUp(
                        duration: const Duration(milliseconds: 1100),
                        child: GestureDetector(
                          onTap: () =>
                              Navigator.pushNamed(context, '/login'),
                          child: const Text.rich(
                            TextSpan(
                              text: "Already have an account? ",
                              style: TextStyle(color: Colors.white70),
                              children: [
                                TextSpan(
                                  text: "Sign in",
                                  style: TextStyle(
                                    color: Colors.orange,
                                    fontWeight: FontWeight.bold,
                                    decoration: TextDecoration.underline,
                                  ),
                                ),
                              ],
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
