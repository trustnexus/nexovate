import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:animate_do/animate_do.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:url_launcher/url_launcher.dart' as launcher;

class EnhancedAuthScreen extends StatefulWidget {
  const EnhancedAuthScreen({super.key});

  @override
  State<EnhancedAuthScreen> createState() => _EnhancedAuthScreenState();
  
}

class _EnhancedAuthScreenState extends State<EnhancedAuthScreen> with SingleTickerProviderStateMixin {
  final _loginFormKey = GlobalKey<FormState>();
  final _signupFormKey = GlobalKey<FormState>();
  late TabController _tabController;

  final _emailLoginController = TextEditingController();
  final _passwordLoginController = TextEditingController();
  final _fullNameSignupController = TextEditingController();
  final _emailSignupController = TextEditingController();
  final _passwordSignupController = TextEditingController();
  final _confirmPasswordSignupController = TextEditingController();

  bool _showPasswordLogin = false;
  bool _obscurePasswordSignup = true;
  bool _obscureConfirmSignup = true;

  final GoogleSignIn _googleSignIn = GoogleSignIn(clientId: dotenv.env['GOOGLE_CLIENT_ID']);

  @override
  void initState() {
  _tabController = TabController(length: 2, vsync: this);


  super.initState();
  }

  Future<void> _handleGoogleLogin() async {
  try {
    // Optional: show loading indicator
    setState(() => _isLoading = true);

    final account = await _googleSignIn.signIn();

    setState(() => _isLoading = false);

    if (account != null) {
      // Navigate to dashboard
      Navigator.pushReplacementNamed(context, '/dashboard');
    } else {
      // User canceled the login
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Google Sign-In was cancelled")),
      );
    }
  } catch (e) {
    setState(() => _isLoading = false);
    debugPrint("Google Sign-In error: $e");
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Google Sign-In failed. Please try again.")),
    );
  }
}

  Future<void> _handleGitHubLogin() async {
  final clientId = dotenv.env['GITHUB_CLIENT_ID'];
  final redirectUri = 'https://nexovate-e26e5.firebaseapp.com/__/auth/handler';

  if (clientId == null || clientId.isEmpty) {
    debugPrint("GitHub Client ID is not set.");
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("GitHub login configuration error")),
    );
    return;
  }

  final url = Uri.parse(
    'https://github.com/login/oauth/authorize'
    '?client_id=$clientId'
    '&redirect_uri=$redirectUri'
    '&scope=read:user',
  );

  try {
    final canLaunch = await launcher.canLaunchUrl(url);
    if (canLaunch) {
      await launcher.launchUrl(
        url,
        mode: launcher.LaunchMode.externalApplication,
      );
    } else {
      throw Exception("Cannot launch GitHub login URL");
    }
  } catch (e) {
    debugPrint("GitHub login error: $e");
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("GitHub login failed. Please try again.")),
    );
  }
}


  Widget _buildTextInput({
    required TextEditingController controller,
    required String hint,
    required IconData icon,
    bool obscure = false,
    VoidCallback? toggleObscure,
    String? Function(String?)? validator,
  }) {
    return TextFormField(
      controller: controller,
      obscureText: obscure,
      validator: validator,
      style: const TextStyle(color: Colors.white),
      decoration: InputDecoration(
        hintText: hint,
        prefixIcon: Icon(icon, color: Colors.white70),
        suffixIcon: toggleObscure != null
            ? IconButton(
                icon: Icon(obscure ? Icons.visibility_off : Icons.visibility, color: Colors.white54),
                onPressed: toggleObscure,
              )
            : null,
        hintStyle: const TextStyle(color: Colors.white54),
        filled: true,
        fillColor: Colors.white.withOpacity(0.1),
        contentPadding: const EdgeInsets.symmetric(vertical: 14, horizontal: 18),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(20), borderSide: BorderSide.none),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(20),
          borderSide: const BorderSide(color: Colors.orange, width: 1.5),
        ),
      ),
    );
  }

  Widget _buildGradientButton({
    required String label,
    required Icon icon,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(vertical: 10),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(25),
          gradient: const LinearGradient(
            colors: [Color.fromARGB(255, 255, 164, 28), Color.fromARGB(255, 255, 14, 74)],
          ),
        ),
        child: Container(
          alignment: Alignment.center,
          padding: const EdgeInsets.symmetric(horizontal: 10),
          margin: const EdgeInsets.all(1),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(25),
            color: Colors.transparent,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              icon,
              const SizedBox(width: 10),
              Text(
                label,
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 0.5,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

Widget _buildSocialButton({
  required String label,
  required Widget icon,
  required Color bgColor,
  required Color textColor,
  required VoidCallback onPressed,
}) {
  return SizedBox(
    width: double.infinity,
    height: 52,
    child: ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: bgColor,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(30),
        ),
        elevation: 2,
        padding: EdgeInsets.zero,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Icon aligned left with spacing
          Padding(
            padding: const EdgeInsets.only(right: 12),
            child: icon,
          ),
          // Center-aligned text
          Text(
            label,
            style: TextStyle(
              color: textColor,
              fontWeight: FontWeight.bold,
              fontSize: 15,
            ),
          ),
        ],
      ),
    ),
  );
}

bool _isLoading = false;
bool _rememberMe = false;

  Widget _buildLoginForm() {
  return Form(
    key: _loginFormKey,
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const SizedBox(height: 20),

        // Email Field with Label
        FadeInUp(
          duration: const Duration(milliseconds: 400),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text("Email", style: TextStyle(color: Colors.white70, fontSize: 13)),
              const SizedBox(height: 6),
              AnimatedContainer(
                duration: const Duration(milliseconds: 300),
                child: _buildTextInput(
                  controller: _emailLoginController,
                  hint: "Enter your email",
                  icon: Icons.email_outlined,
                  validator: (val) {
                    if (val == null || val.isEmpty) return "Enter your email";
                    final regex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
                    if (!regex.hasMatch(val)) return "Enter a valid email";
                    return null;
                  },
                ),
              ),
            ],
          ),
        ),

        const SizedBox(height: 15),

        // Password Field with Label
        FadeInUp(
          duration: const Duration(milliseconds: 500),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text("Password", style: TextStyle(color: Colors.white70, fontSize: 13)),
              const SizedBox(height: 6),
              AnimatedContainer(
                duration: const Duration(milliseconds: 300),
                child: _buildTextInput(
                  controller: _passwordLoginController,
                  hint: "Enter your password",
                  icon: Icons.lock_outline,
                  obscure: !_showPasswordLogin,
                  toggleObscure: () => setState(() => _showPasswordLogin = !_showPasswordLogin),
                  validator: (val) => val == null || val.length < 6 ? "Min 6 characters" : null,
                ),
              ),
            ],
          ),
        ),

        const SizedBox(height: 15),

        // Remember Me
        FadeInUp(
                duration: const Duration(milliseconds: 600),
                child: Row(
                  children: [
                    Checkbox(
                      value: _rememberMe,
                      onChanged: (val) => setState(() => _rememberMe = val ?? false),
                      activeColor: Colors.orange,
                    ),
                    const Text("Remember me", style: TextStyle(color: Colors.white70)),
                  ],
                ),
              ),
        const SizedBox(height: 40),
        // Sign In with loading
        FadeInUp(
          duration: const Duration(milliseconds: 700),
          child: _isLoading
              ? const Center(child: CircularProgressIndicator(color: Colors.white))
              : _buildGradientButton(
                  label: "SIGN IN",
                  icon: const Icon(Icons.login, color: Colors.white),
                  onTap: () async {
                    if (_loginFormKey.currentState!.validate()) {
                      setState(() => _isLoading = true);
                      await Future.delayed(const Duration(seconds: 1));

                      final email = _emailLoginController.text.trim();
                      final password = _passwordLoginController.text;

                      setState(() => _isLoading = false);

                      if (email == 'test@nexovate.com' && password == '123456') {
                        Navigator.pushReplacementNamed(context, '/dashboard');
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text("Invalid email or password")),
                        );
                      }
                    }
                  },
                ),
        ),

        const SizedBox(height: 10),

        // Google Button
        FadeInUp(
          duration: const Duration(milliseconds: 800),
          child: _buildSocialButton(
            label: "Continue with Google",
            icon: const FaIcon(FontAwesomeIcons.google, size: 18, color: Colors.black),
            bgColor: Colors.white,
            textColor: Colors.black87,
            onPressed: _handleGoogleLogin,
          ),
        ),

        const SizedBox(height: 10),

        // GitHub Button
        FadeInUp(
          duration: const Duration(milliseconds: 900),
          child: _buildSocialButton(
            label: "Continue with GitHub",
            icon: const FaIcon(FontAwesomeIcons.github, size: 18, color: Colors.white),
            bgColor: Colors.black,
            textColor: Colors.white,
            onPressed: _handleGitHubLogin,
          ),
        ),
      ],
    ),
  );
}

 Widget _buildSignupForm() {
  return Form(
    key: _signupFormKey,
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const SizedBox(height: 20),

        // Full Name
        FadeInUp(
          duration: const Duration(milliseconds: 400),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text("Full Name", style: TextStyle(color: Colors.white70, fontSize: 13)),
              const SizedBox(height: 6),
              _buildTextInput(
                controller: _fullNameSignupController,
                hint: "Enter your full name",
                icon: Icons.person_outline,
                validator: (val) => val == null || val.isEmpty ? "Enter name" : null,
              ),
            ],
          ),
        ),

        const SizedBox(height: 15),

        // Email
        FadeInUp(
          duration: const Duration(milliseconds: 500),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text("Email", style: TextStyle(color: Colors.white70, fontSize: 13)),
              const SizedBox(height: 6),
              _buildTextInput(
                controller: _emailSignupController,
                hint: "Enter your email",
                icon: Icons.email_outlined,
                validator: (val) => val == null || val.isEmpty ? "Enter email" : null,
              ),
            ],
          ),
        ),

        const SizedBox(height: 15),

        // Password
        FadeInUp(
          duration: const Duration(milliseconds: 600),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text("Password", style: TextStyle(color: Colors.white70, fontSize: 13)),
              const SizedBox(height: 6),
              _buildTextInput(
                controller: _passwordSignupController,
                hint: "Enter password",
                icon: Icons.lock_outline,
                obscure: _obscurePasswordSignup,
                toggleObscure: () => setState(() => _obscurePasswordSignup = !_obscurePasswordSignup),
                validator: (val) => val == null || val.length < 6 ? "Min 6 characters" : null,
              ),
            ],
          ),
        ),

        const SizedBox(height: 15),

        // Confirm Password
        FadeInUp(
          duration: const Duration(milliseconds: 700),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text("Confirm Password", style: TextStyle(color: Colors.white70, fontSize: 13)),
              const SizedBox(height: 6),
              _buildTextInput(
                controller: _confirmPasswordSignupController,
                hint: "Re-enter password",
                icon: Icons.lock_outline,
                obscure: _obscureConfirmSignup,
                toggleObscure: () => setState(() => _obscureConfirmSignup = !_obscureConfirmSignup),
                validator: (val) => val != _passwordSignupController.text ? "Passwords don't match" : null,
              ),
            ],
          ),
        ),

        const SizedBox(height: 20),

        // Sign Up Button
        FadeInUp(
          duration: const Duration(milliseconds: 800),
          child: _buildGradientButton(
            label: "SIGN UP",
            icon: const Icon(Icons.person_add, color: Colors.white),
            onTap: () {
              if (_signupFormKey.currentState!.validate()) {
                Navigator.pushReplacementNamed(context, '/dashboard');
              }
            },
          ),
        ),

        const SizedBox(height: 10),

        // Google Sign Up
        FadeInUp(
          duration: const Duration(milliseconds: 900),
          child: _buildSocialButton(
            label: "Sign up with Google",
            icon: const FaIcon(FontAwesomeIcons.google, color: Colors.black),
            bgColor: Colors.white,
            textColor: Colors.black87,
            onPressed: _handleGoogleLogin,
          ),
        ),

        const SizedBox(height: 12),

        // GitHub Sign Up
        FadeInUp(
          duration: const Duration(milliseconds: 1000),
          child: _buildSocialButton(
            label: "Sign up with GitHub",
            icon: const FaIcon(FontAwesomeIcons.github, color: Colors.white),
            bgColor: Colors.black,
            textColor: Colors.white,
            onPressed: _handleGitHubLogin,
          ),
        ),

        const SizedBox(height: 20),
      ],
    ),
  );
}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage("assets/images/background.png"),
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
                  color: Colors.white.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(30),
                  border: Border.all(color: Colors.white.withOpacity(0.2)),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.4),
                      blurRadius: 20,
                      spreadRadius: 3,
                    ),
                  ],
                ),
                child: BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                     Container(
                              decoration: BoxDecoration(
                                color: Colors.white.withOpacity(0.05),
                                borderRadius: BorderRadius.circular(30),
                              ),
                              child: TabBar(
                                controller: _tabController,
                                labelColor: Colors.white,
                                unselectedLabelColor: Colors.white54,
                                labelStyle: const TextStyle(
                                  fontWeight: FontWeight.w600,
                                  fontSize: 16,
                                ),
                                indicator: GradientUnderlineTabIndicator(
                                  gradient: const LinearGradient(
                                    colors: [
                                      Color(0xFFFFA726),
                                      Color(0xFFFF1744),
                                    ],
                                  ),
                                  strokeWidth: 4,
                                ),
                                tabs: const [
                                  Tab(text: 'SIGN IN'),
                                  Tab(text: 'SIGN UP'),
                                ],
                              ),
                            ),
                      const SizedBox(height: 20),
                      SizedBox(
                        height: 580,
                        child: TabBarView(
                          controller: _tabController,
                          children: [
                            SingleChildScrollView(child: _buildLoginForm()),
                            SingleChildScrollView(child: _buildSignupForm()),
                          ],
                        )
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

class GradientUnderlineTabIndicator extends Decoration {
  final LinearGradient gradient;
  final double strokeWidth;

  const GradientUnderlineTabIndicator({
    required this.gradient,
    this.strokeWidth = 3.0,
  });

  @override
  BoxPainter createBoxPainter([VoidCallback? onChanged]) {
    return _GradientUnderlinePainter(gradient, strokeWidth);
  }
}

class _GradientUnderlinePainter extends BoxPainter {
  final LinearGradient gradient;
  final double strokeWidth;

  _GradientUnderlinePainter(this.gradient, this.strokeWidth);

  @override
  void paint(Canvas canvas, Offset offset, ImageConfiguration config) {
    final Paint paint = Paint()
      ..shader = gradient.createShader(
        Rect.fromLTWH(offset.dx, offset.dy, config.size!.width, strokeWidth),
      )
      ..strokeWidth = strokeWidth
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    final double y = offset.dy + config.size!.height - strokeWidth / 2;
    canvas.drawLine(
      Offset(offset.dx, y),
      Offset(offset.dx + config.size!.width, y),
      paint,
    );
  }
}

