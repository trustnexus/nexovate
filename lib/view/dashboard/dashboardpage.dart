import 'package:admin_demo/view/dashboard/questionspage.dart';
import 'package:admin_demo/view/dashboard/userpage.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

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
    return Scaffold(
      body: Row(
        children: [
          // sidebar
          AnimatedContainer(
            duration: Duration(milliseconds: 300),
            width: _isExpanded ? 250 : 64,
            color: Colors.grey[900],
            child: Stack(
              children: [
                AnimatedPositioned(
                  duration: Duration(milliseconds: 300),
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

                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // expander button
                    Padding(
                      padding: EdgeInsets.all(10),
                      child: IconButton(
                        icon: Icon(
                          _isExpanded
                              ? Icons.arrow_back_ios
                              : Icons.arrow_forward_ios,
                          color: Colors.white,
                        ),
                        onPressed: () {
                          setState(() {
                            _isExpanded = !_isExpanded;
                          });
                        },
                      ),
                    ),

                    // list
                    ...List.generate(navItems.length, (index) {
                      return _buildNavItem(index, navItems[index]);
                    }),
                  ],
                ),
              ],
            ),
          ),

          // main content (will be changed with fragment widgets)
          Expanded(child: navFragments[_selectedIndex]),
        ],
      ),
    );
  }

  // navigation item builder
  Widget _buildNavItem(int index, String label) {
    return InkWell(
      onTap: () {
        setState(() {
          _selectedIndex = index;
        });
      },
      child: Container(
        height: itemHeight,
        padding: EdgeInsets.symmetric(horizontal: 20),
        alignment: Alignment.centerLeft,
        child: Row(
          children: [
            Icon(navIcons[index], color: Colors.white),
            if (_isExpanded) ...[
              SizedBox(width: 10),
              Text(
                label,
                style: GoogleFonts.plusJakartaSans(
                  color: Colors.white,
                  fontSize: 18,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

// navigation items
List<String> navItems = ["Users", "Questions", "Settings", "Logout"];
List<IconData> navIcons = [
  Icons.person,
  Icons.question_mark,
  Icons.settings,
  Icons.logout,
];
List<Widget> navFragments = [
  UsersPage(),
  QuestionsPage(),
  Container(),
  Container(),
];
