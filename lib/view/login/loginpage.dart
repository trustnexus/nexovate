import 'package:admin_demo/view/dashboard/dashboardpage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:fullscreen_window/fullscreen_window.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  // TOGGLES & FOCUS NODE
  bool isScreenFull = false;
  bool isPasswordHidden = true;
  bool isDarkMode = true;
  final FocusNode focusNode = FocusNode();

  // ASSET PATHS
  static const String logoAsset =
      'assets/images/nexovate_transparent_cropped.png';
  static const String ellipseAsset = 'assets/images/ellipse_bg.svg';
  static const String lineAsset = 'assets/images/line_svg.svg';

  @override
  void initState() {
    super.initState();
    setFullScreen();
    focusNode.requestFocus();
  }

  @override
  void dispose() {
    focusNode.dispose();
    super.dispose();
  }

  void toggleFullScreen() {
    isScreenFull = !isScreenFull;
    setFullScreen();
  }

  void setFullScreen() {
    FullScreenWindow.setFullScreen(isScreenFull);
  }

  void toggleDarkMode() {
    setState(() {
      isDarkMode = !isDarkMode;
    });
  }

  void togglePasswordVisibility() {
    setState(() {
      isPasswordHidden = !isPasswordHidden;
    });
  }

  @override
  Widget build(BuildContext context) {
    return RawKeyboardListener(
      focusNode: focusNode,
      autofocus: true,
      onKey: (RawKeyEvent evt) {
        if (evt is RawKeyDownEvent &&
            evt.logicalKey == LogicalKeyboardKey.f11) {
          setState(() {
            toggleFullScreen();
          });
        }
      },
      child: Scaffold(
        body: AnimatedContainer(
          duration: Duration(seconds: 1),
          curve: Curves.easeInOut,
          color: isDarkMode ? Colors.black : Colors.white,
          child: Stack(
            children: [
              Positioned(
                top: 20,
                right: 20,
                child: IconButton(
                  onPressed: toggleDarkMode,
                  icon: Icon(
                    isDarkMode ? Icons.sunny : Icons.nightlight_round_sharp,
                  ),
                  color: isDarkMode ? Colors.white : Colors.black,
                ),
              ),
              Positioned(
                    top: -100,
                    left: -150,
                    child: SvgPicture.asset(
                      ellipseAsset,
                      height: 300,
                      width: 300,
                    ),
                  )
                  .animate(
                    onPlay: (controller) => controller.repeat(reverse: true),
                  )
                  .moveY(
                    begin: 0,
                    end: 15,
                    duration: 2.5.seconds,
                    curve: Curves.easeInOut,
                  ),
              Positioned(
                    bottom: -120,
                    right: -160,
                    child: SvgPicture.asset(
                      ellipseAsset,
                      height: 400,
                      width: 400,
                    ),
                  )
                  .animate(
                    onPlay: (controller) => controller.repeat(reverse: true),
                  )
                  .moveY(
                    begin: 0,
                    end: 20,
                    duration: 2.5.seconds,
                    curve: Curves.easeInOut,
                  ),
              Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image.asset(
                      logoAsset,
                      height: 200,
                      width: 200,
                      fit: BoxFit.fill,
                    ),
                    const SizedBox(height: 20),
                    Container(
                      height: 400,
                      width: 550,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        gradient: LinearGradient(
                          colors:
                              isDarkMode
                                  ? [
                                    Colors.white.withAlpha(102),
                                    Colors.white.withAlpha(78),
                                    Colors.white.withAlpha(52),
                                    Colors.white.withAlpha(25),
                                  ]
                                  : [
                                    Colors.black.withAlpha(102),
                                    Colors.black.withAlpha(78),
                                    Colors.black.withAlpha(52),
                                    Colors.black.withAlpha(25),
                                  ],
                          begin: Alignment.topCenter,
                          end: Alignment.bottomRight,
                        ),
                      ),
                      child: Center(
                        child: Column(
                          children: [
                            const SizedBox(height: 20),
                            Text(
                              'LOGIN AS ADMINISTRATOR',
                              style: TextStyle(
                                fontFamily: 'JejuGothic',
                                color: Colors.white,
                                fontSize: 36,
                                fontWeight: FontWeight.w200,
                              ),
                            ),
                            SvgPicture.asset(lineAsset, height: 5, width: 400)
                                .animate()
                                .scaleX(
                                  begin: 1.0,
                                  end: 4.7,
                                  duration: 0.6.seconds,
                                  curve: Curves.easeIn,
                                )
                                .then()
                                .scaleY(
                                  begin: 1.0,
                                  end: 1.3,
                                  duration: 0.3.seconds,
                                  curve: Curves.easeIn,
                                ),
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 40,
                                vertical: 30,
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'EMAIL',
                                    style: GoogleFonts.plusJakartaSans(
                                      color:
                                          isDarkMode
                                              ? Color(0xFFCDCDCD)
                                              : Color(0xFF000000),
                                      fontSize: 16,
                                    ),
                                  ),
                                  const SizedBox(height: 5),
                                  TextField(
                                    style: GoogleFonts.plusJakartaSans(
                                      color:
                                          isDarkMode
                                              ? Colors.white
                                              : Colors.black,
                                    ),
                                    cursorColor: Color(0xFFE20C75),
                                    decoration: InputDecoration(
                                      contentPadding: EdgeInsets.symmetric(
                                        vertical: 12,
                                        horizontal: 16,
                                      ),
                                      enabledBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(8),
                                        borderSide: BorderSide(
                                          color:
                                              isDarkMode
                                                  ? Color(0xFFCDCDCD)
                                                  : Color(0xFF696969),
                                        ),
                                      ),
                                      focusedBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(8),
                                        borderSide: BorderSide(
                                          color:
                                              isDarkMode
                                                  ? Color(0xFFCDCDCD)
                                                  : Color(0xFF696969),
                                          width: 2,
                                        ),
                                      ),
                                      hintText: "ENTER YOUR EMAIL",
                                      hintStyle: GoogleFonts.plusJakartaSans(
                                        color:
                                            isDarkMode
                                                ? Color(0xFF8E8E8E)
                                                : Color(0xFF695858),
                                      ),
                                      prefixIcon: Icon(
                                        Icons.email_outlined,
                                        color:
                                            isDarkMode
                                                ? Color(0xFF8E8E8E)
                                                : Color(0xFF695858),
                                      ),
                                    ),
                                  ),
                                  const SizedBox(height: 10),
                                  Text(
                                    'PASSWORD',
                                    style: GoogleFonts.plusJakartaSans(
                                      color:
                                          isDarkMode
                                              ? Color(0xFFCDCDCD)
                                              : Color(0xFF000000),
                                      fontSize: 16,
                                    ),
                                  ),
                                  const SizedBox(height: 5),
                                  TextField(
                                    style: GoogleFonts.plusJakartaSans(
                                      color:
                                          isDarkMode
                                              ? Colors.white
                                              : Colors.black,
                                    ),
                                    obscureText: isPasswordHidden,
                                    cursorColor: Color(0xFFE20C75),
                                    decoration: InputDecoration(
                                      contentPadding: EdgeInsets.symmetric(
                                        vertical: 12,
                                        horizontal: 16,
                                      ),
                                      enabledBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(8),
                                        borderSide: BorderSide(
                                          color:
                                              isDarkMode
                                                  ? Color(0xFFCDCDCD)
                                                  : Color(0xFF696969),
                                        ),
                                      ),
                                      focusedBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(8),
                                        borderSide: BorderSide(
                                          color:
                                              isDarkMode
                                                  ? Color(0xFFCDCDCD)
                                                  : Color(0xFF696969),
                                          width: 2,
                                        ),
                                      ),
                                      hintText: 'ENTER YOUR PASSWORD',
                                      hintStyle: GoogleFonts.plusJakartaSans(
                                        color:
                                            isDarkMode
                                                ? Color(0xFF8E8E8E)
                                                : Color(0xFF695858),
                                      ),
                                      prefixIcon: Icon(
                                        Icons.lock,
                                        color:
                                            isDarkMode
                                                ? Color(0xFFCDCDCD)
                                                : Color(0xFF696969),
                                      ),
                                      suffixIcon: IconButton(
                                        onPressed: togglePasswordVisibility,
                                        color:
                                            isDarkMode
                                                ? Color(0xFFCDCDCD)
                                                : Color(0xFF696969),
                                        icon: Icon(
                                          isPasswordHidden
                                              ? Icons.visibility
                                              : Icons.visibility_off,
                                        ),
                                      ),
                                    ),
                                  ),
                                  const SizedBox(height: 30),
                                  ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                      padding: EdgeInsets.symmetric(
                                        horizontal: 1,
                                      ),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                      backgroundColor: Colors.transparent,
                                      shadowColor: Colors.transparent,
                                    ),
                                    onPressed: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) => DashboardPage(),
                                        ),
                                      );
                                    },
                                    child: Ink(
                                      decoration: BoxDecoration(
                                        gradient: LinearGradient(
                                          colors: [
                                            Color(0xFFFFB608),
                                            Color(0xFFFF2553),
                                          ],
                                          begin: Alignment.topLeft,
                                          end: Alignment.bottomRight,
                                        ),
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                      child: Container(
                                        alignment: Alignment.center,
                                        constraints: BoxConstraints(
                                          minWidth: 200,
                                          minHeight: 50,
                                        ),
                                        child: Text(
                                          "LOGIN",
                                          style: GoogleFonts.plusJakartaSans(
                                            color: Colors.white,
                                            fontSize: 18,
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
