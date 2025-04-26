import 'package:flutter/material.dart';
import 'package:animate_do/animate_do.dart';
import 'package:nexovate/src/screens/utils/sidebar_navigation.dart'; // Import the SidebarNavigation widget

class AppImages {
  static const search = 'assets/images/search.png';
  static const logo = 'assets/images/N_log.png';
  static const avatar = 'assets/images/av.png';
}

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: Colors.black,
      // Use SidebarNavigation here for the drawer
      drawer: const SidebarNavigation(), // SidebarNavigation is now used here
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.menu, color: Colors.white),
          onPressed: () => _scaffoldKey.currentState?.openDrawer(),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16.0),
            child: Image.asset(
              AppImages.logo,
              height: 40,
              fit: BoxFit.contain,
            ),
          )
        ],
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ZoomIn(
              duration: const Duration(milliseconds: 800),
              child: Container(
                padding: const EdgeInsets.all(25),
                child: ClipOval(
                  child: Image.asset(
                    AppImages.search,
                    width: 200,
                    height: 200,
                    fit: BoxFit.contain,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 25),
            FadeInDown(
              duration: const Duration(milliseconds: 600),
              child: const Text(
                "Find Your Project",
                style: TextStyle(
                  fontFamily: 'Poppins',
                  fontSize: 24,
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                ),
              ),
            ),
            const SizedBox(height: 12),
            FadeInDown(
              delay: const Duration(milliseconds: 200),
              child: const Text(
                "Answer questions to find your project!",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontFamily: 'Poppins',
                  fontSize: 16,
                  color: Colors.white70,
                ),
              ),
            ),
            const SizedBox(height: 40),
            SlideInUp(
              duration: const Duration(milliseconds: 800),
              child: MouseRegion(
                cursor: SystemMouseCursors.click,
                child: GestureDetector(
                  onTap: () => Navigator.pushNamed(context, '/start_project'),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    width: 180,
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
                          color: const Color(0x99FFA500),
                          blurRadius: 10,
                          offset: const Offset(0, 5),
                        ),
                      ],
                    ),
                    child: const Center(
                      child: Text(
                        "Start",
                        style: TextStyle(
                          fontFamily: 'Poppins',
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ),
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
