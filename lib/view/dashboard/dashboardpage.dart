import 'package:admin_demo/view/dashboard/questionspage.dart';
import 'package:admin_demo/view/dashboard/userspage.dart';
import 'package:admin_demo/view/dashboard/designspage.dart';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import 'package:admin_demo/viewmodel/notifiers/thememode.dart';
import 'package:admin_demo/view/login/loginpage.dart';

class DashboardPage extends StatefulWidget {
  @override
  _DashboardPageState createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  int _selectedIndex = 0;
  final double itemHeight = 60;
  bool _isExpanded = true;

  @override
  Widget build(BuildContext context) {
    return Consumer<ThemeModeProvider>(
      builder: (context, themeProvider, child) {
        final isDarkMode = themeProvider.isDarkMode;

        return Scaffold(
          backgroundColor: isDarkMode ? Colors.black : Colors.grey[100],
          body: Row(
            children: [
              // sidebar
              AnimatedContainer(
                duration: Duration(milliseconds: 200),
                width: _isExpanded ? 250 : 64,
                color: isDarkMode ? Colors.grey[900] : Colors.grey[300],
                child: Stack(
                  children: [
                    //highlighted bar beneath selected item
                    AnimatedPositioned(
                      duration: Duration(milliseconds: 100),
                      top: 60 + (_selectedIndex * itemHeight),
                      left: 0,
                      right: 0,
                      child: Container(
                        height: itemHeight,
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [
                              Color(0xffFFB608),
                              Color(0xffFF2553),
                              Color(0xE1E3224A),
                              Color(0x000C0B08),
                            ],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ),
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                    ),
                    // theme toggle
                    Positioned(
                      bottom: 20,
                      left: 0,
                      right: 0,
                      child: Center(
                        child: IconButton(
                          icon: Icon(
                            isDarkMode ? Icons.wb_sunny : Icons.dark_mode,
                            color: isDarkMode ? Colors.white : Colors.black,
                            size: 28,
                          ),
                          onPressed: () {
                            final themeProvider =
                                Provider.of<ThemeModeProvider>(
                                  context,
                                  listen: false,
                                );
                            themeProvider.toggleTheme();
                          },
                          tooltip:
                              isDarkMode
                                  ? 'Switch to Light Mode'
                                  : 'Switch to Dark Mode',
                        ),
                      ),
                    ),

                    // sidebar content
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: EdgeInsets.all(10),
                          child: IconButton(
                            icon: Icon(
                              _isExpanded
                                  ? Icons.arrow_back_ios
                                  : Icons.arrow_forward_ios,
                              color: isDarkMode ? Colors.white : Colors.black,
                            ),
                            onPressed: () {
                              setState(() {
                                _isExpanded = !_isExpanded;
                              });
                            },
                          ),
                        ),
                        ...List.generate(navItems.length, (index) {
                          return _buildNavItem(
                            index,
                            navItems[index],
                            isDarkMode,
                          );
                        }),
                      ],
                    ),
                  ],
                ),
              ),

              // main content
              Expanded(child: navFragments[_selectedIndex]),
            ],
          ),
        );
      },
    );
  }

  Widget _buildNavItem(int index, String label, bool isDarkMode) {
    return InkWell(
      onTap: () async {
        if (label == "Logout") {
          final shouldLogout = await showDialog<bool>(
            context: context,
            builder: (context) {
              return Dialog(
                backgroundColor: isDarkMode ? Colors.black : Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(24.0),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.logout, size: 48, color: Color(0xFFFF2553)),
                      SizedBox(height: 16),
                      Text(
                        "Are you sure you want to logout?",
                        style: GoogleFonts.plusJakartaSans(
                          color: isDarkMode ? Colors.white : Colors.black,
                          fontSize: 20,
                          fontWeight: FontWeight.w600,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      SizedBox(height: 24),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          TextButton(
                            onPressed: () => Navigator.pop(context, false),
                            child: Text(
                              "CANCEL",
                              style: GoogleFonts.plusJakartaSans(
                                color:

                                    isDarkMode
                                        ? Colors.white70
                                        : Colors.black54,
                                fontWeight: FontWeight.w500,
                                fontSize: 20,
                              ),
                            ),
                          ),
                          ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              padding: EdgeInsets.symmetric(
                                horizontal: 24,
                                vertical: 12,
                              ),
                              backgroundColor: Colors.transparent,
                              shadowColor: Colors.transparent,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                            onPressed: () => Navigator.pop(context, true),
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
                                child: Text(
                                  "LOGOUT",
                                  style: GoogleFonts.plusJakartaSans(
                                    color: Colors.white,
                                    fontWeight: FontWeight.w600,
                                    fontSize: 20,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              );
            },
          );
          if (shouldLogout == true) {
            Navigator.of(context).pushAndRemoveUntil(
              MaterialPageRoute(builder: (_) => LoginPage()),
              (route) => false,
            );
          }
        } else {
          setState(() {
            _selectedIndex = index;
          });
        }
      },
      child: Container(
        height: itemHeight,
        padding: EdgeInsets.symmetric(horizontal: 20),
        alignment: Alignment.centerLeft,
        child: Row(
          children: [
            Icon(
              navIcons[index],
              color: isDarkMode ? Colors.white : Colors.black,
            ),
            if (_isExpanded) ...[
              SizedBox(width: 10),
              Text(
                label,
                style: GoogleFonts.plusJakartaSans(
                  color: isDarkMode ? Colors.white : Colors.black,
                  fontSize: 18,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  List<String> navItems = [
    "Users",
    "Questions",
    "UI Designs",
    "Projects",
    "Settings",
    "Logout",
  ];
  List<IconData> navIcons = [
    Icons.person,
    Icons.question_mark,
    Icons.design_services,
    Icons.work,
    Icons.settings,
    Icons.logout,
  ];
  List<Widget> navFragments = [
    UsersPage(), // users
    QuestionsPage(), // questions
    DesignsPage(), // designs
    Container(), // projects
    Container(), // settings
    Container(), // logout
  ];
}
