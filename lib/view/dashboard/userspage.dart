import 'package:flutter/material.dart';
import 'package:admin_demo/utils/textstyles.dart';
import 'package:admin_demo/viewmodel/notifiers/thememode.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class UsersPage extends StatefulWidget {
  const UsersPage({super.key});

  @override
  State<UsersPage> createState() => _UsersPageState();
}

class _UsersPageState extends State<UsersPage> {
  //theme mode provider

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        children: [
          //CONTAINER FOR SEARCHING USER
          Consumer<ThemeModeProvider>(
            builder: (context, provider, child) {
              return Container(
                width: MediaQuery.of(context).size.width,
                height: 300,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  gradient: LinearGradient(
                    colors:
                        provider.isDarkMode
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
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                ),
                margin: EdgeInsets.all(30.0),
                child: Container(
                  padding: EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Consumer<ThemeModeProvider>(
                        builder: (context, value, child) {
                          return Padding(
                            padding: const EdgeInsets.only(left: 150),
                            child: Text(
                              "SEARCH USERS",
                              style:
                                  value.isDarkMode
                                      ? whiteHeading1
                                      : GoogleFonts.plusJakartaSans(
                                        color: Colors.black,
                                        fontSize: 20,
                                        fontWeight: FontWeight.w600,
                                      ),
                            ),
                          );
                        },
                      ),
                      Container(
                        margin: EdgeInsets.symmetric(
                          horizontal: 150,
                          vertical: 20,
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Flexible(
                              flex: 1,
                              child: TextField(
                                style: GoogleFonts.plusJakartaSans(
                                  color:
                                      provider.isDarkMode ? Colors.white : Colors.black,
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
                                          provider.isDarkMode
                                              ? Color(0xFFCDCDCD)
                                              : Color(0xFF696969),
                                    ),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(8),
                                    borderSide: BorderSide(
                                      color:
                                          provider.isDarkMode
                                              ? Color(0xFFCDCDCD)
                                              : Color(0xFF696969),
                                      width: 2,
                                    ),
                                  ),
                                  hintText: "SEARCH BY ID",
                                  hintStyle: GoogleFonts.plusJakartaSans(
                                    color:
                                        provider.isDarkMode
                                            ? Color(0xFF8E8E8E)
                                            : Color(0xFF695858),
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(
                              width: MediaQuery.of(context).size.width * 0.05,
                            ),
                            Flexible(
                              flex: 1,
                              child: TextField(
                                style: GoogleFonts.plusJakartaSans(
                                  color:
                                      provider.isDarkMode ? Colors.white : Colors.black,
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
                                          provider.isDarkMode
                                              ? Color(0xFFCDCDCD)
                                              : Color(0xFF696969),
                                    ),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(8),
                                    borderSide: BorderSide(
                                      color:
                                          provider.isDarkMode
                                              ? Color(0xFFCDCDCD)
                                              : Color(0xFF696969),
                                      width: 2,
                                    ),
                                  ),
                                  hintText: "SEARCH BY EMAIL",
                                  hintStyle: GoogleFonts.plusJakartaSans(
                                    color:
                                        provider.isDarkMode
                                            ? Color(0xFF8E8E8E)
                                            : Color(0xFF695858),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.symmetric(
                          horizontal: 150,
                          vertical: 20,
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Flexible(
                              flex: 1,
                              child: TextField(
                                style: GoogleFonts.plusJakartaSans(
                                  color:
                                      provider.isDarkMode ? Colors.white : Colors.black,
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
                                          provider.isDarkMode
                                              ? Color(0xFFCDCDCD)
                                              : Color(0xFF696969),
                                    ),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(8),
                                    borderSide: BorderSide(
                                      color:
                                          provider.isDarkMode
                                              ? Color(0xFFCDCDCD)
                                              : Color(0xFF696969),
                                      width: 2,
                                    ),
                                  ),
                                  hintText: "SEARCH BY NAME",
                                  hintStyle: GoogleFonts.plusJakartaSans(
                                    color:
                                        provider.isDarkMode
                                            ? Color(0xFF8E8E8E)
                                            : Color(0xFF695858),
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(
                              width: MediaQuery.of(context).size.width * 0.05,
                            ),
                            Flexible(
                              flex: 1,
                              child: TextField(
                                // THIS NEEDS TO BE A DROPDOWN MENU
                                style: GoogleFonts.plusJakartaSans(
                                  color:
                                      provider.isDarkMode ? Colors.white : Colors.black,
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
                                          provider.isDarkMode
                                              ? Color(0xFFCDCDCD)
                                              : Color(0xFF696969),
                                    ),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(8),
                                    borderSide: BorderSide(
                                      color:
                                          provider.isDarkMode
                                              ? Color(0xFFCDCDCD)
                                              : Color(0xFF696969),
                                      width: 2,
                                    ),
                                  ),
                                  hintText: "SEARCH BY ROLE",
                                  hintStyle: GoogleFonts.plusJakartaSans(
                                    color:
                                        provider.isDarkMode
                                            ? Color(0xFF8E8E8E)
                                            : Color(0xFF695858),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.only(right: 150),
                        padding: EdgeInsets.only(
                          left: MediaQuery.of(context).size.width * 0.6,
                        ),
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            padding: EdgeInsets.symmetric(horizontal: 1),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                            backgroundColor: Colors.transparent,
                            shadowColor: Colors.transparent,
                          ),
                          onPressed: () {
                            print("Search button pressed");
                          },
                          child: Ink(
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                colors: [Color(0xFFFFB608), Color(0xFFFF2553)],
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
                                "SEARCH",
                                style: GoogleFonts.plusJakartaSans(
                                  color: Colors.white,
                                  fontSize: 18,
                                  fontWeight: FontWeight.w500,
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
            },
          ),
        ],
      ),
    );
  }
}
