import 'package:flutter/material.dart';
import 'package:animate_do/animate_do.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:url_launcher/url_launcher.dart' as launcher;

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class AppImages {
  static const bg = 'assets/images/background.png';
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  bool _showPassword = false;

  final GoogleSignIn _googleSignIn = GoogleSignIn(
    clientId: dotenv.env['GOOGLE_CLIENT_ID'],
  );

  void _onLogin() {
    if (_formKey.currentState!.validate()) {
      if (_emailController.text == "test@nexovate.com" &&
          _passwordController.text == "123456") {
        Navigator.pushReplacementNamed(context, '/dashboard');
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Invalid email or password!")),
        );
      }
    }
  }

  Future<void> _handleGoogleLogin() async {
    try {
      final account = await _googleSignIn.signIn();
      if (account != null) {
        Navigator.pushReplacementNamed(context, '/dashboard');
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Google Sign-In failed")),
      );
    }
  }

  Future<void> _handleGitHubLogin() async {
    final clientId = dotenv.env['GITHUB_CLIENT_ID'];
    final redirectUri = 'https://nexovate-e26e5.firebaseapp.com/__/auth/handler';

    final url = Uri.parse(
      'https://github.com/login/oauth/authorize?client_id=$clientId&redirect_uri=$redirectUri&scope=read:user',
    );

    if (await launcher.canLaunchUrl(url)) {
      await launcher.launchUrl(
        url,
        mode: launcher.LaunchMode.externalApplication,
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Could not launch GitHub login URL")),
      );
    }
  }

  Widget _buildInputField({
    required TextEditingController controller,
    required String hint,
    required IconData icon,
    bool obscure = false,
    bool toggleVisible = false,
    String? Function(String?)? validator,
  }) {
    return FadeInUp(
      duration: const Duration(milliseconds: 600),
      child: TextFormField(
        controller: controller,
        obscureText: obscure && !_showPassword,
        validator: validator,
        style: const TextStyle(color: Colors.white),
        decoration: InputDecoration(
          hintText: hint,
          prefixIcon: Icon(icon, color: Colors.white70),
          suffixIcon: toggleVisible
              ? IconButton(
                  icon: Icon(
                    _showPassword ? Icons.visibility_off : Icons.visibility,
                    color: Colors.white54,
                  ),
                  onPressed: () {
                    setState(() {
                      _showPassword = !_showPassword;
                    });
                  },
                )
              : null,
          hintStyle: const TextStyle(color: Colors.white54),
          filled: true,
          fillColor: Colors.white12,
          contentPadding:
              const EdgeInsets.symmetric(vertical: 16, horizontal: 20),
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

  Widget _buildSocialButton({
    required VoidCallback onPressed,
    required Color color,
    required Color textColor,
    required Widget icon,
    required String label,
  }) {
    return FadeInUp(
      duration: const Duration(milliseconds: 800),
      child: ElevatedButton.icon(
        onPressed: onPressed,
        icon: icon,
        label: Text(label),
        style: ElevatedButton.styleFrom(
          backgroundColor: color,
          foregroundColor: textColor,
          padding: const EdgeInsets.symmetric(vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(25),
          ),
          elevation: 5,
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
        child: Container(
          color: Colors.black.withOpacity(0.3),
          child: Center(
            child: SingleChildScrollView(
              padding:
                  const EdgeInsets.symmetric(horizontal: 25, vertical: 30),
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
                            'SIGN IN',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 32,
                              color: Colors.orange,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        const SizedBox(height: 20),
                        _buildInputField(
                          controller: _emailController,
                          hint: "Email",
                          icon: Icons.email_outlined,
                          validator: (val) {
                                            if (val == null || val.isEmpty) return "Enter your email";
                                                final regex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
                                            if (!regex.hasMatch(val)) return "Enter a valid email";
                                                return null;
                                            },
                                         ),
                        const SizedBox(height: 20),
                        _buildInputField(
                          controller: _passwordController,
                          hint: "Password",
                          icon: Icons.lock_outline,
                          obscure: true,
                          toggleVisible: true,
                          validator: (val) {
                            if (val == null || val.isEmpty) return "Enter Your Password";
                            if (val.length < 6) return "Password must be at least 6 characters long";
                          return null;
                          }
                        ),
                        const SizedBox(height: 10),
                        Align(
                              alignment: Alignment.centerRight,
                              child: TextButton(
                                onPressed: () => Navigator.pushNamed(context, '/password'),
                                child: const Text(
                                  "Forgot Password?",
                                  style: TextStyle(color: Colors.orangeAccent),
                                ),
                              ),
                            ),
                        const SizedBox(height: 10),
                        FadeInUp(
                          duration: const Duration(milliseconds: 800),
                          child: ElevatedButton.icon(
                            onPressed: _onLogin,
                            icon: const Icon(Icons.login, color: Colors.white),
                            label: const Text("Log In",   style: TextStyle(    color: Colors.white,  fontSize: 16,  ),),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.orange,
                              padding:
                                  const EdgeInsets.symmetric(vertical: 16),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(25),
                              ),
                              elevation: 8,
                            ),
                          ),
                        ),
                        const SizedBox(height: 20),
                        _buildSocialButton(
                          onPressed: _handleGoogleLogin,
                          color: Colors.white,
                          textColor: Colors.black87,
                          icon: const FaIcon(FontAwesomeIcons.google),
                          label: "Continue with Google",
                        ),
                        const SizedBox(height: 15),
                        _buildSocialButton(
                          onPressed: _handleGitHubLogin,
                          color: Colors.black,
                          textColor: Colors.white,
                          icon: const FaIcon(FontAwesomeIcons.github),
                          label: "Continue with GitHub",
                        ),
                        const SizedBox(height: 25),
                        FadeInUp(
                          duration: const Duration(milliseconds: 1100),
                          child: GestureDetector(
                            onTap: () =>
                                Navigator.pushNamed(context, '/signup'),
                            child: const Text.rich(
                              TextSpan(
                                text: "Don't have an account? ",
                                style: TextStyle(color: Colors.white70),
                                children: [
                                  TextSpan(
                                    text: "Sign Up",
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
      ),
    );
  }
}
